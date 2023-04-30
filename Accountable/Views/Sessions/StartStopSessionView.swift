//
//  StartStopSessionView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct StartStopSessionView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    let project: Project

    var body: some View {
        VStack(spacing: 20) {
            Text(ongoingSessionController.display)
                .font(.largeTitle.bold())
                .padding(.bottom, -5)

            HStack {
                AsyncButton {
                    ongoingSessionController.projectForActiveSession = project
                    await ongoingSessionController.primaryTimerButtonTapped()
                } label: {
                    Label(
                        ongoingSessionController.primaryTimerButtonText,
                        systemImage: ongoingSessionController.primaryTimerButtonIconName
                    )
                }

                if ongoingSessionController.timerIsRunning || ongoingSessionController.display != "00:00:00" {
                    Button {
                        ongoingSessionController.secondaryTimerButtonTapped()
                    } label: {
                        Label(
                            ongoingSessionController.secondaryTimerButtonText,
                            systemImage: ongoingSessionController.secondaryTimerButtonIconName
                        )
                    }
                }
            }
            .buttonStyle(Primary(backgroundColor: ongoingSessionController.timerIsRunning ? .red : .accentColor))

            Text("When you stop your session, it will automatically get saved. You can also pause and resume your session, if necessary. Quitting Accountable from the App Switcher will terminate your session, but the app will still track your time if you lock your phone or use other apps.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .navigationTitle("Create Session")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: ongoingSessionController.timerIsRunning)
        .alert(
            "Error",
            isPresented: $ongoingSessionController.errorMessageIsShowing,
            actions: { Button("OK") { } },
            message: { Text(ongoingSessionController.errorMessageText)
            }
        )
        .onChange(
            of: ongoingSessionController.sessionIsActive) { sessionIsActive in
                if !sessionIsActive {
                    dismiss()
                }
            }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                StartStopSessionView(project: Project.example)
                    .environmentObject(OngoingSessionController())
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
    }
}
