//
//  BAMyEventsViewController.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit

class BAMyEventsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    private let refreshControl = UIRefreshControl()
    private var headers: [String] = []
    private var detailVC: BAQRCodeViewController?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DataItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>
    
    let models: [Section] = [
        Section(
            title: "待参加的活动".localized(),
            events: [
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
            ]
        ),
        Section(
            title: "已完成的活动".localized(),
            events: [
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
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "我的活动".localized()
        
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
extension BAMyEventsViewController {
    
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
    
    private func configureAppearance() {
        if isDarkMode {
            collectionView.backgroundColor = UIColor(hex: "151515")
        } else {
            collectionView.backgroundColor = UIColor(hex: "F2F2F7")
        }
    }
    
    private func makeDataSource() -> DataSource {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Section> { cell, indexPath, header in
            var content = cell.defaultContentConfiguration()
            content.text = header.title
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        let itemCellRegistration = UICollectionView.CellRegistration<BAMyEventsCollectionViewCell, BAEvent> { cell, indexPath, item in
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
                
            case .event(let event):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: itemCellRegistration,
                    for: indexPath,
                    item: event
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
            
            let listItems = section.events.map {
                DataItem.event($0)
            }
            
            sectionSnapshot.append(listItems, to: headerItem)
            
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: animates)
        }
    }
    
    private func configureModels(with events: [BAEvent]) {
        applySnapshot()
    }
    
    @objc private func didRefresh() {
        startLoading(for: .score)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stopLoading(for: .score)
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func showEventDetail(for item: BAEvent?, at indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "BAQRCodeViewController")
        as! BAQRCodeViewController
        
        self.detailVC = detailVC
        
        detailVC.eventItem = item
        detailVC.resignDidTap = { [weak self] in
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
}


// MARK: CollectionView Delegate -
extension BAMyEventsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BAMyEventsCollectionViewCell else { return }
        
        cell.backgroundColor = UIColor(hex: "F8F8F8")
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        showEventDetail(for: cell.item, at: indexPath)
    }
}


extension BAMyEventsViewController {
    
    struct Section: Hashable, Identifiable {
        let id = UUID().uuidString
        
        var title: String
        var events: [BAEvent]
    }
    
    enum DataItem: Hashable {
        case section(Section)
        case event(BAEvent)
    }
}
