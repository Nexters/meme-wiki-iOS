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
                heightDimension: .estimated(100)
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
            return .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        case .list:
            return .init(top: 6, leading: 20, bottom: 6, trailing: 20)
        case .empty:
            return .zero
        }
    }

    var groupCount: Int {
        return 1
    }
}

