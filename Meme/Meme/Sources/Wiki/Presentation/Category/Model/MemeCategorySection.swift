//
//  MemeCategorySection.swift
//  Meme
//
//  Created by 임현규 on 8/10/25.
//

import UIKit

enum MemeCategorySection: Hashable {
    case category
    case grid
}

enum MemeCategoryDisplayItem: Hashable {
    case category(CategoryItem)
    case grid(MemeSearchItem)
}


extension MemeCategorySection {
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .category:
            return NSCollectionLayoutSize(
                widthDimension: .absolute(76),
                heightDimension: .absolute(108)
            )
        case .grid:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
            )
        }
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .category:
            return NSCollectionLayoutSize(
                widthDimension: .estimated(76),
                heightDimension: .absolute(108)
            )
        case .grid:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
        }
    }
    
    var itemInset: NSDirectionalEdgeInsets {
        switch self {
        case .category:
            return .init(top: 0, leading: 0, bottom: 0, trailing: 12)
        case .grid:
            return .init(top: 5.5, leading: 7, bottom: 5.5, trailing: 7)
        }
    }
    
    var groupCount: Int {
        switch self {
        case .category: 1
        case .grid: 2
        }
    }
    
    var scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .category:
            return .groupPaging
        case .grid:
            return .none
        }
    }
    
    var headerSize: NSCollectionLayoutSize {
        switch self {
        case .category:
            return NSCollectionLayoutSize(
                widthDimension: .absolute(0),
                heightDimension: .absolute(0)
            )
        case .grid:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(28 + 20.5)
            )
        }
    }
    
    var headerInset: NSDirectionalEdgeInsets {
        switch self {
        case .category:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .grid:
            return NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10.5, trailing: 14)
        }
    }
    
    
    var sectionInset: NSDirectionalEdgeInsets {
        switch self {
        case .category:
            return NSDirectionalEdgeInsets(top: 20, leading: 14, bottom: 20, trailing: 14)
        case .grid:
            return NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }
    }
    
    var decorationInset: NSDirectionalEdgeInsets {
        switch self {
        case .category:
            return NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14)
        case .grid:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
}
