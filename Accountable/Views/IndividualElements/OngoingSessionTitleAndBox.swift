//
//  OngoingSessionTitleAndBox.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import SwiftUI

struct OngoingSessionTitleAndBox: View {
    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    var body: some View {
        VStack {
            SectionTitle(text: "Ongoing Session")
                .tint(.primary)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.purple)
                    .shadow(color: .purple.opacity(UiConstants.purpleShadowOpacity), radius: UiConstants.purpleShadowRadius)

                HStack {
                    VStack(alignment: .leading) {
                        Text(ongoingSessionController.projectForActiveSession?.name ?? "Unknown Project")
                            .font(.title2)
                            .bold()

                        Text(ongoingSessionController.display)
                    }
                    .foregroundColor(.white)

                    Spacer()

                    AsyncButton {
                        await ongoingSessionController.stopTimer()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)

                            Image(systemName: "stop")
                                .bold()
                        }
                        .frame(width: 44, height: 44)
                    }
                    .tint(.purple)

                    Button {
                        ongoingSessionController.secondaryTimerButtonTapped()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)

                            Image(systemName: ongoingSessionController.secondaryTimerButtonIconName)
                                .bold()
                        }
                        .frame(width: 44, height: 44)
                    }
                    .tint(.purple)
                }
                .padding()
            }
            .frame(height: 65)
        }
        .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)).combined(with: .opacity))

    }
}

struct OngoingSessionTitleAndBox_Previews: PreviewProvider {
    static var previews: some View {
        OngoingSessionTitleAndBox()
    }
}
