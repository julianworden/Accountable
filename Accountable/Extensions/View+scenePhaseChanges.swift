//
//  View+scenePhaseChanges.swift
//  TheSamePage
//
//  Created by Julian Worden on 2/19/23.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/62840571/not-receiving-scenephase-changes
extension View {
    func onBackground(_ completion: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
            perform: { _ in completion() }
        )
    }

    func onForeground(_ completion: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in completion() }
        )
    }
}
