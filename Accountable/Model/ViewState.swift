//
//  ViewState.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Foundation

enum ViewState: Equatable {
    case displayingView
    case performingWork
    case workCompleted
    case dataLoading
    case dataLoaded
    case dataNotFound
    case error(message: String)
}
