//
//  AviatorHomeVCPage.swift
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//

import UIKit
import GoogleUtilities
import FirebaseCore

class AviatorHomeVCPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func flappyAction(_ sender: Any) {
        self.sendEventName(withName: "AviatorflappyAction")
        GULLoggerWrapper.log(with: .info, withService: Bundle.main.bundleIdentifier ?? "AviatorHomeVCPage", withCode: "100", withMessage: "flappyAction", withArgs: getVaList([1]))
    }
    
    @IBAction func flyPractices(_ sender: Any) {
        self.sendEventName(withName: "AviatorflyPractices")
        GULLoggerWrapper.log(with: .info, withService: Bundle.main.bundleIdentifier ?? "AviatorHomeVCPage", withCode: "100", withMessage: "flyPractices", withArgs: getVaList([1]))
    }
    
    @IBAction func planeFly(_ sender: Any) {
        self.sendEventName(withName: "AviatorplaneFly")
        GULLoggerWrapper.log(with: .info, withService: Bundle.main.bundleIdentifier ?? "AviatorHomeVCPage", withCode: "100", withMessage: "planeFly", withArgs: getVaList([1]))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
