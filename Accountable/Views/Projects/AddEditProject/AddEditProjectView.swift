//
//  AddEditProjectView.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

struct AddEditProjectView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = AddEditProjectViewModel()

    var projectToEdit: Project?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UiConstants.vStackSpacing) {
                    TextFieldWithLine(
                        text: $viewModel.projectName,
                        placeholder: "Name",
                        keyboardType: .default,
                        isSecure: false
                    )

                    TextFieldWithLine(
                        text: $viewModel.projectDescription,
                        placeholder: "Description",
                        keyboardType: .default,
                        isSecure: false
                    )

                    CustomSegmentedPicker(selectedIndex: $viewModel.selectedPriorityIndex, title: "Priority")

                    AsyncButton {
                        await viewModel.createProject()
                    } label: {
                        Text("Create Project")
                    }
                    .buttonStyle(Primary())
                    .disabled(viewModel.buttonsAreDisabled)
                }
                .padding([.top, .horizontal])
            }
            .navigationTitle("Create a Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .alert(
                "Error",
                isPresented: $viewModel.errorMessageIsShowing,
                actions: { Button("OK") { } },
                message: { Text(viewModel.errorMessageText) }
            )
            .onChange(of: viewModel.projectOperationCompleted) { projectOperationCompleted in
                if projectOperationCompleted {
                    dismiss()
                }
            }
        }
    }
}

struct AddEditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddEditProjectView()
        }
    }
}
