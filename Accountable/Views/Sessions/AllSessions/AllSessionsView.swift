//
//  AllSessionsView.swift
//  Accountable
//
//  Created by Julian Worden on 4/8/23.
//

import SwiftUI

struct AllSessionsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: AllSessionsViewModel

    init(sessions: [Session]) {
        _viewModel = StateObject(wrappedValue: AllSessionsViewModel(sessions: sessions))
    }

    var body: some View {
        List {
            ForEach(viewModel.sessions) { session in
                SessionRow(session: session)
                    .listRowSeparator(.hidden)
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.deleteSessionAt(indexSet)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("All Sessions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
        .alert(
            "Error",
            isPresented: $viewModel.errorMessageIsShowing,
            actions: { Button("OK") { } },
            message: { Text(viewModel.errorMessageText) }
        )
        .onChange(of: viewModel.dismissView) { dismissView in
            if dismissView {
                dismiss()
            }
        }
    }
}

struct AllSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        AllSessionsView(sessions: [])
    }
}
