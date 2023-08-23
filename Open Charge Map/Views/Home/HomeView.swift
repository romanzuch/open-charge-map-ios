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
                VStack {
                    // Around
                    Text("Here will be some locations around you...")
                    
                    // Favorites
                    Text("Here will be your favorites...")
                    
                    // Map
                    MapView(type: .passive)
                        .frame(width: geo.size.width, height: geo.size.height/3, alignment: .center)
                        .onTapGesture {
                            router.switchTab(to: .Map)
                        }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
