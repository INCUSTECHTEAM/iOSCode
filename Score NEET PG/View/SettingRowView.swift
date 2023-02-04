//
//  SettingRowView.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI

struct SettingRowView: View {
    // MARK: - PROPERTIES
    
    var linkLabel: String
    var linkDestination: String? = nil
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if linkDestination != nil {
                    Link(destination: URL(string: "https://\(linkDestination!)")!) {
                        HStack {
                            Text(linkLabel)
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextBold, size: 16))
                            Spacer()
                            Image(systemName: "arrow.up.right").foregroundColor(.gray)
                        }
                    }
                } else {
                    HStack {
                        Text("Delete Account")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextBold, size: 16))
                        Spacer()
                    }
                }
            }
            //.padding(.horizontal)
            
            Spacer()
        }
    }
}

// MARK: - PREVIEW
struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRowView(linkLabel: "Rahul", linkDestination: "http")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
