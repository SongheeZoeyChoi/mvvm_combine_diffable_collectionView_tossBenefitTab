//
//  ButtonBenefitViewModel.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import Foundation

final class ButtonBenefitViewModel {
    @Published var benefit: Benefit = .today
    @Published var benefitDetails: BenefitDetails = .default
    
    init(benefit: Benefit) {
        self.benefit = benefit
    }
    
    func fetchDetails() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.benefitDetails = .default
        }
    }
}
