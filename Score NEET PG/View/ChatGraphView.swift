//
//  ChatGraphView.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI

struct ChatGraphView: View {
    // MARK: - PROPERTIES
    
    let graph: [String: Int]
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 0) {
            
            Rectangle()
                .foregroundColor(.textColor.opacity(0.7))
                .frame(width: 1)
            
            VStack {
                
               // Spacer(minLength: 10)
                
                if graph["total_mcqs"]! as Int > 0 {
                    
                    GraphView(name: "Total MCQs", width: 200, height: 30, borderColor: .pink, color: .pink.opacity(0.2), count: String(graph["total_mcqs"]! as Int), fontSize: 14)
                    
                }
                
                
                if graph["mcqs_you_correctly_answered"]! as Int > 0 {
                    
                    GraphView(name: "MCQs you correctly Answered", width: 190, height: 30, borderColor: .blue.opacity(0.3), color: .lightBlue, count: String(graph["mcqs_you_correctly_answered"]! as Int), fontSize: 14)
                    
                }
                
                if graph["mcqs_you_wrongly_answered"]! as Int > 0 {
                    
                    GraphView(name: "MCQs you Wrongly Answered", width: 180, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph["mcqs_you_wrongly_answered"]! as Int), fontSize: 14)
                }
                
                
                if graph["total_high_yield_facts"]! as Int > 0 {
                    
                    GraphView(name: "Total High Yield Facts", width: 170, height: 30, borderColor: .white, color: Color("ColorOffWhite"), count: String(graph["total_high_yield_facts"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyfs_you_know"]! as Int > 0 {
                    
                    GraphView(name: "HYFs you Know", width: 160, height: 30, borderColor: Color.lightGreenColor, color: Color("ColorLightGreen"), count: String(graph["hyfs_you_know"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyfs_yo_dont_Know"]! as Int > 0 {
    
                    GraphView(name: "HYFs you Don't Know", width: 155, height: 30, borderColor: Color("ColorBeige"), color: Color("ColorBeige"), count: String(graph["hyfs_yo_dont_Know"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyfs_you_bookmarked"]! as Int > 0 {
                    
                    GraphView(name: "HYFs you Bookmarked", width: 150, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph["hyfs_you_bookmarked"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyvs_you_know"]! as Int > 0 {
                    
                    GraphView(name: "HYFs Video Know", width: 145, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph["hyvs_you_know"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyvs_yo_dont_Know"]! as Int > 0 {
                    
                    GraphView(name: "HYFs Video Don't Know", width: 140, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph["hyvs_yo_dont_Know"]! as Int), fontSize: 14)
                    
                }
                
                if graph["hyvs_you_bookmarked"]! as Int > 0 {
                    
                    GraphView(name: "HYFs Video Bookmarked", width: 135, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph["hyvs_you_bookmarked"]! as Int), fontSize: 14)
                    
                }
                
              //  Spacer(minLength: 15)
                
            }
            .padding(.vertical, 10)
            
            Spacer()
            
        }
    }
}

struct ChatGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGraphView(graph: ["total_mcqs" : 1,
                              "mcqs_you_correctly_answered" : 3
                             ])
        .previewLayout(.sizeThatFits)
    }
}
