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

//struct TabBarScreen: View {
//    //MARK: - PROPERTIES
//
//    @State var currentTab: NewTab
//
//    //MARK: -  BODY
//    var body: some View {
//        NavigationView {
//            TabView(selection: $currentTab) {
//                MockTestScreen()
//                    .tabItem {
//                        Image("exam")
//                        Text("Mock Test")
//                    }
//                    .tag(NewTab.mocktest)
//
//
//                NotesScreen()
//                    .tabItem {
//                        Image("right")
//                        Text("AI Tutor")
//                    }
//                    .tag(NewTab.notes)
//
//                SubjectsScreen()
//                    .tabItem {
//                        Image("videoTab")
//                        Text("Videos")
//                    }
//                    .tag(NewTab.videos)
//
//
//                SearchScreen()
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                        Text("Search")
//                    }
//                    .tag(NewTab.search)
//
//                SettingScreen()
//                    .tabItem {
//                        Image("application")
//                        Text("Setting")
//                    }
//                    .tag(NewTab.setting)
//
//
//            }
//            .navigationBarTitle(currentTab.rawValue)
//            .navigationBarTitleDisplayMode(currentTab == .setting ? .large : .inline)
//            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(.stack)
//
//
//    }
//}

struct TabBarScreen: View {
    //MARK: - PROPERTIES

    @State var currentTab: NewTab = .mocktest

    let tabs: [(NewTab, Image, String)] = [
        (.mocktest, Image(uiImage: UIImage(named: "exam")!), "Mock Test"),
        (.notes, Image(uiImage: UIImage(named: "Notes")!), "AI Tutor"),
        (.videos, Image(uiImage: UIImage(named: "videoTab")!), "Videos"),
        (.search, Image(systemName: "magnifyingglass"), "Search"),
        (.setting, Image(uiImage: UIImage(named: "application")!), "Settings")
    ]

    //MARK: -  BODY
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch currentTab {
                case .mocktest:
                    MockTestScreen()
                case .notes:
                    NotesScreen()
                case .videos:
                    SubjectsScreen()
                case .search:
                    SearchScreen()
                case .setting:
                    SettingScreen()
                }
                Spacer()

                HStack(spacing: 0) {
                    ForEach(tabs, id: \.0) { tab in

                        Button(action: {
                            withAnimation {
                                currentTab = tab.0
                            }
                        }, label: {
                            VStack {
                                tab.1
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(currentTab == tab.0 ? Color.orangeColor : .gray)

                                Text(tab.2)
                                    .font(.system(size: 10))
                                    .foregroundColor(currentTab == tab.0 ? Color.orangeColor : .gray)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .zIndex(currentTab == tab.0 ? 1 : 0)
                        })
                        .buttonStyle(PlainButtonStyle())

                    }
                }
                .padding(.horizontal)


            }
            .navigationBarTitle(currentTab.rawValue)
            .navigationBarTitleDisplayMode(currentTab == .setting ? .large : .inline)
            .navigationBarHidden(true)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(.stack)
    }
}

struct TabBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabBarScreen(currentTab: .mocktest)
    }
}

