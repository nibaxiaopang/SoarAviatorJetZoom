//
//  AviatorStartVCPage.swift
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//

import UIKit

class AviatorStartVCPage: UIViewController {
    
    @IBOutlet weak var activityIndView: UIActivityIndicatorView!
    var airADSDataDic: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.activityIndView.hidesWhenStopped = true
        
        self.featchADSData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func featchADSData() {
        if UIDevice.current.model.contains("iPad") {
            return
        }
                
        self.activityIndView.startAnimating()
        postDeviceDatas { dataDic in
            if let dataDic = dataDic {
                self.airADSDataDic = dataDic
                self.configAdsData()
            } else {
                self.activityIndView.stopAnimating()
            }
        }
    }
    
    private func configAdsData() {
        if let aDic = airADSDataDic {
            let cCode: String = aDic["countryCode"] as? String ?? ""
            let adsData: [String: Any]? = aDic["jsonObject"] as? Dictionary
            if let adsData = adsData {
                AviatorUUidInstance.shared().eventParams = adsData["event"] as? [String: String] ?? Dictionary()
                let adUrlDic:[String: [String: String]] = adsData["ISOurl"] as? [String: [String: String]] ?? Dictionary()
                if let codeData = adUrlDic[cCode], let url = codeData["data"], !url.isEmpty {
                    UserDefaults.standard.set(adsData["adcc"] , forKey: "adsArr")
                    AviatorUUidInstance.shared().typeStr = codeData["type"] ?? ""
                    sShowAdView(url)
                    return
                }
            }
            self.activityIndView.stopAnimating()
        }
    }
    
    private func postDeviceDatas(completion: @escaping ([String: Any]?) -> Void) {
        
        let url = URL(string: "https://\(AviatorHostPath)pzdl.top/open/postDeviceDatas")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "appLocaleInfo": Locale.current.description,
            "appModel": UIDevice.current.model,
            "appKey": "072dc359e75f44698e0dd9e918b58750",
            "appPackageId": Bundle.main.bundleIdentifier ?? "com.fly.game.SoarAviator.JetZoom",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }

}
