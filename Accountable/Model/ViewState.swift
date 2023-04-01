//
//  ViewState.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Foundation

enum ViewState {
    case displayingView
    case performingWork
    case workCompleted
    case error(message: String)
}
