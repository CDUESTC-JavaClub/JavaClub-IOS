//
//  BACreditsViewController.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/15.
//

import UIKit
import SnapKit

class BACreditsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private lazy var dataSource = makeDataSource()
    
    @IBOutlet var headerView: DesignableView!
    @IBOutlet var scoreView: DesignableView!
    @IBOutlet var bxScoreLabel: UILabel!
    @IBOutlet var jmScoreLabel: UILabel!
    @IBOutlet var dxScoreLabel: UILabel!
    @IBOutlet var mdScoreLabel: UILabel!
    @IBOutlet var statusContainerView: DesignableView!
    @IBOutlet var statusLabel: UILabel!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BAScoreAdding>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BAScoreAdding>
    typealias CellRegistration = UICollectionView.CellRegistration<BAMyCreditsCollectionViewCell, BAScoreAdding>
    
    let models: [BAScoreAdding] = [
        BAScoreAdding(
            eventName: "社会实践 1",
            eventID: 1,
            score: 2,
            type: "jm",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 2",
            eventID: 2,
            score: 2,
            type: "bx",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 3",
            eventID: 3,
            score: 2,
            type: "jm",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 4",
            eventID: 4,
            score: 2,
            type: "dx",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 5",
            eventID: 5,
            score: 2,
            type: "dx",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 6",
            eventID: 6,
            score: 2,
            type: "jm",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 7",
            eventID: 7,
            score: 2,
            type: "md",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 8",
            eventID: 8,
            score: 2,
            type: "jm",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 9",
            eventID: 9,
            score: 2,
            type: "md",
            reason: "正常签到扫码加分"
        ),
        BAScoreAdding(
            eventName: "社会实践 10",
            eventID: 10,
            score: 2,
            type: "bx",
            reason: "正常签到扫码加分"
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "百叶积分".localized()
        
        configureCollectionView()
        configureModels(with: [])
        configureAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Private Methods -
extension BACreditsViewController {
    
    private func configureAppearance() {
        if isDarkMode {
            collectionView.backgroundColor = UIColor(hex: "151515")
        } else {
            collectionView.backgroundColor = UIColor(hex: "F2F2F7")
        }
        
        headerView.isDark = isDarkMode
        scoreView.isDark = isDarkMode
    }
    
    private func configureCollectionView() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        refreshControl.addTarget(
            self,
            action: #selector(didRefresh),
            for: .valueChanged
        )
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = CellRegistration { cell, indexPath, item in
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
        
        if
            let bx = Int(bxScoreLabel.text ?? "0"),
            let jm = Int(jmScoreLabel.text ?? "0"),
            let dx = Int(dxScoreLabel.text ?? "0"),
            let md = Int(mdScoreLabel.text ?? "0"),
            bx >= 10 || jm >= 30 || dx >= 10 || md >= 10
        {
            statusLabel.text = "已达标".localized()
            statusContainerView.backgroundColor = .systemGreen
        } else {
            statusLabel.text = "未达标".localized()
            statusContainerView.backgroundColor = .systemYellow
        }
    }
    
    @objc private func didRefresh() {
        startLoading(for: .myCredits)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stopLoading(for: .myCredits)
            self?.refreshControl.endRefreshing()
        }
    }
}


// MARK: CollectionView Delegate -
extension BACreditsViewController: UICollectionViewDelegate {
    
    
}


extension BACreditsViewController {
    
    enum Section {
        case main
    }
}
