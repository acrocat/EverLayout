//
//  UIColor+EverLayout.swift
//  JSONLayout
//
//  Created by Dale Webster on 17/01/2017.
//  Copyright © 2017 TabApps. All rights reserved.
//

import UIKit

extension UIColor
{
    /// Get UIColor instance from the name of a color
    ///
    /// - Parameter name: Color name
    /// - Returns: UIColor instance
    @objc internal static func color (fromName name : String) -> UIColor?
    {
        switch name
        {
        case "black":
            return UIColor.black
        case "blue":
            return UIColor.blue
        case "brown":
            return UIColor.brown
        case "clear":
            return UIColor.clear
        case "cyan":
            return UIColor.cyan
        case "darkGray":
            return UIColor.darkGray
        case "gray":
            return UIColor.gray
        case "green":
            return UIColor.green
        case "lightGray":
            return UIColor.lightGray
        case "magenta":
            return UIColor.magenta
        case "orange":
            return UIColor.orange
        case "purple":
            return UIColor.purple
        case "red":
            return UIColor.red
        case "white":
            return UIColor.white
        case "yellow":
            return UIColor.yellow
        default:
            return nil
        }
    }
    
    @objc internal static func name (ofColor color : UIColor) -> String {
        switch color {
            case UIColor.black:
                return "black"
            case UIColor.blue:
                return "blue"
            case UIColor.brown:
                return "brown"
            case UIColor.clear:
                return "clear"
            case UIColor.cyan:
                return "cyan"
            case UIColor.darkGray:
                return "darkGray"
            case UIColor.gray:
                return "gray"
            case UIColor.green:
                return "green"
            case UIColor.lightGray:
                return "lightGray"
            case UIColor.magenta:    
                return "magenta"
            case UIColor.orange:
                return "orange"
            case UIColor.purple:
                return "purple"
            case UIColor.red:
                return "red"
            case UIColor.white:
                return "white"
            case UIColor.yellow:
                return "yellow"
            default:
                return "clear"
            }
    }
    
    /// Get UIColor instance from the hex string
    ///
    /// - Parameter name: Hex String EG #333333
    /// - Returns: UIColor instance
    @objc convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
