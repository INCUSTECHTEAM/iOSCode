//
//  CustomInlineNavigationBar.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 10/12/22.
//

import SwiftUI

struct CustomInlineNavigationBar: View {
    //MARK: - PROPERTIES
    
    var name: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(name)
                    .font(.custom(K.Font.sfUITextBold, size: 18))
                    .foregroundColor(.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
            }
            .overlay(alignment: name == "Search" ? .leading : .trailing) {
                NavigationLink {
                    CourseSelectionScreen(navToHome: {})
                } label: {
                    VStack(spacing: 0) {
                        Image("duration")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.orangeColor)
                            .frame(width: 30, height: 30)
                        
                        Text("Course")
                            .font(.custom(K.Font.sfUITextRegular, size: 13))
                            .foregroundColor(.orangeColor)
                    }
                    .padding()
                }
            }
            .overlay(alignment: .leading) {
                if name != "Search" {
                    NavigationLink {
                        SettingScreen()
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.orangeColor)
                                .frame(width: 30, height: 30)
                            
                            Text("Setting")
                                .font(.custom(K.Font.sfUITextRegular, size: 13))
                                .foregroundColor(.orangeColor)
                        }
                        .padding()
                    }
                }
                  
                
            }
        } //: ZSTACK
        .background(Color.backgroundColor)
    }
}

struct CustomInlineNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomInlineNavigationBar(name: "Mock Test")
            .previewLayout(.sizeThatFits)
    }
}
