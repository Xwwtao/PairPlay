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
    @Published var now: Date = Date()
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    deinit{
        timer?.invalidate()
    }
    
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
    
    func openPlayer(){
        
    }
    
    
    func leaveSession() {
        sessionState = .partnerListening(snapshot: .sample)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.now = Date()
            }
        }
    }
}
