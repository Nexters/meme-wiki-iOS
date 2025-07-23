//
//  Logger.swift
//  Meme
//
//  Created by 임현규 on 7/19/25.
//


import Foundation
import os

enum Log {
    public enum Level {
        case debug
        case info
        case notice
        case error
        case fault

        fileprivate var logType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .default
            case .error:
                return .error
            case .fault:
                return .fault
            }
        }
    }
    
    public enum Category: String {
        case ui = "UI"
        case networking = "Networking"
    }
}

// MARK: - Public extension

extension Log {
    static func debug(_ message: String, _ category: Category, _ fileName: String = #fileID, _ line: Int = #line, _ funcName: StaticString = #function) {
        self.log(message, .debug, category, fileName, line, funcName)
    }
    
    static func info(_ message: String, _ category: Category, fileName: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        self.log(message, .info, category, fileName, line, funcName)
    }
    
    static func notice(_ message: String, _ category: Category, fileName: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        self.log(message, .notice, category, fileName, line, funcName)
    }
    
    static func error(_ message: String, _ category: Category, fileName: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        self.log(message, .error, category, fileName, line, funcName)
    }
    
    static func fault(_ message: String, _ category: Category, fileName: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        self.log(message, .fault, category, fileName, line, funcName)
    }
}

// MARK: - Private extension

private extension Log {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
}

private extension Log {
    static func simpleLog(_ level: Level, _ category: Category, _ message: String) {
        let logger = Logger(subsystem: subsystem, category: category.rawValue)
        logger.log(level: level.logType, "\(message)")
    }
    
    static func log(_ message: String, _ level: Level, _ category: Category, _ fileName: String = #fileID, _ line: Int = #line, _ funcName: StaticString = #function) {
#if DEBUG
        if category == .networking {
            simpleLog(level, .networking, message)
        } else {
            let logger = Logger(subsystem: subsystem, category: category.rawValue)
            let filename = fileName.components(separatedBy: "/").last ?? ""
            let logMessage = "[\(filename), \(line), \(funcName)] - \(message)"
            logger.log(level: level.logType, "\(logMessage)")
        }
#endif
    }
}
