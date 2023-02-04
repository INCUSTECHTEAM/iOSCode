//
//  SubjectCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 18/08/22.
//

import SwiftUI

struct SubjectCellView: View {
    //MARK: - PROPERTIES
    
    var subject: SubjectElement
    @State var navigatedToPPT = false
    @State var navigatedToVideo = false
    
    var isHidePPT = false
    
    //MARK: - BODY
    var body: some View {
        HStack {
            
            
            Text(subject.subjectName)
                .foregroundColor(.textColor)
                .lineLimit(1)
                .font(.custom(K.Font.sfUITextRegular, size: 18))
                .minimumScaleFactor(0.5)
                .padding(.all)
                .onTapGesture {
                    
                    print("Nothing working")
                    
                }
            
            Spacer()
                
            
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding()
                    .onTapGesture {
                        
                        navigatedToVideo = true
                        
                    }
                    .background(
                        NavigationLink("", destination: VideoListScreen(subjectID: subject.id.description), isActive: $navigatedToVideo).opacity(0)
                    )
            
            
            if isHidePPT {
                Image("tecaher")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.textColor)
                    .padding()
                    .onTapGesture {
                            navigatedToPPT = true
                    }
                    .background(
                        NavigationLink("", destination: PPTListView(subjectID: subject.id.description), isActive: $navigatedToPPT).opacity(0)
                    )
            }
                
            
           
                
            
            
        }
        .background(Color.cellLightGreyColor).cornerRadius(10)
        .onTapGesture {
            
            print("Nothing working")
            
        }
        
    }
}

struct SubjectCellView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectCellView(subject: SubjectElement(id: 1, subjectName: "Cardiology", subjectDescription: "cardiology"))
            .previewLayout(.sizeThatFits)
    }
}
