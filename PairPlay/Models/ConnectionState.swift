//
//  ConnectionState.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

enum ConnectionState: Equatable{
    case disconnected
    case connecting
    case connected
    case reconnecting
    case failed(reason: String)
    
    var displayValue: String{
        switch self{
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting…"
        case .connected:
            return "Connected"
        case .reconnecting:
            return "Reconnecting…"
        case .failed:
            return "Failed"
        }
    }
    
    var displayDetail: String {
        switch self {
        case .disconnected:
            return "Not connected to sync service"
        case .connecting:
            return "Connecting to sync service"
        case .connected:
            return "Sync service is available"
        case .reconnecting:
            return "Trying to restore connection"
        case .failed(let reason):
            return reason
        }
    }
    
    var isConnected: Bool{
        if case .connected = self{
            return true
        } else{
            return false
        }
    }
}
