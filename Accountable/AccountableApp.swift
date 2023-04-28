//
//  AccountableApp.swift
//  Accountable
//
//  Created by Julian Worden on 3/26/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import ClientRuntime
import SwiftUI

@main
struct AccountableApp: App {
    @StateObject private var loginController = LoginController()
    @StateObject private var ongoingSessionController = OngoingSessionController()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch loginController.loginStatus {
                case .notDetermined:
                    SplashScreenView()
                case .loggedIn:
                    HomeView()
                        .transition(.opacity)
                case .loggedOut:
                    LoginView()
                        .transition(.opacity)
                case .error:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: loginController.loginStatus)
            .alert(
                "Error",
                isPresented: $loginController.errorMessageShowing,
                actions: { Button("OK") { } },
                message: { Text(loginController.errorMessageText) }
            )
            .task {
                await loginController.determineLoginStatus()
            }
            .environmentObject(ongoingSessionController)
            // Used instead of scenePhase because scenePhase was not storing values when app was made inactive
            .onForeground {
                ongoingSessionController.calculateNewTimerValue()
            }
            .onBackground {
                ongoingSessionController.preserveTimerStateInBackground()
            }
        }
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
            Task {
                // Without this, syncing will not start immediately when the app starts.
                try await Amplify.DataStore.start()
//                try await Amplify.DataStore.clear()
            }
            print("Initialized Amplify")
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
}
