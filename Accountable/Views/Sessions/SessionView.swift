//
//  SessionView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    let project: Project

    var body: some View {
        VStack {
            Text(ongoingSessionController.display)
                .font(.largeTitle)

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
        SessionView(project: Project.example)
            .environmentObject(OngoingSessionController())
    }
}
