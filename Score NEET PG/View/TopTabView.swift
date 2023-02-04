//
//  TopTabView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import SwiftUI

struct TopTab {
    var title: String
}

struct TopTabView: View {
    
    var tabs: [TopTab]
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { row in
                HStack(spacing: 0) {
                    Button {
                        DispatchQueue.main.async{
                            selectedTab = row
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Text(tabs[row].title)
                                .font(.custom(K.Font.sfUITextBold, size: 16))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .foregroundColor(selectedTab == row ? .orangeColor : .textColor)
                                .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Rectangle().fill(selectedTab == row ? Color.orangeColor : Color.clear)
                                    .frame(width: 60, height: 2)
                                Spacer()
                            }
                        }
                        .frame(height: 52)
                    }

                }
            }
        } //: HSTACK
    }
}

struct TopTabView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabView(tabs: [.init(title: "Grand Test"), .init(title: "Subject Test")], selectedTab: .constant(1))
    }
}
