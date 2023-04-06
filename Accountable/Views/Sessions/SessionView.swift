//
//  SessionView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    var body: some View {
        VStack {
            Text(ongoingSessionController.display)
                .font(.largeTitle)

            HStack {
                Button(role: .destructive) {
                    ongoingSessionController.primaryTimerButtonTapped()
                } label: {
                    Label(ongoingSessionController.primaryTimerButtonText, systemImage: ongoingSessionController.primaryTimerButtonIconName)
                }

                if ongoingSessionController.timerIsRunning || ongoingSessionController.display != "00:00:00" {
                    Button {
                        ongoingSessionController.secondaryTimerButtonTapped()
                    } label: {
                        Label(ongoingSessionController.secondaryTimerButtonText, systemImage: ongoingSessionController.secondaryTimerButtonIconName)
                    }
                }
            }
            .buttonStyle(Primary(backgroundColor: ongoingSessionController.timerIsRunning ? .red : .accentColor))


        }
        .padding(.horizontal)
        .navigationTitle("Create Session")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: ongoingSessionController.timerIsRunning)
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
            .environmentObject(OngoingSessionController())
    }
}
