//
//  OngoingSessionController.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import ActivityKit
import Combine
import Foundation
import SwiftUI
import WidgetKit

@MainActor
final class OngoingSessionController: ObservableObject {
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
    var appBackgroundDate: Date?

    var timeSpentInactive: TimeInterval {
        guard let appBackgroundDate else { return 0 }

        return Date.now.timeIntervalSince(appBackgroundDate)
    }

    // MARK: - Timer Modifications

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
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        subscribeToTimer()
        timerIsRunning = true
        appBackgroundDate = nil
    }

    func stopTimer() async {
        unsubscribeToTimer()
        timer.upstream.connect().cancel()
        timerIsRunning = false
        display = "00:00:00"
        appBackgroundDate = nil

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

    // MARK: - Session Creation

    func createSession() async {
        guard var projectForActiveSession else { return }

        sessionIsActive = false

        do {
            let newSession = Session(
                project: projectForActiveSession,
                durationInSeconds: timerDuration,
                unixDate: Date.now.timeIntervalSince1970,
                weekday: Weekday.getWeekdayFor(Date.now)
            )

            projectForActiveSession.totalSecondsPracticed += timerDuration
            try await DatabaseService.shared.createSession(newSession)
            try await DatabaseService.shared.createOrUpdateProject(projectForActiveSession)
            try FileManagerController.shared.saveSession(newSession)
            try FileManagerController.shared.updateProject(projectForActiveSession)
            postSessionCreatedNotification(forNewSession: newSession)
            WidgetCenter.shared.reloadAllTimelines()
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

    /// Calculates the value of the active session after the app has been removed from a background or inactive state into an active state.
    func calculateNewTimerValue() {
        guard appBackgroundDate != nil else { return }

        timerDuration += Int(timeSpentInactive)
        resumeTimer()
        appBackgroundDate = nil
    }

    /// Preserves the date at which the app was moved into the background or made inactive while a session is active. This will allow
    /// the app to calculate the amount of time it was inactive or in the background so that it can be added to the timer duration once
    /// the app enters the foreground again.
    func preserveTimerStateInBackground() {
        // Prevents the appBackgroundDate from being stored when the timer is paused.
        guard timerIsRunning else { return }

        appBackgroundDate = Date.now
        pauseTimer()
    }
}
