//
//  CustomSegmentedPicker.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding var selectedIndex: Int

    let title: String?

    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .foregroundColor(.textFieldPrompt)
            }

            HStack(spacing: 0) {
                ForEach(Priority.allCases.indices, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .fill(.purple.opacity(0.2))

                        Rectangle()
                            .fill(.purple)
                            .cornerRadius(20)
                            .opacity(index == selectedIndex ? 1 : 0.01)
                            .onTapGesture {
                                selectedIndex = index
                            }
                            .animation(.easeInOut, value: selectedIndex)
                    }
                    .overlay {
                        Text(Priority.allCases[index].rawValue.capitalized)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 40)
            .cornerRadius(20)
        }
    }
}

struct CustomSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPicker(selectedIndex: .constant(1), title: "Priority")
            .padding(.horizontal)
    }
}
