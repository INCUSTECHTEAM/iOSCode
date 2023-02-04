//
//  Loader.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI

struct Loader: View {
    // MARK: - PROPERTIES
    
    @State var animate = false
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [.orangeColor]), center: .center), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 20, height: 20)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
            
            Text("Please Wait...")
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextRegular, size: 12))
                .padding(.top)
        } //: VSTACK
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .onAppear {
            withAnimation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                self.animate = true
            }
        }
    }
}

// MARK: - PREVIEW
struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
