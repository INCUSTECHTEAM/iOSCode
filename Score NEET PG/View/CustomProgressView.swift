//
//  CustomProgressView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct CustomProgressView: View {
    //MARK: - PROPERTIES
    @Binding var progress: CGFloat
    var text: String
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            // progress track
            Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(.gray)
                .opacity(0.2)
            // progress circle
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(AngularGradient(colors: [.orangeColor], center: .center), style: StrokeStyle(lineWidth: 5, lineCap: .butt, lineJoin: .miter))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 2)
            
            Text(text)
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextBold, size: 18))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        //.frame(width: 100, height: 100)
        .animation(.easeInOut, value: progress)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(progress: .constant(0.0), text: "12233")
    }
}
