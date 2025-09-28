//
//  NotificationRepositoryInterface.swift
//  Meme
//
//  Created by ZENA on 9/28/25.
//

import Foundation

protocol NotificationRepositoryInterface {
    func register(token: String) async throws
}
