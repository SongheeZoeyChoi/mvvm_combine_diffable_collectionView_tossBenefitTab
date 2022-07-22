//
//  MyPointViewModel.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import Foundation

final class MyPointViewModel {
    @Published var point: MyPoint
    
    init(point: MyPoint) {
        self.point = point
    }
}
