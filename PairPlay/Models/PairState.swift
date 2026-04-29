//
//  PairState.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

enum PairState: Equatable{
    case notPaired
    case pairing
    case paired(pairId: String, partnerName: String)
    case failed(reason: String)
    
    var displayTitle: String{
        switch self{
        case .notPaired:
            return "Not paired"
        case .pairing:
            return "Pairing..."
        case .paired(_, let partnerName):
            return "Connected with \(partnerName)"
        case .failed:
            return "Pair failed"
        }
    }
    
    var displaySubtitle: String{
        switch self{
        case .notPaired:
            return "Set up a pair to statr listening together"
        case .pairing:
            return "Trying to connect your pair"
        case .paired(let pairId, _):
            return "Pair Id: \(pairId)"
        case .failed(let reason):
            return reason
        }
    }
}
