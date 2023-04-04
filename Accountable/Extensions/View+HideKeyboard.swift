//
//  View+HideKeyboard.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
