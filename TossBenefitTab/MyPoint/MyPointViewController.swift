//
//  MyPointViewController.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import UIKit
import Combine

class MyPointViewController: UIViewController {

    @IBOutlet weak var pointLabel: UILabel!
//    var point: MyPoint = .default
    
    var viewModel: MyPointViewModel!
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never  // 라지타이틀 안보이게
    }

    private func bind() {
        viewModel.$point
            .receive(on: RunLoop.main)
            .sink { point in
                self.pointLabel.text = "\(point.point) 원"
            }.store(in: &subscription)
    }
}
