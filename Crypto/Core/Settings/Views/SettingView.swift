//
//  SettingView.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 21/06/25.
//

import SwiftUI

struct SettingView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youTubeURL = URL(string: "https://www.youtube.com/@Mr.X7")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    
    var body: some View {
        NavigationView {
            List {

                logoSection
                coinGeckoSection
                developerSection
            }.navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton()
                    }
                }
        }
    }
}

extension SettingView {
    
    var logoSection: some View {
        Section(header: Text("Sarthak Deshmukh")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app uses MVVM architecture,Combine, and CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }.padding(.vertical)
        }
    }
    
    var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data is used in this app, data is coming from free API from CoinGecko Prices may be delayed")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }.padding(.vertical)
            Link("Visit CoinGecko",destination: coingeckoURL)
        }
    }
    
    var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This App is developed by Sarthak Deshmukh. It uses SWiftUI and is written 100% in swift. The Project benefits from multi-threading. publishers/subscribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }.padding(.vertical)
        }
    }
}

#Preview {
    SettingView()
}
