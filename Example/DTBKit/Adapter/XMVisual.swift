//
//  XMVisual.swift
//  XMApp
//
//  Created by 徐一丁 on 2020/5/11.
//  Copyright © 2020 jiejing. All rights reserved.
//

import UIKit

/// 小麦 - 视觉定义
///
/// https://stackoverflow.com/questions/41487918/instantiating-a-nested-class-using-nsclassfromstring-in-swift
public class XMVisual: NSObject {
    
    @objc(XMVisualColor)
    public class Color: NSObject {
        
        /// Hex -> UIColor, 需要 alpha 请使用 `withAlphaComponent` 方法
        /// - Parameter hex: 0xFFFFFF
        /// - Returns: alpha == 1.0
        static private func xm_color(hex: Int64) -> UIColor {
            return UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                           green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
                           blue: CGFloat(hex & 0xFF) / 255.0,
                           alpha: 1.0)
        }
        
        /// Hex -> UIColor，适配暗黑模式
        /// - Parameters:
        ///   - unknown: 未指定，iOS 13.0 以下系统版本直接作为色值使用
        ///   - light: 浅色状态
        ///   - dark: 深色状态
        /// - Returns: alpha == 1.0
        static private func xm_dynamicColor(unknown: Int64, light: Int64? = nil, dark: Int64? = nil) -> UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.init { (traitCollection) -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .unspecified:
                        return Color.xm_color(hex: unknown)
                    case .light:
                        return Color.xm_color(hex: light ?? unknown)
                    case .dark:
                        return Color.xm_color(hex: dark ?? unknown)
                    @unknown default:
                        return Color.xm_color(hex: unknown)
                    }
                }
            } else {
                return Color.xm_color(hex: unknown)
            }
        }
        
        //MARK: -
        
        ///00 - 32  A: 000000
        @objc(XMVisualColorBlack)
        public class Black: NSObject {
            ///#000000
            @objc(XMVisualColorBlackA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x000000)
            }
            ///#030303
            @objc(XMVisualColorBlackB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0x030303)
            }
            ///#0B0B0B
            @objc(XMVisualColorBlackC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0x0B0B0B)
            }
        }
        ///33 - 64
        @objc(XMVisualColorDarkGray)
        public class DarkGray: NSObject {
            ///#333333
            @objc(XMVisualColorDarkGrayA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x333333)
            }
        }
        ///65 - 96
        @objc(XMVisualColorGray)
        public class Gray: NSObject {
            ///#666666
            @objc(XMVisualColorGrayA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x666666)
            }
            ///#8B8B8B
            @objc(XMVisualColorGrayB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0x8B8B8B)
            }
            ///#898989
            @objc(XMVisualColorGrayC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0x898989)
            }
            ///#909090
            @objc(XMVisualColorGrayD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0x909090)
            }
        }
        ///97 - C8
        @objc(XMVisualColorLightGray)
        public class LightGray: NSObject {
            ///#999999
            @objc(XMVisualColorLightGrayA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x999999)
            }
            ///#B2B2B2
            @objc(XMVisualColorLightGrayB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xB2B2B2)
            }
        }
        ///C9 - FF
        @objc(XMVisualColorWhite)
        public class White: NSObject {
            ///#FFFFFF
            @objc(XMVisualColorWhiteA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFFFFF)
            }
            ///#D8D8D8
            @objc(XMVisualColorWhiteB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xD8D8D8)
            }
            ///#E8E8E8
            @objc(XMVisualColorWhiteC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0xE8E8E8)
            }
            ///#EEEEEE
            @objc(XMVisualColorWhiteD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0xEEEEEE)
            }
            ///#F0F2F5
            @objc(XMVisualColorWhiteE)
            public static var E: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF0F2F5)
            }
            ///#F4F4F4
            @objc(XMVisualColorWhiteF)
            public static var F: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF4F4F4)
            }
            ///#F7F7F7
            @objc(XMVisualColorWhiteG)
            public static var G: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF7F7F7)
            }
            ///#F9F9F9
            @objc(XMVisualColorWhiteH)
            public static var H: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF9F9F9)
            }
            ///#FAFAFA
            @objc(XMVisualColorWhiteI)
            public static var I: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFAFAFA)
            }
            ///#CCCCCC
            @objc(XMVisualColorWhiteJ)
            public static var J: UIColor {
                return Color.xm_dynamicColor(unknown: 0xCCCCCC)
            }
            ///#F6F6F6
            @objc(XMVisualColorWhiteK)
            public static var K: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF6F6F6)
            }
            ///#F6F7F8
            @objc(XMVisualColorWhiteL)
            public static var L: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF6F7F8)
            }
            ///#F1F3F6
            @objc(XMVisualColorWhiteM)
            public static var M: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF1F3F6)
            }
        }
        
        // MARK: -
        
        @objc(XMVisualColorRed)
        public class Red: NSObject {
            ///#FFE2E2
            @objc(XMVisualColorRedA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFE2E2)
            }
            ///#FFC3C3
            @objc(XMVisualColorRedB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFC3C3)
            }
            ///#FF7D7C
            @objc(XMVisualColorRedC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF7D7C)
            }
            ///#F77B5D
            @objc(XMVisualColorRedD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF77B5D)
            }
            ///#FF6767
            @objc(XMVisualColorRedE)
            public static var E: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF6767)
            }
            ///#FF4F4F
            @objc(XMVisualColorRedF)
            public static var F: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF4F4F)
            }
            ///#EC4B35
            @objc(XMVisualColorRedG)
            public static var G: UIColor {
                return Color.xm_dynamicColor(unknown: 0xEC4B35)
            }
            ///#FE3824
            @objc(XMVisualColorRedH)
            public static var H: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFE3824)
            }
            ///#FFB0B0
            @objc(XMVisualColorRedI)
            public static var I: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFB0B0)
            }
            ///#FE4035
            @objc(XMVisualColorRedJ)
            public static var J: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFE4035)
            }
            ///#FF9494
            @objc(XMVisualColorRedK)
            public static var K: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF9494)
            }
            ///#FFEDED
            @objc(XMVisualColorRedL)
            public static var L: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFEDED)
            }
        }
        
        @objc(XMVisualColorOrange)
        public class Orange: NSObject {
            ///#FF8534
            @objc(XMVisualColorOrangeA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF8534)
            }
            ///#FFAB1A
            @objc(XMVisualColorOrangeB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFAB1A)
            }
            ///#FBB03B
            @objc(XMVisualColorOrangeC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFBB03B)
            }
            ///#FFBA43
            @objc(XMVisualColorOrangeD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFBA43)
            }
            ///#FFD285
            @objc(XMVisualColorOrangeE)
            public static var E: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFD285)
            }
            ///#FD7923
            @objc(XMVisualColorOrangeF)
            public static var F: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFD7923)
            }
            ///#FFB000
            @objc(XMVisualColorOrangeG)
            public static var G: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFB000)
            }
            ///#FFEFD3
            @objc(XMVisualColorOrangeH)
            public static var H: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFEFD3)
            }
            ///#FFBE4D
            @objc(XMVisualColorOrangeI)
            public static var I: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFBE4D)
            }
            ///#DC600A
            @objc(XMVisualColorOrangeJ)
            public static var J: UIColor {
                return Color.xm_dynamicColor(unknown: 0xDC600A)
            }
            ///#D0B07A
            @objc(XMVisualColorOrangeK)
            public static var K: UIColor {
                return Color.xm_dynamicColor(unknown: 0xD0B07A)
            }
            ///#FFF9EE
            @objc(XMVisualColorOrangeL)
            public static var L: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFF9EE)
            }
            ///#FFF9F3
            @objc(XMVisualColorOrangeM)
            public static var M: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFF9F3)
            }
            ///#FC9C6B
            @objc(XMVisualColorOrangeN)
            public static var N: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFC9C6B)
            }
            ///#FD7B17
            @objc(XMVisualColorOrangeO)
            public static var O: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFD7B17)
            }
            ///#F6D6AD
            @objc(XMVisualColorOrangeP)
            public static var P: UIColor {
                return Color.xm_dynamicColor(unknown: 0xF6D6AD)
            }
            ///#FFCD76
            @objc(XMVisualColorOrangeQ)
            public static var Q: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFCD76)
            }
            ///#FF6934
            @objc(XMVisualColorOrangeR)
            public static var R: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF6934)
            }
            ///#FFF9E8
            @objc(XMVisualColorOrangeS)
            public static var S: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFF9E8)
            }
            ///#FFF3E1
            @objc(XMVisualColorOrangeT)
            public static var T: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFF3E1)
            }
            ///#FC7419
            @objc(XMVisualColorOrangeU)
            public static var U: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFC7419)
            }
            ///#FFE77E
            @objc(XMVisualColorOrangeV)
            public static var V: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFE77E)
            }
            ///#FFBF40
            @objc(XMVisualColorOrangeW)
            public static var W: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFBF40)
            }
            ///#FF7519
            @objc(XMVisualColorOrangeX)
            public static var X: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFF7519)
            }
        }
        
        @objc(XMVisualColorYellow)
        public class Yellow: NSObject {
            ///#FFD133
            @objc(XMVisualColorYellowA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFD133)
            }
            ///#FFE9DA
            @objc(XMVisualColorYellowB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xFFE9DA)
            }
        }
        
        @objc(XMVisualColorGreen)
        public class Green: NSObject {
            ///#66DB7A
            @objc(XMVisualColorGreenA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x66DB7A)
            }
            ///#28C251
            @objc(XMVisualColorGreenB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0x28C251)
            }
            ///#50E3C2
            @objc(XMVisualColorGreenC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0x50E3C2)
            }
            ///#44DB5E
            @objc(XMVisualColorGreenD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0x44DB5E)
            }
            
        }
        
        @objc(XMVisualColorCyan)
        public class Cyan: NSObject {
            ///#3BBDAA
           @objc(XMVisualColorCyanA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x3BBDAA)
            }
             ///#96A1AE
            @objc(XMVisualColorCyanB)
             public static var B: UIColor {
                 return Color.xm_dynamicColor(unknown: 0x96A1AE)
             }
        }
        
        @objc(XMVisualColorBlue)
        public class Blue: NSObject {
            ///#A6DEFF
            @objc(XMVisualColorBlueA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0xA6DEFF)
            }
            ///#58B7EF
            @objc(XMVisualColorBlueB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0x58B7EF)
            }
            ///#2F91EB
            @objc(XMVisualColorBlueC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0x2F91EB)
            }
            ///#5D98E0
            @objc(XMVisualColorBlueD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0x5D98E0)
            }
            ///#1572DD
            @objc(XMVisualColorBlueE)
            public static var E: UIColor {
                return Color.xm_dynamicColor(unknown: 0x1572DD)
            }
            ///#2F90EA
            @objc(XMVisualColorBlueF)
            public static var F: UIColor {
                return Color.xm_dynamicColor(unknown: 0x2F90EA)
            }
            ///#78BFFA
            @objc(XMVisualColorBlueG)
            public static var G: UIColor {
                return Color.xm_dynamicColor(unknown: 0x78BFFA)
            }
            ///#8ED2F8
            @objc(XMVisualColorBlueH)
            public static var H: UIColor {
                return Color.xm_dynamicColor(unknown: 0x8ED2F8)
            }
            ///#A6DDFF
            @objc(XMVisualColorBlueI)
            public static var I: UIColor {
                return Color.xm_dynamicColor(unknown: 0xA6DDFF)
            }
            ///#40AAE8
            @objc(XMVisualColorBlueJ)
            public static var J: UIColor {
                return Color.xm_dynamicColor(unknown: 0x40AAE8)
            }
            ///#394655
            @objc(XMVisualColorBlueK)
            public static var K: UIColor {
                return Color.xm_dynamicColor(unknown: 0x394655)
            }
            ///#0076FF
            @objc(XMVisualColorBlueL)
            public static var L: UIColor {
                return Color.xm_dynamicColor(unknown: 0x0076FF)
            }
            ///#E6ECF3
            @objc(XMVisualColorBlueM)
            public static var M: UIColor {
                return Color.xm_dynamicColor(unknown: 0xE6ECF3)
            }
            ///#3296FA
            @objc(XMVisualColorBlueO)
            public static var O: UIColor {
                return Color.xm_dynamicColor(unknown: 0x3296FA)
            }
            ///#3490FF
            @objc(XMVisualColorBlueN)
            public static var N: UIColor {
                return Color.xm_dynamicColor(unknown: 0x3490FF)
            }
        }
        
        @objc(XMVisualColorPurple)
        public class Purple: NSObject {
            ///#8E91B5
            @objc(XMVisualColorPurpleA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x8E91B5)
            }
            ///#AABBDB
            @objc(XMVisualColorPurpleB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0xAABBDB)
            }
            
        }
        
        @objc(XMVisualColorBrown)
        public class Brown: NSObject {
            ///#564334
            @objc(XMVisualColorBrownA)
            public static var A: UIColor {
                return Color.xm_dynamicColor(unknown: 0x564334)
            }
            ///#22201F
            @objc(XMVisualColorBrownB)
            public static var B: UIColor {
                return Color.xm_dynamicColor(unknown: 0x22201F)
            }
            ///#C7881B
            @objc(XMVisualColorBrownC)
            public static var C: UIColor {
                return Color.xm_dynamicColor(unknown: 0xC7881B)
            }
            ///#B96B35
            @objc(XMVisualColorBrownD)
            public static var D: UIColor {
                return Color.xm_dynamicColor(unknown: 0xB96B35)
            }
            ///#C38313
            @objc(XMVisualColorBrownE)
            public static var E: UIColor {
                return Color.xm_dynamicColor(unknown: 0xC38313)
            }
        }
        
        
    }
}

