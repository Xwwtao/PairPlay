//
//  AppEnvironmentState.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

struct AppEnvironmentState: Equatable{
    var pairState: PairState
    var connectionState: ConnectionState
    var appleMusicState: AppleMusicState
    var quietModeEnabled: Bool
    
    static let mockReady = AppEnvironmentState(
        pairState: .paired(pairId: "wentao_pair", partnerName:"Lily"),
        connectionState: .connected,
        appleMusicState: .mockReady,
        quietModeEnabled: false
    )
}
