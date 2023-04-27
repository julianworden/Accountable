//
//  AccountableWidgetsBundle.swift
//  LastWeekChartWidget
//
//  Created by Julian Worden on 4/12/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import ClientRuntime
import Security
import SwiftUI
import WidgetKit

@main
struct AccountableWidgetsBundle: WidgetBundle {
    var body: some Widget {
        LastWeekChartWidget()
        TotalHoursWorkedHomeScreenWidget()
        TotalHoursWorkedLockScreenWidget()
    }

    init() {
        configureAmplify()
    }

    func configureAmplify() {
        let apiPlugin = AWSAPIPlugin()
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())

        do {
            SDKLoggingSystem.initialize(logLevel: .warning)
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch {
            print(error)
        }
    }
}
