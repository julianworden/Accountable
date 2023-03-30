//
//  SplashScreenView.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.purple

            Image("appIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        .ignoresSafeArea()
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
