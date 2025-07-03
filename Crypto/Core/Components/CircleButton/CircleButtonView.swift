//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 07/05/25.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .frame(width: 50,height: 50)
                .background(
                    Circle()
                        .foregroundColor(Color.theme.background)
                )
                .shadow(color: Color.theme.accent.opacity(0.25),
                        radius: 10,x: 0,y: 0)
                .padding()
        }
        
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CircleButtonView(iconName: "info")
}
