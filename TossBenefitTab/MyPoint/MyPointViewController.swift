//
//  MyPointViewController.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import UIKit

class MyPointViewController: UIViewController {

    @IBOutlet weak var pointLabel: UILabel!
    var point: MyPoint = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.largeTitleDisplayMode = .never  // 라지타이틀 안보이게

    }
    

   
}
