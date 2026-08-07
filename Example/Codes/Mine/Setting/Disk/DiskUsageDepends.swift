//
//  DTB.DiskUsageDepends.swift
//  Setting
//
//  Created by moonShadow on 2025/7/18
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    ///
    struct DiskUsageDepends {
        
        // --- fake cal ---
        
        /// 清理完成后会有少许文件被立即生成，体现在 UI 上就是每次清理都有 x KB 一直显示
        ///
        /// 给一个最小值 (KB)，比这个值小的，UI 上统一认为是 0
        static func fakeZeroSize() -> Int64 {
            return 200 * 1024
        }
        
        /// 实际占用远小于总容量，给一个最小比值，确保占用图 UI 上至少能看到一部分 APP 占用
        static func minUsedPercent() -> CGFloat {
            return 0.01
        }
        
        // --- text ---
        
        ///
        static func appName() -> String {
            return (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "APP"
        }
        
        /// "清理"
        static func cleanText() -> String { return .dtb.create("deep.disk.clean") }
        
        /// "清理成功"
        static func cleanSuccessText() -> String { return .dtb.create("deep.disk.clean.success") }
        
        /// "正在计算..."
        static func loadingText() -> String { return .dtb.create("deep.disk.loading") }
        
        /// "尚未计算"
        static func unloadText() -> String { return .dtb.create("deep.disk.unload") }
        
        /// "重新计算"
        static func reloadText() -> String { return .dtb.create("deep.disk.reload") }
        
        /// "上次计算: {t})"
        static func loadTimeText(_ t: String) -> String {
            return .dtb.create(format: "deep.disk.load.time", t)
        }
        
        /// "手机已用"
        static func phoneUsedText() -> String { return .dtb.create("deep.disk.phone.used") }
        
        /// "剩余空间"
        static func phoneFreeText() -> String { return .dtb.create("deep.disk.phone.free") }
        
        /// "数据缓存"
        static func cacheText() -> String { return .dtb.create("deep.disk.data.cache") }
        
        /// "使用过程中产生的临时数据，清理后流量消耗会增加，但不影响正常使用。"
        static func cacheDescText() -> String { return .dtb.create("deep.disk.data.cache.desc") }
        
        /// "{APP}已用空间"
        static func usageHintText() -> String {
            return .dtb.create(format: "deep.disk.app.used", appName())
        }
        
        /// "占据手机 {p}% 存储空间"
        static func usagePercentText(_ p: String) -> String {
            return .dtb.create(format: "deep.disk.app.used.p", p)
        }
        
        // --- color ---
        
        /// F5F7FA
        static func backgroundColor() -> UIColor { return .dtb.create("bg") }
        
        /// FFFFFF
        static func backgroundColor2() -> UIColor { return .dtb.create("bg2") }

        /// F05746
        static func themeColor() -> UIColor { return .dtb.create("danger") }
        
        /// 15171F
        static func textColor() -> UIColor { return .dtb.create("text") }
        
        /// 73778C
        static func lightTextColor() -> UIColor { return .dtb.create("text2") }
        
        /// FFFFFF
        static func buttonTitleColor() -> UIColor { return .dtb.create("text2") }
        
        /// ABABAB
        static func progressUsedColor() -> UIColor { return .dtb.create("text_disabled") }
        
        /// EEF0F7
        static func progressFreeColor() -> UIColor { return .dtb.create("bg3") }
        
    }
    
}
