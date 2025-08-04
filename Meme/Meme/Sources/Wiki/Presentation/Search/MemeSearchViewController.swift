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
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    override func configureUI() {
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.SearchTextField.top),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.SearchTextField.leading),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.SearchTextField.trailing),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.SearchTextField.height)
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
    }
}
