//
//  TabBarScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 06/12/22.
//

import SwiftUI


enum NewTab: String {
    case mocktest = "Mock Test"
    case notes = "Notes"
    case videos = "Videos"
    case search = "Search"
    case setting = "Setting"
}

struct TabBarScreen: View {
    //MARK: - PROPERTIES
    
    @State var currentTab: NewTab
    
    //MARK: -  BODY
    var body: some View {
        NavigationView {
            TabView(selection: $currentTab) {
                MockTestScreen()
                    .tabItem {
                        Image("exam")
                        Text("Mock Test")
                    }
                    .tag(NewTab.mocktest)
                
                
                NotesScreen()
                    .tabItem {
                        Image("right")
                        Text("AI Tutor")
                    }
                    .tag(NewTab.notes)
                
                SubjectsScreen()
                    .tabItem {
                        Image("videoTab")
                        Text("Videos")
                    }
                    .tag(NewTab.videos)
                
                
                SearchScreen()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(NewTab.search)
                
                SettingScreen()
                    .tabItem {
                        Image("application")
                        Text("Setting")
                    }
                    .tag(NewTab.setting)
                
                
            }
            .navigationBarTitle(currentTab.rawValue)
            .navigationBarTitleDisplayMode(currentTab == .setting ? .large : .inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        
        
    }
}

struct TabBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabBarScreen(currentTab: .mocktest)
    }
}
