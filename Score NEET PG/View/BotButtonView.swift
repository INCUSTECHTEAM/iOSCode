//
//  BotButtonView.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import SwiftUI

struct BotButtonView: View {
    
    let titleKey: String //text or localisation value
    
    var body: some View {
        HStack {
            Text(titleKey)
                .font(.custom(K.Font.sfUITextBold, size: 18))
                .lineLimit(nil)
        }.padding(.all, 10)
            .foregroundColor(.textColor)
            .background(Color.lightGreenColor) //different UI for selected and not selected view
            .cornerRadius(10)  //rounded Corner
    }
}

struct BotButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BotButtonView(titleKey: "I Don't Know")
    }
}
