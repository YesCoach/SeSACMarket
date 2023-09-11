//
//  NetworkCheckManager.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation
import Network

final class NetworkCheckManager {

    static let shared = NetworkCheckManager()

    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor

    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown

    var completion: ((Bool) -> Void)?

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            isConnected = path.status == .satisfied
            getConnectionType(path)

            if isConnected == true {
                print("연결됨!")
            } else {
                completion?(true)
            }
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
