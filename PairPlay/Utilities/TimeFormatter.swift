//
//  TimeFormatter.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import Foundation

enum TimeFormatter{
    static func playbackTime(_ seconds: Double) ->String{
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    static func sharedDuration(since: Date, now: Date) -> String {
        let seconds = max(0, Int(now.timeIntervalSince(since)))
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        if minutes == 0 {
            return "\(remainingSeconds) sec"
        } else {
            return "\(minutes) min \(remainingSeconds) sec"
        }
    }
}
