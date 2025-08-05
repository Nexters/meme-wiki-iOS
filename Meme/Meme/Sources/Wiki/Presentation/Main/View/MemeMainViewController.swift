//
//  MemeMainViewController.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

class MemeMainViewController: UIViewController {
    
    typealias Section = MemeMain.Model.Section
    typealias Item = MemeMain.Model.Item
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutCollectionView()
        setupDataSource()
        applySnapshot()
    }
    
    private func layoutCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
        collectionView.register(
            MemeMainCustomCell.self,
            forCellWithReuseIdentifier: MemeMainCustomCell.identifier)
        collectionView.register(
            MemeMainCategoryCell.self,
            forCellWithReuseIdentifier: MemeMainCategoryCell.identifier)
        collectionView.register(
            MemeMainTopRatedCell.self,
            forCellWithReuseIdentifier: MemeMainTopRatedCell.identifier)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item.type {
            case .custom:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeMainCustomCell.identifier, for: indexPath)
                guard let customCell = cell as? MemeMainCustomCell else { return .none }
                customCell.configureCell(with: item)
                return cell
            case .category:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeMainCategoryCell.identifier, for: indexPath)
                guard let customCell = cell as? MemeMainCategoryCell else { return .none }
                customCell.configureCell(with: item)
                return cell
            case .topRated:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeMainTopRatedCell.identifier, for: indexPath)
                guard let customCell = cell as? MemeMainTopRatedCell else { return .none }
                customCell.configureCell(with: item)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath)
                cell.contentView.backgroundColor = .systemGray5
                cell.contentView.layer.cornerRadius = 12
                cell.contentView.layer.masksToBounds = true
                let label = UILabel()
                label.text = item.content
                label.font = .systemFont(ofSize: 14, weight: .bold)
                label.textColor = .black
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
                return cell
                
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            let items = (0..<sectionItemCount(for: section)).map {
                Item(type: section, content: "\(section) \(section) \($0 + 1)")
            }
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func sectionItemCount(for section: Section) -> Int {
        switch section {
        case .custom:
            return 3
        case .category:
            return 4
        case .topRated:
            return 8
        case .mostShared:
            return 4
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .custom:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .absolute(218))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .absolute(218))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 30, leading: 14, bottom: 18, trailing: 14)
                return section
                
            case .category:
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
                    top: 18, leading: 14, bottom: 8, trailing: 14)
                section.interGroupSpacing = 12
                return section

            case .topRated:
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
                    top: 12, leading: 14, bottom: 16, trailing: 14)
                return section
                
            case .mostShared:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .estimated(172))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(172))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(11)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 0, bottom: 100, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        }
    }
}

