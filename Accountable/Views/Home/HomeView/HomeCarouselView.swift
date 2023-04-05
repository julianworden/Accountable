//
//  HomeCarouselView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct HomeCarouselView: View {
    @ObservedObject var viewModel: HomeViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .light ? .white : .lightGray)
                .shadow(color: .purple.opacity(0.25), radius: 5)

            Text("You haven't worked on Accountable yet. When you do, you'll see your hours here.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(height: 300)
    }
}

struct HomeCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCarouselView(viewModel: HomeViewModel())
    }
}
