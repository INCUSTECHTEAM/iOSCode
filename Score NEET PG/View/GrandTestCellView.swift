//
//  GrandTestCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import SwiftUI

struct GrandTestCellView: View {
    //MARK: - PROPERTEIS
    
    var mockTestResponseElement : MockTestResponseElement
    @State var isLeaderPresented: Bool = false
    @State var isReviewSheetPresented: Bool = false
    @State var isQuizSheetPresented: Bool = false
    var isFromSt = false
    var isTrial: Bool = false
    
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                if paymentStatus == false && !isTrial {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 26))
                    
                }
                
                Text(paymentStatus == true ? mockTestResponseElement.testName ?? "" : !isTrial ? mockTestResponseElement.testName ?? "" : "Free Mock Test")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 60)
                Spacer()
            } //: HSTACK
            
            
            if isTrial || paymentStatus == true {
                HStack {
                    Button {
                        // Action
                    } label: {
                        Text(mockTestResponseElement.completed ?? false ? "Completed" : mockTestResponseElement.resume ?? false ? "Resume" : "Start")
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                            .minimumScaleFactor(0.8)
                            .onTapGesture {
                                if mockTestResponseElement.completed == false {
                                    
                                    isQuizSheetPresented.toggle()
                                    
                                }
                            }
                            .background(
                                NavigationLink("", destination: GtQuizScreen(gtId: mockTestResponseElement.id?.description ?? "0"), isActive: $isQuizSheetPresented).opacity(0)
                            )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background {
                        Rectangle().fill(Color.orangeColor).cornerRadius(30)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    if mockTestResponseElement.resume ?? false || mockTestResponseElement.completed ?? false {
                        Button {
                            // Action
                        } label: {
                            Text("Review")
                                .foregroundColor(.textColor)
                                .lineLimit(1)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                                .minimumScaleFactor(0.9)
                                .onTapGesture {
                                    
                                    isReviewSheetPresented.toggle()
                                    
                                }
                                .background(
                                    NavigationLink("", destination: ReviewQuestionsScreen(questionId: mockTestResponseElement.id?.description ?? "0", isHideUnanswered: mockTestResponseElement.completed ?? false ? false : true), isActive: $isReviewSheetPresented).opacity(0)
                                )
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background {
                            Rectangle().fill(Color.white).cornerRadius(30)
                        }
                        
                        Spacer()
                        
                        Button {
                            //Action
                        } label: {
                            Text("Analysis")
                                .foregroundColor(.textColor)
                                .lineLimit(1)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                                .minimumScaleFactor(0.9)
                                .onTapGesture {
                                    isLeaderPresented.toggle()
                                }
                                .background(
                                    NavigationLink("", destination: GrandTestLeaderboardScreen(gTId: mockTestResponseElement.id?.description ?? "0", isFromSt: isFromSt), isActive: $isLeaderPresented).opacity(0)
                                )
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background {
                            Rectangle().fill(Color.white).cornerRadius(30)
                        }
                        .padding(.trailing)
                    }
                    
                } // BUTTONS
                //.padding(.vertical, 10)
            }
            
            
        } //: VSTACK
        .padding()
        .background(Color.cellLightGreyColor).cornerRadius(10)
        
    }
}

struct GrandTestCellView_Previews: PreviewProvider {
    static var previews: some View {
        let mocktest = MockTestResponseElement()
        GrandTestCellView(mockTestResponseElement: mocktest)
    }
}
