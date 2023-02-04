//
//  FullGraphArrayView.swift
//  Score MLE
//
//  Created by Manoj kumar on 08/08/22.
//

import SwiftUI
import Kingfisher

struct FullGraphArrayView: View {
    //MARK: - PROPERTIES
    
    var graphs: [FullGraph]
    var userIcon: String
    
    //MARK: - BODY
    var body: some View {
        HStack {
            VStack {
                KFImage(URL(string: userIcon) ?? URL(string: "https://vongo-chatbot.s3.ap-south-1.amazonaws.com/Asset_9500x.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYMW7FB2HE6ZFEL4V%2F20220729%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20220729T192625Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=91076c0dd53e0285589942fb364223cd920f8a420a23e02bd6df2d5094222c1d"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
                    .background(Color.textColor.cornerRadius(30))
                    .padding(.leading)
                
                Spacer()
            }
            
            
            VStack {
                
                ForEach(graphs, id: \.subName) { graph in
                    
                    
                    Text("\(graph.subName) Score -\(graph.subScore)")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextBold, size: 16))
                            .offset(x: -30)
                            .padding(.top)
                    
                    
                        GraphView(name: "Right Answer", width: 200, height: 30, borderColor: .pink, color: .pink.opacity(0.2), count: String(graph.ra), fontSize: 14)
                            .padding(.bottom, 10)
                    
                        
                        GraphView(name: "Wrong Answer", width: 190, height: 30, borderColor: .blue.opacity(0.3), color: .lightBlue, count: String(graph.wa), fontSize: 14)
                            .padding(.bottom, 10)
                    
                        
                    
                    
                        GraphView(name: "Skip Answer", width: 160, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph.sa), fontSize: 14)
                            .padding(.bottom, 10)
                    
                        
                    
                    
                        GraphView(name: "Total Answer", width: 150, height: 30, borderColor: .blue.opacity(0.3), color: Color("ColorVioletLight"), count: String(graph.score), fontSize: 14)
                            .padding(.bottom, 10)
                    
                        
                    
                }
            }
            .padding(.bottom)
        }
    }
}

//MARK: - PREVIEW
struct FullGraphArrayView_Previews: PreviewProvider {
    static var previews: some View {
        FullGraphArrayView(graphs: [
            FullGraph(ra: 1,
                      sa: 1,
                      wa: 1,
                      score: 1,
                      subName: "Rahul",
                      subScore: 1)
        ], userIcon: "https://vongo-chatbot.s3.ap-south-1.amazonaws.com/Asset_9500x.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYMW7FB2HE6ZFEL4V%2F20220729%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20220729T192625Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=91076c0dd53e0285589942fb364223cd920f8a420a23e02bd6df2d5094222c1d"
        )
        .previewLayout(.sizeThatFits)
        
    }
}
