//
//  MemeSearchSection.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation
import UIKit

enum MemeSearchSection: Hashable {
    case grid
    case list
    case empty
}

enum MemeSearchDisplayItem: Hashable {
    case grid(MemeSearchItem)
    case list(MemeSearchItem)
    case empty
}


extension MemeSearchSection {

    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .grid:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
            )
        case .list:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(363)
            )
        case .empty:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        }
    }

    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .grid:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
        case .list:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
        case .empty:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        }
    }

    var itemInset: NSDirectionalEdgeInsets {
        switch self {
        case .grid:
            return .init(top: 5.5, leading: 7, bottom: 5.5, trailing: 7)
        case .list:
            return .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        case .empty:
            return .zero
        }
    }
    
    var edgeSpacing: NSCollectionLayoutEdgeSpacing {
        switch self {
        case .grid: .init(leading: nil, top: nil, trailing: nil, bottom: nil)
        case .list: .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(24))
        case .empty: .init(leading: nil, top: nil, trailing: nil, bottom: nil)
        }
    }

    var groupCount: Int {
        switch self {
        case .grid: 2
        case .list: 1
        case .empty: 1
        }
    }
}
