//
//  ColorConstants.swift
//  QAre
//
//  Created by Debashish on 09/06/24.
//

import Foundation
import UIKit

class ColorConstants {
    public let primaryColor = "#2F3C7E"
    public let secondartColor = "#FBEAEB"
}


public extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    /// Create Color Instance from HexCode String Value
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /// Get translucent color of an instance - 50%
    func translucent() -> UIColor{
        return self.withAlphaComponent(0.50)
    }
    
    /// Get hazy color of an instance - 75%
    func hazy() -> UIColor{
        return self.withAlphaComponent(0.75)
    }
    
    /// Get transparent color of an instance - 25%
    func transparent() -> UIColor{
        return self.withAlphaComponent(0.25)
    }
    
}


extension UIButton {
    func setThemedButton(title: String?, image: UIImage?, isImagerequired: Bool = false) {
        self.layer.cornerRadius = CGFloat(15)
//        self.titleLabel?.text = title
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        
        self.setTitleColor(UIColor(hexString: ColorConstants.init().primaryColor), for: .normal)
        self.setTitleColor(UIColor(hexString: ColorConstants.init().primaryColor), for: .highlighted)
        if isImagerequired {
            self.setImage(image, for: .normal)
            self.setImage(image, for: .highlighted)
        }
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.backgroundColor = UIColor(hexString: ColorConstants.init().secondartColor)
//        self.titleLabel?.textColor = UIColor(hexString: ColorConstants.init().primaryColor)
    }
    func setCircularBtn() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
