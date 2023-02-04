//
//  OnboardView.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI

struct OnboardScreen: View {
    // MARK: - PROPERTIES
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.orange
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "TextColor")!.withAlphaComponent(0.2)
    }
    
    var onboards: [Onboard] = onboardData
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack{
                TabView {
                    ForEach(onboards) { item in
                        OnboardCardView(onboard: item)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            } //: VSTACK
            .navigationBarHidden(true)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW
struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardScreen()
        
        OnboardScreen()
            .previewDevice("iPhone 12")
    }
}
