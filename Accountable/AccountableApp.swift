//
//  AccountableApp.swift
//  Accountable
//
//  Created by Julian Worden on 3/26/23.
//

import Amplify
import AWSAPIPlugin
import AWSDataStorePlugin
import SwiftUI

@main
struct AccountableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
}
