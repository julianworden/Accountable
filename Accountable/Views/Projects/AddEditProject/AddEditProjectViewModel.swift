//
//  AddEditProjectViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import Foundation

@MainActor
final class AddEditProjectViewModel: ObservableObject {
    @Published var projectName = ""
    @Published var projectDescription = ""
    @Published var selectedPriorityIndex = 1
}
