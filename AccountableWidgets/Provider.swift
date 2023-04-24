//
//  Provider.swift
//  Accountable
//
//  Created by Julian Worden on 4/21/23.
//

import Amplify
import Foundation
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date.now, userProjects: [], userSessions: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry = SimpleEntry(date: Date.now, userProjects: [], userSessions: [])

        // Check to see if data has been fetched. If it hasn't, use sample data. If it has, use real data
        if context.isPreview {
            entry = SimpleEntry(date: Date.now, userProjects: [], userSessions: [])
        } else {
            entry = SimpleEntry(date: Date.now, userProjects: [], userSessions: [])
        }

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let refreshPolicyInterval = Calendar.current.date(byAdding: .second, value: 30, to: Date.now)!

        Task {
            do {
                try await checkKeychain()
//                let currentUser = try await DatabaseService.shared.getLoggedInUser()
                let userProjects = FileManagerController.shared.getProjects()
                let userSessions = FileManagerController.shared.getSessions()
                let entry = SimpleEntry(date: Date.now, userProjects: userProjects, userSessions: userSessions)
                let timeline = Timeline(entries: [entry], policy: .after(refreshPolicyInterval))
                completion(timeline)
            } catch {
                let entry = SimpleEntry(date: Date.now, userProjects: [], userSessions: [], errorMessage: error.localizedDescription)
                let timeline = Timeline(entries: [entry], policy: .after(refreshPolicyInterval))
                completion(timeline)
            }
        }
    }

    // MARK: - Auth

    func checkKeychain() async throws  {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccessGroup as String: KeychainConstants.accessGroup,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var keychainItem: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keychainItem)

        try await handleKeychainStatus(status)

        let (username, password) = try await getUsernameAndPasswordFromKeychainItem(keychainItem)

        let result = try await Amplify.Auth.fetchAuthSession()
        if !result.isSignedIn {
            try await attemptLogin(withEmail: username, andPassword: password)
        }
    }

    func handleKeychainStatus(_ status: OSStatus) async throws {
        guard status != errSecItemNotFound,
              status == errSecSuccess else {
            await signOut()
            throw KeychainError.itemDoesNotExist
        }
    }

    func getUsernameAndPasswordFromKeychainItem(_ keychainItem: CFTypeRef?) async throws -> (String, String) {
        guard let existingItem = keychainItem as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let username = existingItem[kSecAttrAccount as String] as? String
        else {
            await signOut()
            throw KeychainError.unexpectedPasswordData
        }

        return (username, password)
    }

    func attemptLogin(withEmail emailAddress: String, andPassword password: String) async throws {
        _ = try await Amplify.Auth.signIn(username: emailAddress, password: password)
    }

    func signOut() async {
        _ = await Amplify.Auth.signOut()
    }

    // MARK: - User Data

    func getAllProjectsAndSessions(for user: User) async throws -> ([Project], [Session]) {
        return ([], [])
    }
}
