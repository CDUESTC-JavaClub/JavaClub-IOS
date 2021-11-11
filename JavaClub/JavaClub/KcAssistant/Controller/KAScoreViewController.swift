//
//  KAScoreViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/29.
//

import UIKit
import SwiftUI
import SnapKit

class KAScoreViewController: UIViewController {
    private lazy var dataSource = makeDataSource()
    private let refreshControl = UIRefreshControl()
    private var models: [KASection] = []
    private var headers: [String] = []
    
    typealias DataSource = UICollectionViewDiffableDataSource<KASection, DataItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<KASection, DataItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>
    
    private let collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        layoutConfig.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "学期成绩查询".localized()
        
        refreshControl.addTarget(
            self,
            action: #selector(didRefresh),
            for: .valueChanged
        )
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        configureAppearance()
        configureCollectionView()
        didRefresh()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
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
    
    private func configureAppearance() {
        if isDarkMode {
            collectionView.backgroundColor = UIColor(hex: "151515")
        } else {
            collectionView.backgroundColor = UIColor(hex: "F2F2F7")
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
        
        let itemCellRegistration = UICollectionView.CellRegistration<ScoreCollectionViewCell, KAScore> { cell, indexPath, item in
            cell.item = item
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
        snapshot.appendSections(models)
        dataSource.apply(snapshot, animatingDifferences: animates)
        
        for section in models {
            var sectionSnapshot = SectionSnapshot()
            
            let headerItem = DataItem.section(section)
            sectionSnapshot.append([headerItem])
            
            let listItems = section.scores.map {
                DataItem.score($0)
            }
            
            sectionSnapshot.append(listItems, to: headerItem)
            
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: animates)
        }
    }
    
    private func configureModels(with scores: [KAScore]) {
        var _models: [KASection] = []
        var modelDict = [String: [KAScore]]()
        
        scores.forEach { item in
            let term = item.term == 1 ? "上".localized() : "下".localized()
            let title = String.localized("%@ 学年 - %@", with: "\(item.year)", "\(term)")
            
            if modelDict[title] != nil {
                modelDict[title]!.append(item)
            } else {
                modelDict[title] = [item]
            }
        }
        
        for (_key, _value) in modelDict.sorted(by: { $0.0 > $1.0 }) {
            let section = KASection(title: _key, scores: _value)
            _models.append(section)
        }
        
        models = _models
        
        applySnapshot()
    }
    
    @objc private func didRefresh() {
        startLoading(for: .score)
        
        JCAccountManager.shared.getScore { [weak self] result in
            switch result {
            case .success(let scores):
                self?.configureModels(with: scores)
                self?.stopLoading(for: .score)
                
            case .failure(let error):
                if error == .notLoginJW {
                    print("DEBUG: Used JW Before Login.")
                } else {
                    print("DEBUG: Refresh Score With Error: \(String(describing: error))")
                }
                self?.stopLoading(for: .score)
            }
        }
        
        refreshControl.endRefreshing()
    }
}


extension KAScoreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension KAScoreViewController {
    
    enum DataItem: Hashable {
        case section(KASection)
        case score(KAScore)
    }
}
