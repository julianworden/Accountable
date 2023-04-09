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

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
            }
        }
    }

    var projectForActiveSession: Project?
    var cancellables = Set<AnyCancellable>()
    var timerDuration = 0

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

    func primaryTimerButtonTapped() async {
        if timerIsRunning {
            await stopTimer()
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

    func stopTimer() async {
        sessionIsActive = false
        unsubscribeToTimer()
        timer.upstream.connect().cancel()
        timerIsRunning = false
        display = "00:00:00"

        await createSession()
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
        display = formatter.string(from: TimeInterval(timerDuration)) ?? ""
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

    func createSession() async {
        guard let projectForActiveSession else { return }

        do {
            let newSession = Session(
                project: projectForActiveSession,
                durationInSeconds: timerDuration,
                unixDate: Date.now.timeIntervalSince1970
            )

            try await DatabaseService.shared.createSession(newSession)
            postSessionCreatedNotification(forNewSession: newSession)
            sessionIsActive = false
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func postSessionCreatedNotification(forNewSession newSession: Session) {
        NotificationCenter.default.post(
            name: .newSessionCreated,
            object: nil,
            userInfo: [NotificationConstants.newSession: newSession]
        )
    }
}
