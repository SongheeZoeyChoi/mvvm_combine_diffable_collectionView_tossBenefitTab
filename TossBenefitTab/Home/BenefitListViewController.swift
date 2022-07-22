//
//  BenefitListViewController.swift
//  TossBenefitTab
//
//  Created by Songhee Choi on 2022/07/22.
//

import UIKit
import Combine

class BenefitListViewController: UIViewController {
    
    // today
    // 사용자는 포인트를 볼 수 있다.
    // 사용자는 오늘의 혜택을 볼 수 있다.
    
    // other
    // 사용자는 나머지 혜택 리스트를 볼 수 있다.
    
    // 사용자는 포인트 셀을 눌렀을 때 포인트 상세뷰로 넘어간다
    // 사용자는 혜택 관련 셀을 눌렀을 때 혜택 상세뷰로 넘어간다.
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = AnyHashable // 모델 여러개 사용할 때 Hashble 프로토콜을 따라할때 구현체 프로토콜 타입을 넣어준다 //AnyHashable : 여러가지 형태의 Hashble 프로토콜을 따를 때 선언해준다.
    enum Section: Int {
        case today
        case other
    }
    var datasource: UICollectionViewDiffableDataSource<Section, Item>! // 프로토콜 타입이 아닌 구현체 타입을 넣어준다
    
    // 이건 처음부터 데이터 있을 때 나타내는거고 //
//    var todaySectionItems: [AnyHashable] = TodaySectionItem(point: .default, today: .today).setionItems // [MyPoint.default, Benefit.today] // 두개를 하나로 표현
//    var otherSectionItems: [AnyHashable] = Benefit.others
    
    // --> 처음부터 데이터가 없다고 했을 때(네트워크로 데이터 가져올 때) //
//    @Published var todaySectionItems: [AnyHashable] = []
//    @Published var otherSectionItems: [AnyHashable] = []
    // --> ViewModel
    let viewModel = BenefitListViewModel()
    
    var subscription = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureCollectionView()
        bind()
        viewModel.fetchItems()
    }
    
    private func setupUI() {
        navigationItem.title = "혜택"
    }
    private func configureCollectionView() {
        // TODO: CollectionVIew //
        // - data, presentation, layout
        
        // presentation
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            let cell = self.configureCell(for: section, item: item, collectionView: collectionView, indexPath: indexPath)
                    
            return cell
        })
        
        // data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.today, .other])
        snapshot.appendItems([], toSection: .today)
        snapshot.appendItems([], toSection: .other)
        datasource.apply(snapshot)
        
        // layout
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }
    
    private func bind() {
        // output: data
        viewModel.$todaySectionItems
            .receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(items: items, section: .today)
            }.store(in: &subscription)
        
        viewModel.$otherSectionItems
            .receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(items: items, section: .other)
            }.store(in: &subscription)
        
        // input: user action
        viewModel.benefitDidTapped
            .receive(on: RunLoop.main)
            .sink { benefit in
                let sb = UIStoryboard(name: "ButtonBenefit", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ButtonBenefitViewController") as! ButtonBenefitViewController
                vc.viewModel = ButtonBenefitViewModel(benefit: benefit)
                self.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &subscription)
        
        viewModel.pointDidTapped
            .receive(on: RunLoop.main)
            .sink { point in
                let sb = UIStoryboard(name: "MyPoint", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MyPointViewController") as! MyPointViewController
                vc.viewModel = MyPointViewModel(point: point)
                self.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &subscription)
    }
    
    private func applySnapshot(items: [Item], section: Section) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func configureCell(for section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        
        switch section {
        case .today:
            if let point = item as? MyPoint {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPointCell", for: indexPath) as! MyPointCell
                cell.configure(item: point)
                return cell
            }else if let benefit = item as? Benefit {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayBenefitCell", for: indexPath) as! TodayBenefitCell
                cell.configure(item: benefit)
                return cell
            }else {
                return nil
            }
        case .other:
            if let benefit = item as? Benefit {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BenefitCell", for: indexPath) as! BenefitCell
                cell.configure(item: benefit)
                return cell
            } else {
                return nil 
            }
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }

}


extension BenefitListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource.itemIdentifier(for: indexPath)
        print("---> \(item)")
        
        if let benefit = item as? Benefit {
            viewModel.benefitDidTapped.send(benefit)
        } else if let point = item as? MyPoint {
            viewModel.pointDidTapped.send(point)
        } else {
            //no - op
        }
    }
}
