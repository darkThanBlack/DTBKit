//
//  Alerts.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    ///
    public struct AlertAction {

        public var title: String? = nil

        public var handler: ((Self) -> Void)? = nil

        public var extra: Any? = nil

        public init(title: String? = nil, handler: ((Self) -> Void)? = nil, extra: Any? = nil) {
            self.title = title
            self.handler = handler
            self.extra = extra
        }
    }

    ///
    public struct Alert {

        public var title: String? = nil

        public var message: String? = nil

        public var actions: [AlertAction] = []

        public var extra: Any? = nil

        public init(title: String? = nil, message: String? = nil, actions: [AlertAction] = [], extra: Any? = nil) {
            self.title = title
            self.message = message
            self.actions = actions
            self.extra = extra
        }
    }

}

extension DTB {

    ///
    public struct AttributeAlertAction {

        public var title: NSAttributedString? = nil

        public var handler: ((Self) -> Void)? = nil

        public var extra: Any? = nil

        public init(title: NSAttributedString? = nil, handler: ((Self) -> Void)? = nil, extra: Any? = nil) {
            self.title = title
            self.handler = handler
            self.extra = extra
        }
    }

    ///
    public struct AttributeAlert {

        public var title: NSAttributedString? = nil

        public var message: NSAttributedString? = nil

        public var actions: [AttributeAlertAction] = []

        public var extra: Any? = nil

        public init(title: NSAttributedString? = nil, message: NSAttributedString? = nil, actions: [AttributeAlertAction] = [], extra: Any? = nil) {
            self.title = title
            self.message = message
            self.actions = actions
            self.extra = extra
        }
    }

}
