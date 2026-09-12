//
//  SampleDepends.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// Sample 自身的依赖收束：画廊内部使用的「固定颜色」一律写死 HEX，
    /// 不通过 `.dtb.create` 走主题，保证画廊自身 UI 不随当前 mode 变化。
    ///
    /// 参照 ``DTB.DiskUsageDepends`` 的形式。颜色对应 `SportTheme/colors.json` 的 light 值。
    struct SampleDepends {

        // --- color ---

        /// FF7700
        static func themeColor() -> UIColor { UIColor.dtb.hex("FF7700") }

        /// FFB87A
        static func theme2Color() -> UIColor { UIColor.dtb.hex("FFB87A") }

        /// 15171F
        static func textColor() -> UIColor { UIColor.dtb.hex("15171F") }

        /// 73778C
        static func text2Color() -> UIColor { UIColor.dtb.hex("73778C") }

        /// 434656
        static func text3Color() -> UIColor { UIColor.dtb.hex("434656") }

        /// FFFFFF
        static func text4Color() -> UIColor { UIColor.dtb.hex("FFFFFF") }

        /// AFB1BC
        static func textDisabledColor() -> UIColor { UIColor.dtb.hex("AFB1BC") }

        /// EEF0F7
        static func borderColor() -> UIColor { UIColor.dtb.hex("EEF0F7") }

        /// F5F7FA
        static func bgColor() -> UIColor { UIColor.dtb.hex("F5F7FA") }

        /// FFFFFF
        static func bg2Color() -> UIColor { UIColor.dtb.hex("FFFFFF") }

        /// EEF0F7
        static func bg3Color() -> UIColor { UIColor.dtb.hex("EEF0F7") }

        /// F05746
        static func dangerColor() -> UIColor { UIColor.dtb.hex("F05746") }

        /// 5393F1
        static func linkColor() -> UIColor { UIColor.dtb.hex("5393F1") }

        /// CCCCCC
        static func placeholderColor() -> UIColor { UIColor.dtb.hex("CCCCCC") }

        /// 434656
        static func buttonColor() -> UIColor { UIColor.dtb.hex("434656") }

        /// FFF4F0
        static func button2Color() -> UIColor { UIColor.dtb.hex("FFF4F0") }

        /// EEF0F7
        static func button3Color() -> UIColor { UIColor.dtb.hex("EEF0F7") }

        /// FFFFFF
        static func button4Color() -> UIColor { UIColor.dtb.hex("FFFFFF") }

        /// 606871
        static func arrowColor() -> UIColor { UIColor.dtb.hex("606871") }
    }
}
