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
    private var memeDummyData: [MemeSearchItem] = []
    private var categoriesDummyData: [CategoryItem] = []
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = CustomColor.black(.black).color
        collectionView.register(MemeSearchGridCell.self, forCellWithReuseIdentifier: MemeSearchGridCell.identifier)
        collectionView.register(SearchCategoryCell.self, forCellWithReuseIdentifier: SearchCategoryCell.identifier)
        collectionView.register(MemeSearchHeaderView.self, forSupplementaryViewOfKind: MemeSearchHeaderView.identifier, withReuseIdentifier: MemeSearchHeaderView.identifier)
        return collectionView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }

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
    override func bind() {
        setDummyData()
        var snapshot = Snapshot()
        snapshot.appendSections([.category, .grid])
        snapshot.appendItems(categoriesDummyData.map { .category($0) }, toSection: .category)
        snapshot.appendItems(memeDummyData.map { .grid($0) }, toSection: .grid)
        dataSource?.apply(snapshot, animatingDifferences: true)
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

// MARK: - TEST

private extension MemeCategoryViewController {
    func setDummyData() {
        for _ in (0..<50) {
            for j in (2010..<2025) {
                memeDummyData += [.init(thumbnail: .init(year: j, title: "\(j)", hashtag: ["hastag1", "hastag2", "hastag3"], imageURL: ""), usage: "usageusageusageusageusageusageusage", source: "sourcesourcesourcesourcesourcesource")]
            }
        }
        
        categoriesDummyData = [
            .init(id: 1, title: "직장·공부", imageURL: ""),
            .init(id: 2, title: "날씨", imageURL: ""),
            .init(id: 3, title: "캐릭터", imageURL: ""),
            .init(id: 4, title: "인간관계", imageURL: ""),
            .init(id: 5, title: "인간관계", imageURL: ""),
            .init(id: 6, title: "인간관계", imageURL: ""),
        ]
    }
}
