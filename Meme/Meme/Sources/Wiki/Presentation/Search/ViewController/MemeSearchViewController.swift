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
    typealias Snapshot
    = NSDiffableDataSourceSnapshot<MemeSearchSection, MemeSearchDisplayItem>
    
    private var isLoading: Bool = false
    private var dataSource: SearchDataSource?
    private var viewModel: MemeSearchViewModel
    private var subscription = Set<AnyCancellable>()
    
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
        collectionView.backgroundColor = CustomColor.black(.black).color
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - init
    
    init(viewModel: MemeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.CollectionView.bottom)
        ])
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: .iconCheveronLeft), style: .plain, target: self, action: #selector(popViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(resource: .iconHome), style: .plain, target: self, action: #selector(popToRootViewController))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
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
    
    override func bind() {
        viewModel.fetchMeme()
        
        viewModel.searchItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                let snapshot = dataSource?.snapshot()
                if snapshot?.indexOfSection(.grid) == nil {
                    self.updateSnapshot(section: .grid, items: items.map { .grid($0) })
                } else {
                    self.appendSnapshot(section: .grid, items: items.map { .grid($0) })
                }
            }.store(in: &subscription)
        
        viewModel.searchResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                let snapshot = dataSource?.snapshot()
                if snapshot?.indexOfSection(.list) == nil {
                    self.updateSnapshot(section: .list, items: items.map { .list($0) })
                } else {
                    self.appendSnapshot(section: .list, items: items.map { .list($0) })
                }
            }.store(in: &subscription)
        
        
        viewModel.emptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                guard let self = self else { return }
                if !isEmpty { return }
                self.updateSnapshot(section: .empty, items: [.empty])
            }.store(in: &subscription)
        
        searchTextField.textChangePublisher
            .sink { [weak self] text in
                guard let self = self else { return }
                viewModel.searchMeme(text)
            }.store(in: &subscription)
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
        
        group.edgeSpacing = section.edgeSpacing

        return NSCollectionLayoutSection(group: group)
    }
}

private extension MemeSearchViewController {
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
private extension MemeSearchViewController {
    func updateSnapshot(section: MemeSearchSection, items: [MemeSearchDisplayItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot, animatingDifferences: false)
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.isScrollEnabled = section != .empty
    }
    
    func appendSnapshot(section: MemeSearchSection, items: [MemeSearchDisplayItem]) {
        var snapshot = dataSource?.snapshot() ?? Snapshot()
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MemeSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath)  else { return }
        
        switch item {
        case .grid(let memeSearchItem):
            gotoMemeDetail(id: memeSearchItem.id)
        case .list(let memeSearchItem):
            gotoMemeDetail(id: memeSearchItem.id)
        case .empty:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        let visibleH = scrollView.bounds.height
        if offsetY > contentH - visibleH - 200, contentH > 0 {
            viewModel.fetchNextPage()
        }
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
            static let bottom: CGFloat = 10
        }
    }
}
