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
        SimpleEntry(date: Date.now, userProjects: PlaceholderData.projects, userSessions: [], isForPlaceholder: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry = SimpleEntry(date: Date.now, userProjects: [], userSessions: [], isForPlaceholder: true)

        let existingSessions = FileManagerController.shared.getSessions()
        if existingSessions.isEmpty {
            entry = SimpleEntry(date: Date.now, userProjects: PlaceholderData.projects, userSessions: [], isForPlaceholder: true)
        } else if !existingSessions.isEmpty {
            let existingProjects = FileManagerController.shared.getProjects()
            entry = SimpleEntry(date: Date.now, userProjects: existingProjects, userSessions: existingSessions, isForPlaceholder: true)
        }

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let refreshPolicyInterval = Calendar.current.date(byAdding: .second, value: 30, to: Date.now)!

        Task {
            let userProjects = FileManagerController.shared.getProjects()
            let userSessions = FileManagerController.shared.getSessions()
            let entry = SimpleEntry(date: Date.now, userProjects: userProjects, userSessions: userSessions, isForPlaceholder: false)
            let timeline = Timeline(entries: [entry], policy: .after(refreshPolicyInterval))
            completion(timeline)
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
