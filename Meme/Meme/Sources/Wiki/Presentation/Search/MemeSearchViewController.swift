//
//  MemeSearchViewController.swift
//  Meme-release
//
//  Created by 임현규 on 8/3/25.
//

import UIKit
import Combine

final class MemeSearchViewController: BaseViewController {
    typealias SearchDataSource = UICollectionViewDiffableDataSource<MemeSearchSection, MemeSearchDisplayItem>
    private var dataSource: SearchDataSource?
    
    private lazy var searchTextField: SearchTextField = {
        let textField = SearchTextField()
        textField.setPlaceHolder(Constants.SearchTextField.placeHolder)
        textField.layer.cornerRadius = Constants.SearchTextField.cornerRadius
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.register(MemeSearchGridCell.self, forCellWithReuseIdentifier: MemeSearchGridCell.identifier)
        collectionView.register(MemeSearchListCell.self, forCellWithReuseIdentifier: MemeSearchListCell.identifier)
        collectionView.register(MemeSearchEmptyCell.self, forCellWithReuseIdentifier: MemeSearchEmptyCell.identifier)
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    override func configureUI() {
        [ searchTextField, collectionView ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.SearchTextField.top),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.SearchTextField.leading),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.SearchTextField.trailing),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.SearchTextField.height),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.CollectionView.top),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.CollectionView.leading),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.CollectionView.trailing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.CollectionView.bottom)
        ])
    }
    
    func configureDataSource() {
        dataSource = SearchDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .list(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeSearchListCell.identifier, for: indexPath) as? MemeSearchListCell else { return .none }
                cell.updateUI(item)
                return cell
            case .grid(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeSearchGridCell.identifier, for: indexPath) as? MemeSearchGridCell else { return .none }
                cell.updateUI(item.thumbnail)
                return cell
            case .empty:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeSearchEmptyCell.identifier, for: indexPath) as? MemeSearchEmptyCell else { return .none }
                return cell
            }
        })
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else { return nil }
            return self.makeLayoutSection(for: section)
        }
    }

    func makeLayoutSection(for section: MemeSearchSection) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: section.itemSize)
        item.contentInsets = section.itemInset

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: section.groupSize,
            repeatingSubitem: item,
            count: section.groupCount
        )

        return NSCollectionLayoutSection(group: group)
    }
}

private extension MemeSearchViewController {
    enum Constants {
        enum SearchTextField {
            static let top: CGFloat = 20
            static let leading: CGFloat = 10
            static let trailing: CGFloat = 10
            static let height: CGFloat = 40
            static let placeHolder = "검색어를 입력해주세요."
            static let cornerRadius: CGFloat = 20
        }
        
        enum CollectionView {
            static let top: CGFloat = 10
            static let leading: CGFloat = 10
            static let trailing: CGFloat = 10
            static let bottom: CGFloat = 10
        }
    }
}
