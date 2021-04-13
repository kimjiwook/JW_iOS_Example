//
//  Constants.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/04/12.
//
/*
 공통적으로 사용되는 변수 들
 */

import UIKit

// Font 관련
let APP_FONT = "Apple SD Gothic Neo"
let APP_FONT_BOLD = "AppleSDGothicNeo-Bold"
let APP_FONT_LIGHT = "AppleSDGothicNeo-Light"

// FontSize 관련
let FONT_TITLE = 16
let FONT_CONTENT = 14
let FONT_SUB_CONTENT = 12

extension UIColor {
    //    convenience : 보조 이니셜라이져
    convenience init(r:Int, g:Int, b:Int, alpha:CGFloat) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    /// 2020. 02. 20 Kimjiwook
    /// Hex To Rgb
    /// - Parameter hex: #ffffff or ffffff 둘다 가능
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
                      blue: CGFloat(rgbValue & 0x0000FF)/255.0,
                      alpha: 1.0)
        }
    }
    
    // Hex 값으로 변경하기.
    var hexString:NSString {
        // CGColorGetComponents(self.CGColor)
        let colorRef = self.cgColor.components!

        let r:CGFloat = colorRef[0]
        let g:CGFloat = colorRef[1]
        let b:CGFloat = colorRef[2]

        return NSString(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}
