//
//  MemeMain.Model.Section.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import Foundation

enum MemeMain {
    enum Model {
        enum Section: Int, CaseIterable {
            case custom
            case category
            case topRated
            case mostShared
        }

        struct Item: Hashable {
            let id = UUID()
            let type: Section
            let content: String
        }
    }
}
