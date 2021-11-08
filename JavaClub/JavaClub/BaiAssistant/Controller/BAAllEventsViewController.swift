//
//  BAAllEventsViewController.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit
import SnapKit

class BAAllEventsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BAEvent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BAEvent>
    
    let models: [BAEvent] = [
        BAEvent(
            eventID: 1,
            eventName: "社会实践 1",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "md",
            place: "二教308",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 2",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "dx",
            place: "二教109",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 3",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "bx",
            place: "二教110",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 4",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "jm",
            place: "二教312",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 5",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "dx",
            place: "二教401",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 6",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "bx",
            place: "二教403",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 7",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "md",
            place: "二教504",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 8",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "dx",
            place: "二教103",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 9",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "jm",
            place: "二教105",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
        BAEvent(
            eventID: 1,
            eventName: "社会实践 10",
            coverUrl: "http://i-1-zswxy.52pictu.com/2020/0819/b39ab197281e4700985e47f082e4d4dc.jpg",
            hospital: "",
            startDate: Date(),
            type: "jm",
            place: "二教314",
            maxCount: 100,
            regCount: 67,
            status: "报名中"
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "百叶计划活动列表".localized()
        
        configureCollectionView()
        configureAppearance()
        configureModels(with: [])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


extension BAAllEventsViewController {
    
    private func configureAppearance() {
        if isDarkMode {
            collectionView.backgroundColor = UIColor(hex: "151515")
        } else {
            collectionView.backgroundColor = UIColor(hex: "F2F2F7")
        }
    }
    
    private func configureCollectionView() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<BAAllEventsCollectionViewCell, BAEvent> { cell, indexPath, item in
            cell.item = item
        }
        
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(animates: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animates)
    }
    
    private func configureModels(with events: [BAEvent]) {
        applySnapshot()
    }
}


extension BAAllEventsViewController: UICollectionViewDelegate {
    
}


extension BAAllEventsViewController {
    
    enum Section {
        case main
    }
}
