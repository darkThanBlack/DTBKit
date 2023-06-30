//
//  XMColor.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import UIKit

extension DTB.Color {
    
    ///
    public enum XM {}
}

extension DTB.Color.XM {
    
    //MARK: - Pure
    
    ///00 - 32  A: 000000
    public enum Black {
        ///#000000
        public static func A() -> UIColor {
            return DTB.Color.hex(0x000000)
        }
        ///#030303
        public static func B() -> UIColor {
            return DTB.Color.hex(0x030303)
        }
        ///#0B0B0B
        public static func C() -> UIColor {
            return DTB.Color.hex(0x0B0B0B)
        }
    }
    ///33 - 64
    public enum DarkGray {
        ///#333333
        public static func A() -> UIColor {
            return DTB.Color.hex(0x333333)
        }
    }
    ///65 - 96
    public enum Gray {
        ///#666666
        public static func A() -> UIColor {
            return DTB.Color.hex(0x666666)
        }
        ///#8B8B8B
        public static func B() -> UIColor {
            return DTB.Color.hex(0x8B8B8B)
        }
        ///#898989
        public static func C() -> UIColor {
            return DTB.Color.hex(0x898989)
        }
        ///#909090
        public static func D() -> UIColor {
            return DTB.Color.hex(0x909090)
        }
    }
    ///97 - C8
    public enum LightGray {
        ///#999999
        public static func A() -> UIColor {
            return DTB.Color.hex(0x999999)
        }
        ///#B2B2B2
        public static func B() -> UIColor {
            return DTB.Color.hex(0xB2B2B2)
        }
    }
    ///C9 - FF
    public enum White {
        ///#FFFFFF
        public static func A() -> UIColor {
            return DTB.Color.hex(0xFFFFFF)
        }
        ///#D8D8D8
        public static func B() -> UIColor {
            return DTB.Color.hex(0xD8D8D8)
        }
        ///#E8E8E8
        public static func C() -> UIColor {
            return DTB.Color.hex(0xE8E8E8)
        }
        ///#EEEEEE
        public static func D() -> UIColor {
            return DTB.Color.hex(0xEEEEEE)
        }
        ///#F0F2F5
        public static func E() -> UIColor {
            return DTB.Color.hex(0xF0F2F5)
        }
        ///#F4F4F4
        public static func F() -> UIColor {
            return DTB.Color.hex(0xF4F4F4)
        }
        ///#F7F7F7
        public static func G() -> UIColor {
            return DTB.Color.hex(0xF7F7F7)
        }
        ///#F9F9F9
        public static func H() -> UIColor {
            return DTB.Color.hex(0xF9F9F9)
        }
        ///#FAFAFA
        public static func I() -> UIColor {
            return DTB.Color.hex(0xFAFAFA)
        }
        ///#CCCCCC
        public static func J() -> UIColor {
            return DTB.Color.hex(0xCCCCCC)
        }
        ///#F6F6F6
        public static func K() -> UIColor {
            return DTB.Color.hex(0xF6F6F6)
        }
        ///#F6F7F8
        public static func L() -> UIColor {
            return DTB.Color.hex(0xF6F7F8)
        }
        ///#F1F3F6
        public static func M() -> UIColor {
            return DTB.Color.hex(0xF1F3F6)
        }
    }
    
    // MARK: - Colorful
    
    public enum Red {
        ///#FFE2E2
        public static func A() -> UIColor {
            return DTB.Color.hex(0xFFE2E2)
        }
        ///#FFC3C3
        public static func B() -> UIColor {
            return DTB.Color.hex(0xFFC3C3)
        }
        ///#FF7D7C
        public static func C() -> UIColor {
            return DTB.Color.hex(0xFF7D7C)
        }
        ///#F77B5D
        public static func D() -> UIColor {
            return DTB.Color.hex(0xF77B5D)
        }
        ///#FF6767
        public static func E() -> UIColor {
            return DTB.Color.hex(0xFF6767)
        }
        ///#FF4F4F
        public static func F() -> UIColor {
            return DTB.Color.hex(0xFF4F4F)
        }
        ///#EC4B35
        public static func G() -> UIColor {
            return DTB.Color.hex(0xEC4B35)
        }
        ///#FE3824
        public static func H() -> UIColor {
            return DTB.Color.hex(0xFE3824)
        }
        ///#FFB0B0
        public static func I() -> UIColor {
            return DTB.Color.hex(0xFFB0B0)
        }
        ///#FE4035
        public static func J() -> UIColor {
            return DTB.Color.hex(0xFE4035)
        }
        ///#FF9494
        public static func K() -> UIColor {
            return DTB.Color.hex(0xFF9494)
        }
        ///#FFEDED
        public static func L() -> UIColor {
            return DTB.Color.hex(0xFFEDED)
        }
    }
    
