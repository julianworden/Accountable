//
//  CustomSegmentedPicker.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Namespace private var animation

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

                        if index == selectedIndex {
                            Rectangle()
                                .fill(.purple)
                                .cornerRadius(20)
                                .matchedGeometryEffect(id: "SELECTION", in: animation)
                        }
                    }
                    .overlay {
                        Text(Priority.allCases[index].rawValue.capitalized)
                            .foregroundColor(.white)
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
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
