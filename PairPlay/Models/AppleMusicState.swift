//
//  AppleMusicState.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

enum AppleMusicAuthorizationState: Equatable {
    case notDetermined
    case authorized
    case denied
    case restricted

    var displayValue: String {
        switch self {
        case .notDetermined:
            return "Not requested"
        case .authorized:
            return "Authorized"
        case .denied:
            return "Denied"
        case .restricted:
            return "Restricted"
        }
    }
}

enum AppleMusicSubscriptionState: Equatable {
    case unknown
    case canPlayCatalog
    case cannotPlayCatalog

    var displayValue: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .canPlayCatalog:
            return "Ready"
        case .cannotPlayCatalog:
            return "Unavailable"
        }
    }
}

struct AppleMusicState: Equatable {
    var authorization: AppleMusicAuthorizationState
    var subscription: AppleMusicSubscriptionState

    var displayValue: String {
        if authorization != .authorized {
            return authorization.displayValue
        }

        return subscription.displayValue
    }

    var displayDetail: String {
        switch authorization {
        case .notDetermined:
            return "Apple Music permission has not been requested"
        case .authorized:
            switch subscription {
            case .unknown:
                return "Subscription status has not been checked"
            case .canPlayCatalog:
                return "Apple Music playback is available"
            case .cannotPlayCatalog:
                return "This account cannot play catalog content"
            }
        case .denied:
            return "Apple Music permission was denied"
        case .restricted:
            return "Apple Music access is restricted on this device"
        }
    }

    var isReady: Bool {
        authorization == .authorized && subscription == .canPlayCatalog
    }

    static let mockReady = AppleMusicState(
        authorization: .authorized,
        subscription: .canPlayCatalog
    )
}
