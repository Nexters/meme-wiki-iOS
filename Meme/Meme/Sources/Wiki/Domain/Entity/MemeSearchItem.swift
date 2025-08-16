//
//  MemeSearchItem.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

struct MemeSearchItem: Hashable {
    var id: Int
    var thumbnail: Thumbnail
    var usage: String
    var source: String
    
    public static func == (lhs: MemeSearchItem, rhs: MemeSearchItem) -> Bool {
        return lhs.thumbnail.id == rhs.thumbnail.id
    }
}
