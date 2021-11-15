//
//  BAAllEventsViewController.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit
import SnapKit
import Defaults

class BAAllEventsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private lazy var dataSource = makeDataSource()
    private var detailVC: BAEventDetailViewController?
    
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
            place: "二教308 反馈区别还烦请",
            maxCount: 100,
            regCount: 67,
            status: 4
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
            status: 4
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
            status: 7
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
            status: 5
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
            status: 5
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
            status: 8
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
            status: 8
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
            status: 4
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
            status: 7
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
            status: 5
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "百叶计划活动列表".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(filterDidTap)
        )
        
        configureCollectionView()
        configureModels(with: [])
        configureAppearance()
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
    
    private func showEventDetail(for item: BAEvent?, at indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "BAEventDetailViewController")
        as! BAEventDetailViewController
        
        self.detailVC = detailVC
        
        detailVC.eventItem = item
        detailVC.cancelDidTap = { [weak self] in
            self?.dismissEventDetail()
        }
        
        view.addSubview(detailVC.view)
        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func dismissEventDetail() {
        if detailVC.isNil { return }
        
        detailVC?.view.removeFromSuperview()
        detailVC = nil
    }
    
    @objc private func didRefresh() {
        startLoading(for: .score)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stopLoading(for: .score)
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func filterDidTap() {
        
    }
}


// MARK: CollectionView Delegate
extension BAAllEventsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BAAllEventsCollectionViewCell else { return }
        
        cell.backgroundColor = UIColor(hex: "F8F8F8")
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        showEventDetail(for: cell.item, at: indexPath)
    }
}


extension BAAllEventsViewController {
    
    enum Section {
        case main
    }
}
