//
//  CustomNavigationView.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI

struct CustomNavigationView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    var name: String?
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(.textColor)
                        .frame(width: 10, height: 10, alignment: .center)
                        .padding(15)
                        .background(
                            Color.gray.opacity(0.3)
                        )
                        .cornerRadius(8)
                }
                //.padding(10)
                
                Text(name ?? "")
                    .font(.custom(K.Font.sfUITextBold, size: 18))
                    .foregroundColor(.textColor)
                
                Spacer()
            } //: HSTACK
            //            Text(name)
            //                .font(.custom(K.Font.Inter.semiBold, size: 18))
            //                .foregroundColor(.colorDarkTitle)
        } //: ZSTACK
        .background(Color.backgroundColor)
    }
}

// MARK: - PREVIEW
struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView(name: "Videos")
            .previewLayout(.sizeThatFits)
    }
}
