//
//  OSLog.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/24.
//

import OSLog

@available (iOS 14.0, *)
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "SeSACMarket"
    static let uiLogger = Logger(subsystem: subsystem, category: "UI")
    static let networkLogger = Logger(subsystem: subsystem, category: "Network")
    static let coordinatorLogger = Logger(subsystem: subsystem, category: "Coordinator")
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "SeSACMarket"
    static let uiLogger = OSLog(subsystem: subsystem, category: "UI")
    static let networkLogger = OSLog(subsystem: subsystem, category: "Network")
    static let coordinatorLogger = OSLog(subsystem: subsystem, category: "Coordinator")
}
