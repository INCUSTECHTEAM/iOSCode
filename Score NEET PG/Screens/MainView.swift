//
//  MainView.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI


struct MainView: View {
    // MARK: - PROPERTIES
    
    @State private var isOnboardPresented: Bool = false
    @State var currentTab: Tab = .MockTest
    @State var reloadPractice = false
    
    //Hiding Tab Bar...
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            
            //TabView...
            TabView(selection: $currentTab) {
                
                
//                PracticeScreen(reload: $reloadPractice)
//                    .tag(Tab.Practice)
                
//                RevisionScreen()
  //                  .tag(Tab.Revision)
                
                MockTestScreen()
                    .tag(Tab.MockTest)
                
                NotesScreen()
                    .tag(Tab.Notes)
                
                SubjectsScreen()
                    .tag(Tab.Videos)
                
                SettingScreen()
                    .tag(Tab.Setting)
                
                
            } //: TAB
            .tabViewStyle(DefaultTabViewStyle())
            
            
            //Custom Tab Bar...
            
            VStack(spacing: 0) {
                
                Rectangle().fill(Color.textColor.opacity(0.2)).frame(height: 0.5, alignment: .center)//.offset(y: 5)
                
                
                
                HStack(spacing: 0) {
                    
                    ForEach(Tab.allCases, id: \.self) { tab in
                        
                        Button {
                            //updating tab...
                           
                            
//                            if currentTab == .Practice && currentTab == tab {
//                                reloadPractice.toggle()
//                            }
                            currentTab = tab
                            
                            
                        } label: {
                            
                            VStack(spacing: 5) {
                                Image(tab.rawValue)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(currentTab == tab ? .orangeColor : .black.opacity(0.3))
                                
                                Text(tab.rawValue)
                                    .font(.custom(K.Font.sfUITextRegular, size: 12))
                                    .foregroundColor(currentTab == tab ? .orangeColor : .black.opacity(0.3))
                                
                            } //: VSTACK
                        }
                        
                        
                    } //: LOOP
                } //: HSTACK
                .padding([.horizontal, .top], 5)
                .padding(.bottom, 5)
            }
            //.frame(height: 50)
            //.offset(y: -10)
            
            
            
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        //.edgesIgnoringSafeArea(.bottom)
        
    }
}

// MARK: - PREVIEW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
        MainView()
            .previewDevice("iPhone SE (3rd generation)")
    }
}

// MARK: - TAB CASES
enum Tab: String, CaseIterable {
    //case Practice = "Practice"
    case MockTest = "Mock Test"
    case Notes = "Notes"
   // case Revision = "Revision"
    case Videos = "Videos"
    case Setting = "Setting"
}


struct DeferView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()          // << everything is created here
    }
}
