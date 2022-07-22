//
//  BenefitListViewModel.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import Foundation
import Combine

final class BenefitListViewModel {
    
    @Published var todaySectionItems: [AnyHashable] = []
    @Published var otherSectionItems: [AnyHashable] = []
    
    
    // input : action 
    let benefitDidTapped = PassthroughSubject<Benefit, Never>()
    let pointDidTapped = PassthroughSubject<MyPoint, Never>()
    
    func fetchItems() {
        // 네트워크로 비동기 데이터를 받는 경우를 가정했을 때
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.todaySectionItems = TodaySectionItem(point: .default, today: .today).setionItems
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.otherSectionItems = Benefit.others
        }
    }
}
