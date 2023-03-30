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
import SwiftUI

@main
struct AccountableApp: App {
    @StateObject private var loginController = LoginController()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch loginController.loginStatus {
                case .notDetermined:
                    SplashScreenView()
                case .loggedIn:
                    Text("You're Logged In!")
                case .loggedOut:
                    LoginView()
                        .transition(.push(from: .bottom))
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
        }
    }

    init() {
        configureAmplify()
    }

    func configureAmplify() {
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())

        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
}
