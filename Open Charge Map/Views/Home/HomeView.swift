//
//  HomeView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 23.08.23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject private var router: RouterService
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Around
                    HomeViewListContainer(with: $viewModel.locationProxResult, isLoading: $viewModel.loadingProxResults, geo: geo)
                        .onAppear {
                            viewModel.fetchLocations()
                        }
                        .environmentObject(router)
                    
                    // Favorites
                    Text("Favoriten").fontWeight(.bold)
                    Text("hier können favoriten stehen").font(.caption2)
                    
                    // Map
                    Text("Karte").fontWeight(.bold)
                    MapView(type: .passive)
                        .frame(width: geo.size.width - 16, height: geo.size.height/3, alignment: .center)
                        .onTapGesture {
                            router.switchTab(to: .Map)
                        }
                        .cornerRadius(8)
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
