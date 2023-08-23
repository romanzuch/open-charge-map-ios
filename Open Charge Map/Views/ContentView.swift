//
//  ContentView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            MapView(with: StateObject(wrappedValue: MapViewModel()))
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            Text("More")
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
