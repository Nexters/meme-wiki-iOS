//
//  String++Extension.swift
//  Meme
//
//  Created by 제나 on 7/26/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

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
    
    /*
     INPUT: "2025-08-16T04:21:00"
     OUTPUT: Input Date를 지금 시간과 비교했을 때 남은 시간만큼을 인터벌로 반환합니다.
     */
    func remainingTimeInterval() -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let targetDate = dateFormatter.date(from: self) else { return 0 }
        let diff = targetDate.timeIntervalSince(Date())
        return diff > 0 ? diff : 0
    }
}

extension TimeInterval {
    func format() -> String {
        let `default` = "-- : -- : --"
        if self <= 0 { return `default` }
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
    }
}
