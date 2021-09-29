//
//  KAScoreViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/29.
//

import UIKit
import SnapKit

class KAScoreViewController: UIViewController {
    private lazy var dataSource = makeDataSource()
    private var sections: [KASection] = [
        KASection(
            title: "2018-2019",
            scores: [
                KAScore(
                    year: "2018-2019",
                    term: 1,
                    className: "C语言",
                    classCode: "",
                    classIndex: "",
                    classType: "",
                    points: 3,
                    credits: 1.5,
                    score: 80,
                    redoScore: 0
                ),
                KAScore(
                    year: "2018-2019",
                    term: 1,
                    className: "C++",
                    classCode: "",
                    classIndex: "",
                    classType: "",
                    points: 3,
                    credits: 1.5,
                    score: 80,
                    redoScore: 0
                ),
                KAScore(
                    year: "2018-2019",
                    term: 1,
                    className: "Java",
                    classCode: "",
                    classIndex: "",
                    classType: "",
                    points: 3,
                    credits: 1.5,
                    score: 80,
                    redoScore: 0
                ),
            ]
        ),
        KASection(
            title: "2019-2020",
            scores: [
                KAScore(
                    year: "2019-2020",
                    term: 1,
                    className: "大数据",
                    classCode: "",
                    classIndex: "",
                    classType: "",
                    points: 3,
                    credits: 1.5,
                    score: 80,
                    redoScore: 0
                ),
                KAScore(
                    year: "2019-2020",
                    term: 1,
                    className: "马克思主义",
                    classCode: "",
                    classIndex: "",
                    classType: "",
                    points: 3,
                    credits: 1.5,
                    score: 80,
                    redoScore: 0
                ),
            ]
        )
    ]
    
    typealias DataSource = UICollectionViewDiffableDataSource<KASection, DataItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<KASection, DataItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>
    
    private let collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise.circle.fill"),
            style: .done,
            target: self,
            action: #selector(refreshDidTap)
        )
        
        configureCollectionView()
        applySnapshot()
    }
}

// MARK: Private Methods
extension KAScoreViewController {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func makeDataSource() -> DataSource {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, KASection> { cell, indexPath, header in
            var content = cell.defaultContentConfiguration()
            content.text = header.title
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        let itemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, KAScore> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "graduationcap.fill")
            content.text = item.className
            cell.contentConfiguration = content
        }
        
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, listItem in
            switch listItem {
            case .section(let section):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: headerCellRegistration,
                    for: indexPath,
                    item: section
                )
                return cell
                
            case .score(let score):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: itemCellRegistration,
                    for: indexPath,
                    item: score
                )
                return cell
            }
        }
        
        return dataSource
    }
    
    private func applySnapshot(animates: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: animates)
        
        for section in sections {
            var sectionSnapshot = SectionSnapshot()
            
            let headerItem = DataItem.section(section)
            sectionSnapshot.append([headerItem])
            
            let listItems = section.scores.map {
                DataItem.score($0)
            }
            sectionSnapshot.append(listItems, to: headerItem)
            
            sectionSnapshot.expand([headerItem])
            
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: animates)
        }
    }
    
    @objc private func refreshDidTap() {
        
    }
}


extension KAScoreViewController: UICollectionViewDelegate {
    
}


extension KAScoreViewController {
    
    enum DataItem: Hashable {
        case section(KASection)
        case score(KAScore)
    }
}