    public enum Orange {
        ///#FF8534
        public static func A() -> UIColor {
            return DTB.Color.hex(0xFF8534)
        }
        ///#FFAB1A
        public static func B() -> UIColor {
            return DTB.Color.hex(0xFFAB1A)
        }
        ///#FBB03B
        public static func C() -> UIColor {
            return DTB.Color.hex(0xFBB03B)
        }
        ///#FFBA43
        public static func D() -> UIColor {
            return DTB.Color.hex(0xFFBA43)
        }
        ///#FFD285
        public static func E() -> UIColor {
            return DTB.Color.hex(0xFFD285)
        }
        ///#FD7923
        public static func F() -> UIColor {
            return DTB.Color.hex(0xFD7923)
        }
        ///#FFB000
        public static func G() -> UIColor {
            return DTB.Color.hex(0xFFB000)
        }
        ///#FFEFD3
        public static func H() -> UIColor {
            return DTB.Color.hex(0xFFEFD3)
        }
        ///#FFBE4D
        public static func I() -> UIColor {
            return DTB.Color.hex(0xFFBE4D)
        }
        ///#DC600A
        public static func J() -> UIColor {
            return DTB.Color.hex(0xDC600A)
        }
        ///#D0B07A
        public static func K() -> UIColor {
            return DTB.Color.hex(0xD0B07A)
        }
        ///#FFF9EE
        public static func L() -> UIColor {
            return DTB.Color.hex(0xFFF9EE)
        }
        ///#FFF9F3
        public static func M() -> UIColor {
            return DTB.Color.hex(0xFFF9F3)
        }
        ///#FC9C6B
        public static var N: UIColor {
            return DTB.Color.hex(0xFC9C6B)
        }
        ///#FD7B17
        public static func O() -> UIColor {
            return DTB.Color.hex(0xFD7B17)
        }
        ///#F6D6AD
        public static func P() -> UIColor {
            return DTB.Color.hex(0xF6D6AD)
        }
        ///#FFCD76
        public static func Q() -> UIColor {
            return DTB.Color.hex(0xFFCD76)
        }
        ///#FF6934
        public static func R() -> UIColor {
            return DTB.Color.hex(0xFF6934)
        }
        ///#FFF9E8
        public static func S() -> UIColor {
            return DTB.Color.hex(0xFFF9E8)
        }
        ///#FFF3E1
        public static func T() -> UIColor {
            return DTB.Color.hex(0xFFF3E1)
        }
        ///#FC7419
        public static func U() -> UIColor {
            return DTB.Color.hex(0xFC7419)
        }
        ///#FFE77E
        public static func V() -> UIColor {
            return DTB.Color.hex(0xFFE77E)
        }
        ///#FFBF40
        public static func W() -> UIColor {
            return DTB.Color.hex(0xFFBF40)
        }
        ///#FF7519
        public static func X() -> UIColor {
            return DTB.Color.hex(0xFF7519)
        }
    }
    
    public enum Yellow {
        ///#FFD133
        public static func A() -> UIColor {
            return DTB.Color.hex(0xFFD133)
        }
        ///#FFE9DA
        public static func B() -> UIColor {
            return DTB.Color.hex(0xFFE9DA)
        }
    }
    
    public enum Green {
        ///#66DB7A
        public static func A() -> UIColor {
            return DTB.Color.hex(0x66DB7A)
        }
        ///#28C251
        public static func B() -> UIColor {
            return DTB.Color.hex(0x28C251)
        }
        ///#50E3C2
        public static func C() -> UIColor {
            return DTB.Color.hex(0x50E3C2)
        }
        ///#44DB5E
        public static func D() -> UIColor {
            return DTB.Color.hex(0x44DB5E)
        }
        
    }
    
    public enum Cyan {
        ///#3BBDAA
        public static func A() -> UIColor {
            return DTB.Color.hex(0x3BBDAA)
        }
         ///#96A1AE
         public static func B() -> UIColor {
             return DTB.Color.hex(0x96A1AE)
         }
    }
    
    public enum Blue {
        ///#A6DEFF
        public static func A() -> UIColor {
            return DTB.Color.hex(0xA6DEFF)
        }
        ///#58B7EF
        public static func B() -> UIColor {
            return DTB.Color.hex(0x58B7EF)
        }
        ///#2F91EB
        public static func C() -> UIColor {
            return DTB.Color.hex(0x2F91EB)
        }
        ///#5D98E0
        public static func D() -> UIColor {
            return DTB.Color.hex(0x5D98E0)
        }
        ///#1572DD
        public static func E() -> UIColor {
            return DTB.Color.hex(0x1572DD)
        }
        ///#2F90EA
        public static func F() -> UIColor {
            return DTB.Color.hex(0x2F90EA)
        }
        ///#78BFFA
        public static func G() -> UIColor {
            return DTB.Color.hex(0x78BFFA)
        }
        ///#8ED2F8
        public static func H() -> UIColor {
            return DTB.Color.hex(0x8ED2F8)
        }
        ///#A6DDFF
        public static func I() -> UIColor {
            return DTB.Color.hex(0xA6DDFF)
        }
        ///#40AAE8
        public static func J() -> UIColor {
            return DTB.Color.hex(0x40AAE8)
        }
        ///#394655
        public static func K() -> UIColor {
            return DTB.Color.hex(0x394655)
        }
        ///#0076FF
        public static func L() -> UIColor {
            return DTB.Color.hex(0x0076FF)
        }
        ///#E6ECF3
        public static func M() -> UIColor {
            return DTB.Color.hex(0xE6ECF3)
        }
        ///#3296FA
        public static func O() -> UIColor {
            return DTB.Color.hex(0x3296FA)
        }
        ///#3490FF
        public static var N: UIColor {
            return DTB.Color.hex(0x3490FF)
        }
    }
    
    public enum Purple {
        ///#8E91B5
        public static func A() -> UIColor {
            return DTB.Color.hex(0x8E91B5)
        }
        ///#AABBDB
        public static func B() -> UIColor {
            return DTB.Color.hex(0xAABBDB)
        }
        
    }
    
    public enum Brown {
        ///#564334
        public static func A() -> UIColor {
            return DTB.Color.hex(0x564334)
        }
        ///#22201F
        public static func B() -> UIColor {
            return DTB.Color.hex(0x22201F)
        }
        ///#C7881B
        public static func C() -> UIColor {
            return DTB.Color.hex(0xC7881B)
        }
        ///#B96B35
        public static func D() -> UIColor {
            return DTB.Color.hex(0xB96B35)
        }
        ///#C38313
        public static func E() -> UIColor {
            return DTB.Color.hex(0xC38313)
        }
    }
}
