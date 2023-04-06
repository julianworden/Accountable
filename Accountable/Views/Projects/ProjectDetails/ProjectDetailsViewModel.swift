//
//  ProjectDetailsViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import Foundation

class ProjectDetailsViewModel: ObservableObject {
    @Published var sessionViewIsShowing = false

    let project: Project

    init(project: Project) {
        self.project = project
    }
}
