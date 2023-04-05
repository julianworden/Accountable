//
//  HomeCarouselView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct HomeCarouselView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            CustomGroupBox()

            Text("You haven't worked on Accountable yet. When you do, you'll see your hours here.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(height: UiConstants.primaryBoxHeight)
    }
}

struct HomeCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCarouselView(viewModel: HomeViewModel())
    }
}
