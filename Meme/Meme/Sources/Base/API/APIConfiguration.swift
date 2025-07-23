//
//  APIConfiguration.swift
//  Meme
//
//  Created by 제나 on 7/19/25.
//

import Foundation

enum HostType: Hashable {
    case api, web
}

class ApiConfiguration {
    static let shared = ApiConfiguration()

    private let hosts: [HostType: Host]
    private var apiDomain: Host { hosts[.api]! }
    private var wikiDomain: Host { hosts[.web]! }

    private init() {
        guard let apiHost = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let webHost = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE URL not found in Info.plist")
        }
        self.hosts = [
            .api: Host(apiHost),
            .web: Host(webHost),
        ]
    }
    
    var hostUrl: URL {
        return apiDomain.hostUrl
    }
    var wikiUrl: URL {
        return wikiDomain.hostUrl
    }
}

fileprivate class Host {
    let host: String
    
    init(_ host: String) {
        self.host = host
    }
    
    var hostUrl: URL {
        return URL(string: host)!
    }
}
