//
//  SearchPage.swift
//  Meme
//
//  Created by 임현규 on 8/10/25.
//

import Foundation

struct SearchPage<Item> {
    let items: [Item]
    let pageState: PageState
}

struct PageState {
    let next: Int?
    let hasMore: Bool?
    let pageSize: Int?
}
