//
//  HomeViewModel.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import Foundation
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessionState: ListeningSessionState = .partnerListening(snapshot: .sample)
    
    func simulatePartnerNotListening(){
        sessionState = .idle
    }
    
    func simulatePartnerListening(){
        sessionState = .partnerListening(snapshot: .sample)
    }
    
    func joinListening(){
        guard case let .partnerListening(snapshot) = sessionState else{
            return
        }
        
        sessionState = .joining(snapshot: snapshot)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
            self.sessionState = .listeningTogether(
                snapshot: snapshot,
                sharedSince: Date()
            )
        }
    }
    
    func leaveSession() {
        sessionState = .partnerListening(snapshot: .sample)
    }
}
