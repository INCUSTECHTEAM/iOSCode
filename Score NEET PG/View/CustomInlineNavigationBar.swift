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
                
                Spacer()
                
                Text(name)
                    .font(.custom(K.Font.sfUITextBold, size: 18))
                    .foregroundColor(.textColor)
                    .padding(.all, 10)
                
                Spacer()
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
