//
//  QuizOptionView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 09/12/22.
//

import SwiftUI

struct QuizOptionView: View {
    //MARK: PROPERTIES
    
    var option: String
    @Binding var isMatched: Bool
    @Binding var isSelected: Bool
    var onClick = {}
    
    var body: some View {
        
        VStack {
            Button {
                onClick()
            } label: {
               // Spacer()
                Text(option)
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 16))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                    
                Spacer()
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((isMatched && isSelected) ? .answerCorrectColor : (!isMatched && isSelected) ? .answerWrongColor : Color.gray.opacity(0.15))
            }
        } //: VSTACK
    }
}

struct QuizOptionView_Previews: PreviewProvider {
    static var previews: some View {
        QuizOptionView(option: "A", isMatched: .constant(false), isSelected: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
