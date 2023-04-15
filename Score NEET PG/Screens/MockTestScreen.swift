//
//  MockTestScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import SwiftUI

struct MockTestScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var mockTestVM: MockTestViewModel = MockTestViewModel()
    @State private var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    @ObservedObject var inAppPurchase = InAppPurchaseManager.shared
    @State var selectedTab = 0
    
    let tabs: [TopTabObject] = [
           .init(icon: Image(systemName: "music.note"), title: "Grand Test"),
           .init(icon: Image(systemName: "film.fill"), title: "PYQs QB"),
           .init(icon: Image(systemName: "book.fill"), title: "QB Step 1"),
           .init(icon: Image(systemName: "book.fill"), title: "QB Step 2")
       ]
    
    let nursingTabs: [TopTabObject] = [.init(icon: Image(systemName: "music.note"), title: "Grand Tests"), .init(icon: Image(systemName: "film.fill"), title: "Subject Test")]
    
    let uslmeTabs: [TopTabObject] = [.init(icon: Image(systemName: "book.fill"), title: "Practice Test")]
    
    private var courseEnvironment = CourseEnvironment.shared
    
    var body: some View {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    
                    CustomInlineNavigationBar(name: "Mock Test")
                    
                    VStack(spacing: 0) {
                        if courseEnvironment.checkSelectedCourse() == Courses.NEETPG.rawValue {
                            TopTabBarView(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            
                            TabView(selection: $selectedTab,
                                    content: {
                                GrandTestChildView(vm: mockTestVM)
                                    .tag(0)
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "subject")
                                    .tag(1)
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "usmle1")
                                    .tag(2)
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "usmle2")
                                    .tag(3)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                        } else if courseEnvironment.checkSelectedCourse() == Courses.Nursing.rawValue {
                            
                            TopTabBarView(tabs: nursingTabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            
                            TabView(selection: $selectedTab,
                                    content: {
                                GrandTestChildView(vm: mockTestVM)
                                    .tag(0)
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "subject")
                                    .tag(1)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                            
                        } else if courseEnvironment.checkSelectedCourse() == Courses.USMLESTEP1.rawValue {
                            
                            TopTabBarView(tabs: uslmeTabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            
                            TabView(selection: $selectedTab,
                                    content: {
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "subject")
                                    .tag(0)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                        } else if courseEnvironment.checkSelectedCourse() == Courses.USMLESTEP2.rawValue {
                            
                            TopTabBarView(tabs: uslmeTabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            
                            TabView(selection: $selectedTab,
                                    content: {
                                SubjectTestChildView(vm: mockTestVM, currentScreen: "subject")
                                    .tag(0)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                        }
                        
                    
                    } // HEADER
                    
                   
                   
                    Spacer()
                    
                } //: VSTACK
                .onAppear {
                    K.byPassBaseURL = ""
                    selectedTab = 0
                }
                .navigationBarTitleDisplayMode(.inline)
    
            }
        
        
        
    }
}

struct MockTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        MockTestScreen()
    }
}
