//
//  OngoingSessionController.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class OngoingSessionController: ObservableObject {
    @Published var startTime = Date.now
    @Published var display = "00:00:00"
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timerIsRunning = false
    @Published var sessionIsActive = false

    var cancellables = Set<AnyCancellable>()
    var timerDuration: TimeInterval = 0

    var primaryTimerButtonText: String {
        if timerIsRunning {
            return "End Session"
        } else {
            return "New Session"
        }
    }

    var primaryTimerButtonIconName: String {
        if timerIsRunning {
            return "stop"
        } else {
            return "play"
        }
    }

    var secondaryTimerButtonText: String {
        if timerIsRunning {
            return "Pause Session"
        } else {
            return "Resume Session"
        }
    }

    var secondaryTimerButtonIconName: String {
        if timerIsRunning {
            return "pause"
        } else {
            return "play"
        }
    }

    func primaryTimerButtonTapped() {
        if timerIsRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    func secondaryTimerButtonTapped() {
        if timerIsRunning {
            pauseTimer()
        } else {
            resumeTimer()
        }
    }

    func startTimer() {
        guard !timerIsRunning else { return }

        sessionIsActive = true
        display = "00:00:00"
        timerDuration = 0
        startTime = Date.now
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        subscribeToTimer()
        timerIsRunning = true
    }

    func stopTimer() {
        guard timerIsRunning else { return }

        sessionIsActive = false
        unsubscribeToTimer()
        timer.upstream.connect().cancel()
        timerIsRunning = false
    }

    func resumeTimer() {
        guard !timerIsRunning else { return }

        subscribeToTimer()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerIsRunning = true
    }

    func pauseTimer() {
        guard timerIsRunning else { return }

        unsubscribeToTimer()
        timer.upstream.connect().cancel()
        timerIsRunning = false
    }

    func updateTimerValue() {
        timerDuration += 1
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        display = formatter.string(from: timerDuration) ?? ""
        print("NEW TIMER VALUE: \(display)")
    }

    func subscribeToTimer() {
        timer
            .sink { _ in
                self.updateTimerValue()
            }
            .store(in: &cancellables)
    }

    func unsubscribeToTimer() {
        cancellables.removeAll()
    }
}
