//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Kirills Galenko on 29/12/2023.
//

import SwiftUI

struct ContentView: View {
    // IntroScreen Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    // Active tab
    @State private var activeTab: Tab = .recents
    var body: some View {
        TabView(selection: $activeTab){
            Recents()
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            
            Search()
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            
            Graphs()
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            
            Settings()
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
