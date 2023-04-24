//
//  FileManagerConstants.swift
//  Accountable
//
//  Created by Julian Worden on 4/23/23.
//

import Foundation

struct FileManagerConstants {
    static var appGroupUrl: URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupConstants.id)!
    }

    static var projectsUrl: URL {
        return appGroupUrl.appending(path: "allprojects.json")
    }

    static var sessionsUrl: URL {
        return appGroupUrl.appending(path: "allsessions.json")
    }
}
