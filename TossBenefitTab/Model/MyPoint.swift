//
//  MyPoint.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import Foundation

struct MyPoint: Hashable {
    var point: Int
    
}

extension MyPoint {
    static let `default` = MyPoint(point: 0) // `default` : 디폴트로 사용할 수 있는 값 
}
