//
//  DetailView.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 14/06/25.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State private var showFullDescription = false;

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue:  DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing: 20){
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack {
                    overviewTitle
                    Divider()
                    descriptionSection
                    Divider()
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    webSiteView
                   
                    
                }.padding()
            }
        }.navigationTitle(vm.coin.name)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItem
                }
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLoadingView(coin: .constant(dev.coin))
    }
}

extension DetailView {
    
    private var webSiteView: some View {
        VStack(alignment: .leading) {
            if let websiteString = vm.webSiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
            
        }.accentColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ?  "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                    }
                    .accentColor(.blue)
                    
                }.frame(width: .infinity, alignment: .leading)
            }
        }
    }
    private var navigationBarTrailingItem : some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25,height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,alignment: .center,spacing: spacing,pinnedViews: []) {
            ForEach(vm.overviewStatistics){ stat in
                StatisticsView(stat: stat)
            }
        }

    }
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,alignment: .center,spacing: spacing,pinnedViews: []) {
            ForEach(vm.additionalStatistics){ stat in
                StatisticsView(stat: stat)                    }
        }
    }
}
