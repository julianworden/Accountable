//
//  FileManagerController.swift
//  Accountable
//
//  Created by Julian Worden on 4/23/23.
//

import Foundation

final class FileManagerController {
    static let shared = FileManagerController()

    func saveProjects(_ projects: [Project]) throws {
        if let jsonData = try? JSONEncoder().encode(projects) {
            let url = FileManagerConstants.projectsUrl
            try jsonData.write(to: url)
        }
    }

    func getProjects() -> [Project] {
        if let projectData = try? Data(contentsOf: FileManagerConstants.projectsUrl),
           let projects = try? JSONDecoder().decode([Project].self, from: projectData) {
            return projects
        } else {
            return []
        }
    }

    func saveSession(_ sessions: [Session]) throws {
        if let jsonData = try? JSONEncoder().encode(sessions) {
            let url = FileManagerConstants.sessionsUrl
            try jsonData.write(to: url)
        }
    }

    func getSessions() -> [Session] {
        if let sessionData = try? Data(contentsOf: FileManagerConstants.sessionsUrl),
           let sessions = try? JSONDecoder().decode([Session].self, from: sessionData) {
            return sessions
        } else {
            return []
        }
    }
}
