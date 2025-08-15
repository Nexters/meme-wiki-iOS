//
//  MemeMainMostSharedNestedCell.swift
//  Meme
//
//  Created by 제나 on 8/15/25.
//

import UIKit

final class MemeMainMostSharedNestedCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MemeMainMostSharedNestedCell"
    
    private var firstRowCollectionView: UICollectionView!
    private var secondRowCollectionView: UICollectionView!
    
    private var item: Lobby.Item?
    private var firstRowItems: [Lobby.Item] {
        guard let items = item?.childs else { return [] }
        let prefix = Array(items.prefix(items.count / 2))
        return prefix + prefix // TODO: - 자연스럽게 이어붙이는 것 어떻게 할까나
    }
    private var secondRowItems: [Lobby.Item] {
        guard let items = item?.childs else { return [] }
        let suffix = Array(items.suffix(items.count / 2))
        return suffix + suffix
    }
    
    // 자동 스크롤 관련
    private var displayLink: CADisplayLink?
    private var firstRowOffset: CGFloat = 0
    private var secondRowOffset: CGFloat = 0
    private let scrollSpeed: CGFloat = 1.0
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionViews()
        layoutUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScroll()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public
    func configureCell(with item: Lobby.Item) {
        self.item = item
        startAutoScroll()
    }
    
    // MARK: - Private
    private func setupCollectionViews() {
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.minimumLineSpacing = 11
        layout1.itemSize = CGSize(width: 200, height: 172)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumLineSpacing = 11
        layout2.itemSize = CGSize(width: 200, height: 172)
        
        firstRowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        secondRowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
    
        [firstRowCollectionView, secondRowCollectionView].forEach { collectionView in
            collectionView.register(
                MemeMainMostSharedCell.self,
                forCellWithReuseIdentifier: MemeMainMostSharedCell.identifier)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
        }
        firstRowCollectionView.dataSource = self
        secondRowCollectionView.dataSource = self
    }
    
    private func layoutUI() {
        contentView.addSubview(firstRowCollectionView)
        contentView.addSubview(secondRowCollectionView)
        
        firstRowCollectionView.translatesAutoresizingMaskIntoConstraints = false
        secondRowCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstRowCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstRowCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstRowCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstRowCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            
            secondRowCollectionView.topAnchor.constraint(equalTo: firstRowCollectionView.bottomAnchor, constant: 10),
            secondRowCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondRowCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondRowCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            secondRowCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Auto Scroll
extension MemeMainMostSharedNestedCell {
    private func startAutoScroll() {
        stopAutoScroll()
        displayLink = CADisplayLink(target: self, selector: #selector(handleAutoScroll))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopAutoScroll() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func handleAutoScroll() {
        guard firstRowCollectionView.contentSize.width > 0,
              secondRowCollectionView.contentSize.width > 0 else { return }
        
        // 첫 행: 왼 > 오
        firstRowOffset += scrollSpeed
        if firstRowOffset >= firstRowCollectionView.contentSize.width - firstRowCollectionView.bounds.width {
            firstRowOffset = -50
        }
        firstRowCollectionView.contentOffset = CGPoint(x: firstRowOffset, y: 0)
        
        // 두번째 행: 오 > 왼
        secondRowOffset -= scrollSpeed
        if secondRowOffset <= 0 {
            secondRowOffset = secondRowCollectionView.contentSize.width - secondRowCollectionView.bounds.width + 50
        }
        secondRowCollectionView.contentOffset = CGPoint(x: secondRowOffset, y: 0)
    }
}

// MARK: - UICollectionViewDataSource
extension MemeMainMostSharedNestedCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = collectionView == firstRowCollectionView ? firstRowItems.count : secondRowItems.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MemeMainMostSharedCell.identifier,
            for: indexPath) as? MemeMainMostSharedCell
        else { return UICollectionViewCell() }
        let isFirstRow = collectionView == firstRowCollectionView
        let item = isFirstRow ? firstRowItems[indexPath.item] : secondRowItems[indexPath.item]
        cell.configureCell(with: item, isFirstRow: isFirstRow)
        return cell
    }
}
