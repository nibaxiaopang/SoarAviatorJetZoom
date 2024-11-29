//
//  File.swift
//  SoarAviatorJetZoom
//
//  Created by jin fu on 2024/11/29.
//


import SpriteKit
import ImageIO

extension SKTexture {
    /// Creates an array of SKTextures from a GIF file.
    /// - Parameter gifName: The name of the GIF file in the app's bundle.
    /// - Returns: An array of SKTextures extracted from the GIF.
    static func textures(fromGif gifName: String) -> [SKTexture]? {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = NSData(contentsOfFile: path) as Data?,
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Failed to load GIF: \(gifName)")
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var textures: [SKTexture] = []

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: cgImage)
                textures.append(texture)
            }
        }

        return textures
    }
}
