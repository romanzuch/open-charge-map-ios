//
//  ContentView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router: RouterService = RouterService()
    var body: some View {
        NavigationStack {
            TabView(selection: $router.currentTab) {
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tab.Home)
                    .environmentObject(router)
                
                MapView()
                    .edgesIgnoringSafeArea(.top)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(Tab.Map)
                
                Text("More")
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                    }
                    .tag(Tab.More)
                
            }
            .navigationTitle(router.currentTab.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
