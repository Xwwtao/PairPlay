//
//  HomeView.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import SwiftUI

struct HomeView: View{
    @StateObject private var viewModel = HomeViewModel()
    @State private var showPlayer = false
    @State private var showSettings = false
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing:24){
                    header
                    
                    mainContent
                    
                    Spacer()
                    
                    debugButtons
                }
                .padding(24)
            }
            .navigationDestination(isPresented: $showPlayer){
                PlayerView(
                    sessionState: viewModel.sessionState,
                    now: viewModel.now,
                    onLeave: {
                        viewModel.leaveSession()
                        showPlayer = false
                    }
                )
            }
            .sheet(isPresented: $showSettings){
                SettingsView()
            }
        }
    }
    
    private var header: some View{
        HStack{
            Text("PairPlay")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button{
                showSettings = true
            } label:{
                Image(systemName:"gearshape")
                    .font(.title3)
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View{
        switch viewModel.sessionState{
        case .idle:
            idleView
            
        case .partnerListening(let snapshot):
            partnerListeningView(snapshot)

        case .joining(let snapshot):
            joiningView(snapshot)

        case .listeningTogether(let snapshot, let sharedSince):
            listeningTogetherView(snapshot:snapshot,sharedSince: sharedSince)

        case .listeningAlone(let snapshot):
            listeningAloneView(snapshot)

        case .reconnecting:
            reconnectingView
        }
    }
    
    private var idleView: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("She's not listening right now")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Start something when you want.")
                .foregroundStyle(.secondary)
            librarySection
        }
    }
    
    private func partnerListeningView(_ snapshot: PlaybackSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("She’s listening now")
                .font(.title2)
                .fontWeight(.medium)

            SongCard(snapshot: snapshot) {
                viewModel.joinListening()
            }
            connectionStatus
            librarySection
        }
    }

    private func joiningView(_ snapshot: PlaybackSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Joining…")
                .font(.title2)
                .fontWeight(.medium)

            SongCard(snapshot: snapshot, buttonTitle: "Syncing") {}
                .opacity(0.8)
            ProgressView()
        }
    }

    private func listeningTogetherView(snapshot: PlaybackSnapshot, sharedSince: Date) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Listening together")
                .font(.title2)
                .fontWeight(.medium)
            SongCard(snapshot: snapshot, buttonTitle: "Open Player") {
                showPlayer = true
            }

            Text("Shared for \(TimeFormatter.sharedDuration(since: sharedSince, now: viewModel.now))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            connectionStatus
        }
    }

    private func listeningAloneView(_ snapshot: PlaybackSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("You’re listening")
                .font(.title2)
                .fontWeight(.medium)

            SongCard(snapshot: snapshot, buttonTitle: "Open Player") {
                showPlayer = true
            }
        }
    }

    private var reconnectingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reconnecting…")
                .font(.title2)
                .fontWeight(.medium)
            Text("Trying to sync again.")
                .foregroundStyle(.secondary)
        }
    }

    private var librarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your library")
                .font(.headline)
            Button("Recent Plays") {}
                .buttonStyle(.bordered)
            Button("Playlists") {}
                .buttonStyle(.bordered)
        }
        .padding(.top, 16)
    }

    private var connectionStatus: some View {
        Text("Connected • Apple Music Ready")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }

    private var debugButtons: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Debug")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack {
                Button("Idle") {
                    viewModel.simulatePartnerNotListening()
                }

                Button("Partner Listening") {
                    viewModel.simulatePartnerListening()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}
