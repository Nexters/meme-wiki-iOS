//
//  MemeMainViewController.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit
import Combine

class MemeMainViewController: UIViewController {
    
    typealias Section = Lobby.Section
    typealias Item = Lobby.Item
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var viewModel: MemeMainViewModel = {
        let repository = LobbyRepository()
        return MemeMainViewModel(
            lobbyUseCase: DefaultLobbyUseCase(
                categoriesUseCase: DefaultCategoriesUseCase(repository: CategoryRepository()),
                topRatedUseCase: DefaultTopRatedUseCase(repository: repository),
                mostSharedUseCase: DefaultMostSharedUseCase(repository: repository)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray10
        setupNavigation()
        layoutCollectionView()
        setupDataSource()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.fetch()
        
        viewModel.$lobby
            .sink { [weak self] item in
                guard let item else { return }
                self?.applySnapshot(item)
            }.store(in: &subscriptions)
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .imageLogo), style: .plain, target: self, action: #selector(scrollToTop))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .iconSearch), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    @objc private func scrollToTop() {
        collectionView.scrollRectToVisible(
            CGRect(origin: .zero, size: CGSize(width: 1, height: 1)),
            animated: true)
    }
    
    private func layoutCollectionView() {
        let layout = createLayout()
        layout.register(
            MemeMainTopRatedDecorationView.self,
            forDecorationViewOfKind: MemeMainTopRatedDecorationView.elementKind)
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .gray10
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.register(
            MemeMainBannerCell.self,
            forCellWithReuseIdentifier: MemeMainBannerCell.identifier)
        collectionView.register(
            MemeMainCategoryCell.self,
            forCellWithReuseIdentifier: MemeMainCategoryCell.identifier)
        collectionView.register(
            MemeMainTopRatedCell.self,
            forCellWithReuseIdentifier: MemeMainTopRatedCell.identifier)
        collectionView.register(
            MemeMainMostSharedNestedCell.self,
            forCellWithReuseIdentifier: MemeMainMostSharedNestedCell.identifier)
        collectionView.register(
            MemeMainBannerFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MemeMainBannerFooterView.identifier)
        collectionView.register(
            MemeMainCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MemeMainCategoryHeaderView.identifier)
        collectionView.register(
            MemeMainTopRatedHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MemeMainTopRatedHeaderView.identifier)
        collectionView.register(
            MemeMainMostsharedHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MemeMainMostsharedHeaderView.identifier)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item.type {
            case .banner:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MemeMainBannerCell.identifier, for: indexPath)
                guard let bannerCell = cell as? MemeMainBannerCell else { return .none }
                bannerCell.configureCell(with: item)
                return cell
            case .category:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MemeMainCategoryCell.identifier, for: indexPath)
                guard let categoryCell = cell as? MemeMainCategoryCell else { return .none }
                categoryCell.configureCell(with: item)
                return cell
            case .topRated:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MemeMainTopRatedCell.identifier, for: indexPath)
                guard let topRatedCell = cell as? MemeMainTopRatedCell else { return .none }
                topRatedCell.configureCell(with: item)
                return cell
            case .mostShared:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MemeMainMostSharedNestedCell.identifier, for: indexPath)
                guard let mostSharedCell = cell as? MemeMainMostSharedNestedCell else { return .none }
                mostSharedCell.configureCell(with: item)
                mostSharedCell.didTapCell = { [weak self] selectedId in
                    self?.gotoMemeDetail(id: selectedId)
                }
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                switch indexPath.section {
                case 1: // .category
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MemeMainCategoryHeaderView.identifier,
                        for: indexPath) as! MemeMainCategoryHeaderView
                    return header
                case 2: // .topRated
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MemeMainTopRatedHeaderView.identifier,
                        for: indexPath) as? MemeMainTopRatedHeaderView
                    return header
                case 3: // .mostShared
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MemeMainMostsharedHeaderView.identifier,
                        for: indexPath) as? MemeMainMostsharedHeaderView
                    
                    // 현재 스냅샷에서 실제 섹션을 가져와서 countdown 값 전달
                    if let currentSnapshot = self?.dataSource.snapshot(),
                       let section = currentSnapshot.sectionIdentifiers[safe: indexPath.section],
                       case .mostShared(let countdown) = section {
                        header?.configureHeader(upcomingFetch: countdown)
                    }
                    return header
                default:
                    return UICollectionReusableView()
                }
            } else if kind == UICollectionView.elementKindSectionFooter {
                if indexPath.section == 0 { // .banner
                    let footer = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MemeMainBannerFooterView.identifier,
                        for: indexPath) as? MemeMainBannerFooterView
                    footer?.pageControl.numberOfPages = self?.sectionItemCount(for: 0) ?? 0
                    footer?.pageControl.currentPage = 0
                    footer?.pageControl.isUserInteractionEnabled = false
                    return footer
                }
            }
            return nil
        }
    }
    
    private func sectionItemCount(for sectionIndex: Int) -> Int {
        guard let lobby = viewModel.lobby else { return 0 }
        switch sectionIndex {
        case 0: // .banner
            return 4
        case 1: // .category
            return lobby.categories.count
        case 2: // .topRated
            return lobby.topRatedMemes.count
        case 3: // .mostShared
            return 1
        default:
            return 0
        }
    }
}

