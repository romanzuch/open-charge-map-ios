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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Around
                HomeViewListContainer(with: $viewModel.locationProxResult, isLoading: $viewModel.loadingProxResults)
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
                    .frame(height: 240)
                    .onTapGesture {
                        router.switchTab(to: .Map)
                    }
                    .cornerRadius(8)
                    .boxShadow()
            }
            .padding(.horizontal, 8)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let router: RouterService = RouterService()
        HomeView()
            .environmentObject(router)
    }
}
