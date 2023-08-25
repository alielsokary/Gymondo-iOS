//
//  UIRefreshControl+TestHelpers.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