extension MemeMainViewController {
    private func applySnapshot(_ item: Lobby) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 공통 섹션 추가 함수
        func appendSectionItems<T>(
            _ section: Section,
            from array: [T],
            type: Lobby.Section,
            memeId: (T) -> Int?,
            content: (T) -> String,
            imageURL: (T) -> String?
        ) {
            snapshot.appendSections([section])
            let items = array.enumerated().map { index, element in
                Item(
                    memeId: memeId(element),
                    type: type,
                    content: content(element),
                    imageURL: imageURL(element),
                    indexPath: IndexPath(item: index, section: section.index)
                )
            }
            snapshot.appendItems(items, toSection: section)
        }
        
        // 배너 (0~2 고정)
        appendSectionItems(
            .banner,
            from: Array(0..<4),
            type: .banner,
            memeId: { _ in nil },
            content: { _ in "" },
            imageURL: { _ in nil }
        )
        
        // 카테고리
        appendSectionItems(
            .category,
            from: item.categories,
            type: .category,
            memeId: { _ in nil },
            content: { $0.title },
            imageURL: { $0.imageURL }
        )
        
        // 인급밈
        appendSectionItems(
            .topRated,
            from: item.topRatedMemes,
            type: .topRated,
            memeId: { $0.id },
            content: { $0.title },
            imageURL: { $0.imageURL }
        )
        
        // 밈열차
        let countdown = item.mostSharedItem.nextFetchTime
        let section = Section.mostShared(countdown: countdown)
        snapshot.appendSections([section])
        let mostSharedItems = item.mostSharedItem.memes.enumerated().map { index, meme in
            Item(
                memeId: meme.id,
                type: section,
                content: meme.title,
                imageURL: meme.imageURL,
                indexPath: IndexPath(
                    item: index, section: section.index)
            )
        }
        let sectionItem = Item(
            type: section,
            content: "",
            childs: mostSharedItems,
            indexPath: IndexPath(
                item: item.mostSharedItem.memes.count, section: section.index)
        )
        snapshot.appendItems([sectionItem], toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension MemeMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        if let memeId = item?.memeId {
            Log.info("밈 상세 이동 \(memeId)", .ui)
            gotoMemeDetail(id: memeId)
        }
        if Section(rawIndex: indexPath.section) == .banner, indexPath.item == 0 {
            gotoMemeQuiz()
        }
    }
}

// MARK: - Compositional Layout
extension MemeMainViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0: // .banner
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .fractionalWidth(0.63))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .fractionalWidth(0.63))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 30, leading: 14, bottom: 0, trailing: 14)
                
                /// Setup Footer
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(6))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom)
                footer.contentInsets = NSDirectionalEdgeInsets(
                    top: 18, leading: 0, bottom: 0, trailing: 0)
                
                section.boundarySupplementaryItems = [footer]
                section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
                    guard let self = self else { return }
                    let itemWidth = env.container.contentSize.width * 0.92
                    let page = Int(round(offset.x / itemWidth))
                    if let footer = self.collectionView.supplementaryView(
                        forElementKind: UICollectionView.elementKindSectionFooter,
                        at: IndexPath(item: 0, section: 0)
                    ) as? MemeMainBannerFooterView {
                        footer.pageControl.currentPage = page
                    }
                }
                return section
                
            case 1: // .category
                let itemFixSize = CGFloat(74)
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(itemFixSize),
                    heightDimension: .absolute(122))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let screenWidth = UIScreen.main.bounds.width
                let horizontalInsets = CGFloat(28)
                let interItemSpacing = CGFloat(17)
                
                let availableWidth = screenWidth - horizontalInsets
                let itemCount = 4
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(availableWidth),
                    heightDimension: .absolute(122))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: itemCount)
                
                group.interItemSpacing = .fixed(interItemSpacing)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 10, leading: 14, bottom: 60, trailing: 14)
                section.interGroupSpacing = 12
                
                /// Setup header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(130))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                
                header.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 10, trailing: 4)
                section.boundarySupplementaryItems = [header]
                return section
                
            case 2: // .topRated
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .absolute(204))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(204))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(11)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 36, leading: 14, bottom: 64, trailing: 14)
                
                /// setup header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(90))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                /// setup background
                let background = NSCollectionLayoutDecorationItem.background(
                    elementKind: MemeMainTopRatedDecorationView.elementKind)
                section.decorationItems = [background]
                return section
                
            case 3: // .mostShared
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(354))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(354))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(11)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 0, bottom: 100, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                
                /// setup header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(256))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            default: return nil
            }
        }
    }
}
