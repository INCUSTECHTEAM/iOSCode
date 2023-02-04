//
//  ChipsView.swift
//  Score MLE
//
//  Created by ios on 01/08/22.
//

import SwiftUI

struct ChipsView: View {
    // MARK: - PROPERTIES
    
    let titleKey: String //text or localisation value
    @State var isSelected: Bool
    
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Text(titleKey)
                .font(.custom(K.Font.sfUITextRegular, size: 12))
                .lineLimit(1)
        }.padding(.all, 5)
            .foregroundColor(isSelected ? .backgroundColor : .textColor)
            .background(isSelected ? Color.textColor : Color.backgroundColor) //different UI for selected and not selected view
            .cornerRadius(10)  //rounded Corner
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textColor, lineWidth: 1.5)
                
            )
    }
}


struct ChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipsView(titleKey: "Rahul", isSelected: true)
            .previewLayout(.sizeThatFits)
    }
}
