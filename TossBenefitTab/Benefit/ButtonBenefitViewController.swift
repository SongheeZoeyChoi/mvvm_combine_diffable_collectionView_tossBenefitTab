//
//  ButtonBenefitViewController.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import UIKit
import Combine

class ButtonBenefitViewController: UIViewController {
    
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var vStackView: UIStackView!
    
//    var benefit: Benefit = .today
//    var benefitDetails: BenefitDetails = .default
    var viewModel: ButtonBenefitViewModel!
    var subscription = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
//        addGuides()
//        ctaButton.setTitle(benefit.title, for: .normal) --> bind output 으로변경
        viewModel.fetchDetails()
    }
    
    private func setupUI() {
        ctaButton.layer.masksToBounds = true
        ctaButton.layer.cornerRadius = 5
        navigationItem.largeTitleDisplayMode = .never // 라지타이틀 안보이게 
    }
    
    private func bind() {
        // output : data //
        viewModel.$benefit
            .receive(on: RunLoop.main)
            .sink { benefit in
                self.ctaButton.setTitle(benefit.ctaTitle, for: .normal)
            }.store(in: &subscription)
        
        viewModel.$benefitDetails
            .compactMap{$0}
            .receive(on: RunLoop.main)
            .sink { details in
                self.addGuides(details: details)
            }.store(in: &subscription)
        
        
    }
    
    private func addGuides(details: BenefitDetails) {
        let guidesView = vStackView.arrangedSubviews.filter { $0 is BenefitGuideView } // 이미 가이드뷰가 있는 상황이라면
        guard guidesView.isEmpty else {return} // 최초 1회만 세팅.(비어있는 상황일때만 아래 코드 실행)
        
        let guideViews: [BenefitGuideView] = details.guides.map { guide in
            let guideView = BenefitGuideView(frame: .zero)
            guideView.icon.image = UIImage(systemName: guide.iconName)
            guideView.title.text = guide.guide
            return guideView
        }
        
        guideViews.forEach { view in
            self.vStackView.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
    }
}
