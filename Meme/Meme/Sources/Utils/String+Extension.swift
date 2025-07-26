//
//  String+Extension.swift
//  Meme
//
//  Created by 제나 on 7/26/25.
//

import Foundation

extension String {
    func asEncodedURL() -> URL? {
        let urlString = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if let url = URL(string: urlString) {
            return url
        } else if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: encoded) {
            return url
        }
        return nil
    }
}
