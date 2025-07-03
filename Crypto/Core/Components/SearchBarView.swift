//
//  SearchBarView.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 15/05/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String 
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                    Color.theme.secondaryText :
                        Color.theme.accent
                )
            TextField("Search By name or symbol..", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }.font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.background.opacity(0.15))
                    .shadow(color: Color.theme.background, radius: 10,x:0,y: 0)
            ).padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
