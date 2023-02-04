//
//  OnboardCardView.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI

struct OnboardCardView: View {
    // MARK: - PROPERTIES
    
    var onboard: Onboard
    @State private var isLoginViewPresented = false
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            Image(onboard.image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 312, maxHeight: 312)
                .padding(.horizontal)
            
            Text(onboard.description)
                .font(.custom(K.Font.sfUITextRegular, size: 16))
                .foregroundColor(.textColor)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            
            if onboard.isNextButtonShow {
                
                NavigationLink {
                    SignUpScreen()
                        .onAppear {
                            isEnableBack = false
                        }
                        .onDisappear {
                            isEnableBack = true
                        }
                    
                } label: {
                    
                    Text("Next")
                        .modifier(ButtonTextModifier())
        
                }
                .modifier(ButtonRectangleModifier())
                .frame(width: 200)

            }
            
            
            Spacer()
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}


struct OnboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardCardView(onboard: onboardData[0])
            .previewLayout(.sizeThatFits)
    }
}
