//
//  FileManagerController.swift
//  Accountable
//
//  Created by Julian Worden on 4/23/23.
//

import Foundation
import WidgetKit

final class FileManagerController {
    static let shared = FileManagerController()

    var projectsJsonFileHasBeenCreated: Bool {
        FileManager.default.fileExists(atPath: FileManagerConstants.projectsUrl.path())
    }

    var sessionsJsonFileHasBeenCreated: Bool {
        FileManager.default.fileExists(atPath: FileManagerConstants.sessionsUrl.path())
    }

    func saveProject(_ project: Project) throws {
        if projectsJsonFileHasBeenCreated {
            try addProjectToExistingProjects(project)
        } else {
            if let jsonData = try? JSONEncoder().encode([project]) {
                try jsonData.write(to: FileManagerConstants.projectsUrl)
            }
        }
    }

    func saveProjects(_ projects: [Project]) throws {
        if let jsonData = try? JSONEncoder().encode(projects) {
            let url = FileManagerConstants.projectsUrl
            try jsonData.write(to: url)
        }
    }

    func updateProject(_ project: Project) throws {
        guard projectsJsonFileHasBeenCreated else { throw FileManagerError.writeFailed(message: "No projects exist on the user's device, so the project cannot be updated.") }

        var existingProjects = getProjects()
        if let projectIndex = existingProjects.firstIndex(where: { $0.id == project.id }) {
            existingProjects.remove(at: projectIndex)
            existingProjects.append(project)
            try saveProjects(existingProjects)
        }
    }

    private func addProjectToExistingProjects(_ project: Project) throws {
        do {
            var existingProjects = getProjects()
            existingProjects.append(project)
            if let jsonData = try? JSONEncoder().encode(existingProjects) {
                try jsonData.write(to: FileManagerConstants.projectsUrl)
                print("NEW PROJECT DATA: \(jsonData.prettyPrintedJSONString())")
            }
        } catch {
            throw FileManagerError.writeFailed(message: "Failed to save project to device storage. System Error: \(error.localizedDescription)")
        }
    }

    func deleteProject(_ project: Project) throws {
        do {
            guard projectsJsonFileHasBeenCreated else { return }

            var existingProjects = getProjects()
            if let projectIndex = existingProjects.firstIndex(of: project) {
                existingProjects.remove(at: projectIndex)
                try saveProjects(existingProjects)
                try deleteSessions(for: project)
            }
        } catch {
            throw FileManagerError.writeFailed(message: "Failed to update projects. System Error: \(error.localizedDescription)")
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

    func getSessions() -> [Session] {
        if let sessionData = try? Data(contentsOf: FileManagerConstants.sessionsUrl),
           let sessions = try? JSONDecoder().decode([Session].self, from: sessionData) {
            return sessions
        } else {
            return []
        }
    }

    func saveSession(_ session: Session) throws {
        if sessionsJsonFileHasBeenCreated {
            try addSessionToExistingSessions(session)
        } else {
            if let jsonData = try? JSONEncoder().encode([session]) {
                try jsonData.write(to: FileManagerConstants.sessionsUrl)
            }
        }
    }

    private func addSessionToExistingSessions(_ session: Session) throws {
        do {
            var existingSessions = getSessions()
            existingSessions.append(session)
            if let jsonData = try? JSONEncoder().encode(existingSessions) {
                try jsonData.write(to: FileManagerConstants.sessionsUrl)
                print("NEW SESSION DATA: \(jsonData.prettyPrintedJSONString())")
            }
        } catch {
            throw FileManagerError.writeFailed(message: "Failed to save session to device storage. System Error: \(error.localizedDescription)")
        }
    }

    func saveSessions(_ sessions: [Session]) throws {
        if let jsonData = try? JSONEncoder().encode(sessions) {
            let url = FileManagerConstants.sessionsUrl
            try jsonData.write(to: url)
        }
    }

    private func deleteSessions(for project: Project) throws {
        do {
            var existingSessions = getSessions()

            for (index, session) in existingSessions.enumerated() {
                if session.project == project,
                   existingSessions.indices.contains(index) {
                    existingSessions.remove(at: index)
                }
            }

            try saveSessions(existingSessions)
        } catch {
            throw FileManagerError.writeFailed(message: "Failed to delete project sessions. System Error: \(error.localizedDescription)")
        }
    }

    func deleteSession(_ session: Session) throws {
        do {
            guard sessionsJsonFileHasBeenCreated else { return }

            var existingSessions = getSessions()
            if let sessionIndex = existingSessions.firstIndex(of: session) {
                existingSessions.remove(at: sessionIndex)
                try saveSessions(existingSessions)
            }

            #warning("Remove session seconds from correct project")
        } catch {
            throw FileManagerError.writeFailed(message: "Failed to update projects. System Error: \(error.localizedDescription)")
        }
    }

    func clearStoredUserData() throws {
        try saveSessions([])
        try saveProjects([])
        WidgetCenter.shared.reloadAllTimelines()
    }
}
