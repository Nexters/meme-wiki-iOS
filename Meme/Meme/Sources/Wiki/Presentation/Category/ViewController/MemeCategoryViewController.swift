//
//  MemeCategoryViewController.swift
//  Meme
//
//  Created by 임현규 on 8/10/25.
//

import UIKit
import Combine

final class MemeCategoryViewController: BaseViewController {
    typealias SearchDataSource = UICollectionViewDiffableDataSource<MemeCategorySection, MemeCategoryDisplayItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MemeCategorySection, MemeCategoryDisplayItem>

    // MARK: - Properties
    private var dataSource: SearchDataSource?
    private let viewModel: CategoryViewModel
    private var cancellables = Set<AnyCancellable>()
    private var selectedCategoryIndexPath: IndexPath? = IndexPath(row: 0, section: 0)

    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = CustomColor.black(.black).color
        collectionView.register(MemeSearchGridCell.self, forCellWithReuseIdentifier: MemeSearchGridCell.identifier)
        collectionView.register(SearchCategoryCell.self, forCellWithReuseIdentifier: SearchCategoryCell.identifier)
        collectionView.register(MemeSearchHeaderView.self, forSupplementaryViewOfKind: MemeSearchHeaderView.identifier, withReuseIdentifier: MemeSearchHeaderView.identifier)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    // MARK: - Init
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        Log.debug("MemeCategoryViewController - init", .ui)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureNavigationBar()
    }

    // MARK: - Layout / UI
    override func configureUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Bind
    override func bind() {
        Log.debug("MemeCategoryViewController - bind", .ui)
        viewModel.fetchCategories()
        
        // 카테고리 목록
        viewModel.categoriesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                let selectedCategory = viewModel.getSelectedCategory()
                self.applyCategories(categories)
                self.viewModel.fetchCategoryMeme(selectedCategory)
            }
            .store(in: &cancellables)

        // 현재 선택된 카테고리의 밈 목록
        viewModel.searchCategoryMemePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                guard let items = items else { return }
                self.applyGrid(items)
            }
            .store(in: &cancellables)
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: .iconCheveronLeft), style: .plain, target: self, action: #selector(popViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(resource: .iconSearch), style: .plain, target: self, action: #selector(gotoMemeSearchViewController))

        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white

    }
}

// MARK: - Private Methods

private extension MemeCategoryViewController {
    func selectFirstCategoryCellIfNeeded() {
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
    }
    
    func findHeader() -> MemeSearchHeaderView? {
        guard let header = collectionView.visibleSupplementaryViews(
            ofKind: MemeSearchHeaderView.identifier).first
                as? MemeSearchHeaderView else { return nil }
        return header
    }
}

// MARK: - Configure DiffableDataSource

private extension MemeCategoryViewController {
    func configureDataSource() {
        dataSource = SearchDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .category(let cat):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCategoryCell.identifier, for: indexPath) as? SearchCategoryCell else { return UICollectionViewCell() }
                cell.updateUI(cat)
                return cell
            case .grid(let meme):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeSearchGridCell.identifier, for: indexPath) as? MemeSearchGridCell else { return UICollectionViewCell() }
                cell.updateUI(meme.thumbnail)
                return cell
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] cv, kind, indexPath in
            guard let self = self,
                  let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            else { return UICollectionReusableView() }
            
            if kind == MemeSearchHeaderView.identifier, section == .grid {
                return cv.dequeueReusableSupplementaryView(
                    ofKind: MemeSearchHeaderView.identifier,
                    withReuseIdentifier: MemeSearchHeaderView.identifier,
                    for: indexPath
                )
            }

            return UICollectionReusableView()
        }
    }

    func applyCategories(_ categories: [CategoryItem]) {
        var snap = Snapshot()
        snap.appendSections([.category, .grid])
        snap.appendItems(categories.map { .category($0) }, toSection: .category)

        dataSource?.apply(snap, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            guard !categories.isEmpty else { return }
            guard let header = self.findHeader() else { return }
            let selectedCategory = viewModel.getSelectedCategory()
            let indexPath = IndexPath(item: selectedCategory.id - 1, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            selectedCategoryIndexPath = indexPath
            header.updateUI(selectedCategory.title)
        }
    }

    func applyGrid(_ memes: [MemeSearchItem]) {
        guard var snap = dataSource?.snapshot() else { return }
        let oldItems = snap.itemIdentifiers(inSection: .grid)
        if !oldItems.isEmpty { snap.deleteItems(oldItems) }
        snap.appendItems(memes.map { .grid($0) }, toSection: .grid)
        dataSource?.apply(snap, animatingDifferences: false)
    }
}

// MARK: - Configure CompositionalLayout

private extension MemeCategoryViewController {
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else { return nil }
            switch section {
            case .category: return makeCategorySectionLayout()
            case .grid: return makeMemeSectionLayout()
            }
        }
        
        layout.register(SeparatorDecorationView.self,
                        forDecorationViewOfKind: SeparatorDecorationView.identifier)

        return layout
    }
    
    func makeCategorySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: MemeCategorySection.category.itemSize)
        item.contentInsets = MemeCategorySection.category.itemInset
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: MemeCategorySection.category.groupSize,
            repeatingSubitem: item,
            count: MemeCategorySection.category.groupCount
        )
        let section = NSCollectionLayoutSection(group: group)
        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: SeparatorDecorationView.identifier)
        decoration.contentInsets = MemeCategorySection.category.decorationInset
        section.decorationItems = [decoration]
        section.orthogonalScrollingBehavior = MemeCategorySection.category.scrollingBehavior
        section.contentInsets = MemeCategorySection.category.sectionInset
        return section
    }
    
    func makeMemeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: MemeCategorySection.grid.itemSize)
        item.contentInsets = MemeCategorySection.grid.itemInset
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: MemeCategorySection.grid.groupSize,
            repeatingSubitem: item,
            count: MemeCategorySection.grid.groupCount
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: MemeCategorySection.grid.headerSize,
            elementKind: MemeSearchHeaderView.identifier,
            alignment: .top
        )
        header.contentInsets = MemeCategorySection.grid.headerInset
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = MemeCategorySection.grid.scrollingBehavior
        
        return section
    }
}

// MARK: - UICollectionViewDelegate

extension MemeCategoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        if case let .grid(item) = item {
            gotoMemeDetail(id: item.id)
        }
        
        if case let .category(category) = item {
            guard let header = findHeader() else { return }
            if let prev = selectedCategoryIndexPath, prev != indexPath {
                collectionView.deselectItem(at: prev, animated: false)
            }
            selectedCategoryIndexPath = indexPath
            viewModel.fetchCategoryMeme(category)
            header.updateUI(category.title)
        }
    }
    
    // TODO: - prefetch로 고도화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        let visibleH = scrollView.bounds.height
        if offsetY > contentH - visibleH - 200, contentH > 0 {
            viewModel.fetchNextPage()
        }
    }
}
