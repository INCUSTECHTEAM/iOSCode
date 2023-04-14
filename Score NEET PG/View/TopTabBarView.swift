//
//  TopTabBarView.swift
//  Score NEET PG
//
//  Created by Rahul on 14/04/23.
//

import SwiftUI

struct TopTabObject {
    var icon: Image?
    var title: String
}
struct TopTabBarView: View {
    var fixed = true
    var tabs: [TopTabObject]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        /*
                                        // Image
                                        AnyView(tabs[row].icon)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                         */
                                        // Text
                                        Text(tabs[row].title)
                                            .font(.custom(K.Font.sfUITextBold, size: 14))
                                            .foregroundColor(selectedTab == row ? .orangeColor : .textColor)
                                            //.foregroundColor(Color.white)
                                            .minimumScaleFactor(0.7)
                                            .multilineTextAlignment(.center)
                                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 52)
                                    // Bar Indicator
                                    Rectangle().fill(selectedTab == row ? Color.orangeColor : Color.clear)
                                        //.frame(height: 3)
                                        .frame(width: 60, height: 2)
                                }.fixedSize()
                            })
                                .accentColor(Color.white)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
        .onAppear(perform: {
            //UIScrollView.appearance().backgroundColor = UIColor(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1))
            UIScrollView.appearance().backgroundColor = UIColor(named: "BackgroundColor")
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}
struct TopTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabBarView(fixed: true,
             tabs: [.init(icon: Image(systemName: "star.fill"), title: "Tab 1"),
                    .init(icon: Image(systemName: "star.fill"), title: "Tab 2"),
                    .init(icon: Image(systemName: "star.fill"), title: "Tab 3")],
             geoWidth: 375,
             selectedTab: .constant(0))
    }
}
