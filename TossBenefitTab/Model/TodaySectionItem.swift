//
//  TodaySectionItem.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import Foundation

struct TodaySectionItem {
    var point: MyPoint
    let today: Benefit
    
    var setionItems: [AnyHashable] {
        return [point, today]
    }
}


extension TodaySectionItem {
    static let mock = TodaySectionItem (
        point: MyPoint.default,
        today: Benefit.walk
    )
}
