//
//  SubjectTestCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import SwiftUI

struct SubjectTestCellView: View {
    //MARK: - PROPERTIES
    
    var subject: SubjectTestResponseElement
    @State var isSubjectMockPresented = false
    @State var isTopicScreenPresented = false
    var isTrial = false
    
    //MARK: - BODY
    var body: some View {
        HStack {
            if paymentStatus == false && !isTrial {
                Image(systemName: "lock.fill")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 26))
                    .padding(.leading)
            }
            
            Text(subject.name ?? "")
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextRegular, size: 14))
                .minimumScaleFactor(0.7)
                .padding(.all)
            
            Spacer()
            
            if isTrial || paymentStatus == true {
                HStack {
                    Button {
                        
                    } label: {
                        VStack {
                            Text(subject.totalTopics?.description ?? "0")
                                .foregroundColor(.white)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.all)
                                .background {
                                    Circle()
                                        .foregroundColor(.orangeColor)
                                        .frame(minWidth: 60)
                                }
                            
                            Text("Total Topics")
                                .lineLimit(1)
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 9))
                                .minimumScaleFactor(0.5)
                        }
                        .onTapGesture {
                            isTopicScreenPresented.toggle()
                        }
                        .background(
                            NavigationLink("", destination: TopicScreen(subjectID: subject.id?.description ?? "0"), isActive: $isTopicScreenPresented).opacity(0)
                        )
                    }
                    
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Text(subject.totalQuestion?.description ?? "0")
                                .foregroundColor(.white)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(minWidth: 60)
                                .padding(.all)
                                .background {
                                    Circle()
                                        .foregroundColor(.orangeColor)
                                        .frame(minWidth: 60)
                                }
                            
                            Text("Total MCQs")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 9))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        .onTapGesture {
                            isSubjectMockPresented.toggle()
                        }
                        .background(
                            NavigationLink("", destination: SubjectMockTestListScreen(gtId: subject.id ?? 0), isActive: $isSubjectMockPresented).opacity(0)
                        )
                    }
                    
                } //: HSTACK
                .padding(.trailing)
                .padding(.vertical)
            }
            
            
            
            
            
        } //: HSTACK
        .padding(.vertical, 10)
        .background(Color.cellLightGreyColor).cornerRadius(10)
    }
}

/*
struct SubjectTestCellView_Previews: PreviewProvider {
    static var previews: some View {
        let subject = SubjectTestResponseElement(name: "JJ", id: 1)
        SubjectTestCellView(subject: subject)
    }
}
*/
