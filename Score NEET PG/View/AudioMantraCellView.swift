//
//  AudioMantraCellView.swift
//  Score NEET PG
//
//  Created by Rahul on 13/04/23.
//

import SwiftUI

struct AudioMantraCellView: View {
    
    var isTrial: Bool = false
    var data: AudioMantraListData
    @State var isPresentedQuestionScreen = false
    @State var isPresentedQuestionScreenFromKnown = false
    @State var isPresentedQuestionScreenFromBookmark = false
    @State private var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                if !isTrial && !paymentStatus {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 26))
                }
                Text(data.subjectName)
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 26))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.6)
            }
            
            HStack(alignment: .center) {
                VStack {
                    Text(data.remaining.description )
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.9)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.orangeColor))
                    Text("To Read")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                } //: VSTACK
                .padding(.leading)
                .onTapGesture {
                    if isTrial || paymentStatus {
                        if data.remaining > 0 {
                            isPresentedQuestionScreen = true
                        }
                    } else {
                        isPresentedPaymentScreen = true
                    }
                    
                }
                .background(
                    NavigationLink("", destination: AudioMantraDetailsScreen(isFrom: .toRead, subjectId: data.id.description), isActive: $isPresentedQuestionScreen).opacity(0)
                )
              
                
                VStack {
                    Text(data.known.description )
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.9)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.orangeColor))
                    
                    Text("I Know")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                } //: VSTACK
                .padding(.leading)
                .onTapGesture {
                    if isTrial || paymentStatus {
                        if data.known > 0 {
                            isPresentedQuestionScreenFromKnown = true
                        }
                    } else {
                        isPresentedPaymentScreen = true
                    }
                }
                .background(
                    NavigationLink("", destination: AudioMantraDetailsScreen(isFrom: .iKnow, subjectId: data.id.description), isActive: $isPresentedQuestionScreenFromKnown).opacity(0)
                )
                
                
                VStack {
                    Text(data.bookmarked.description )
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.5)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.orangeColor))
                    
                    Text("Bookmarked")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                } //: VSTACK
                .padding(.horizontal)
                .onTapGesture {
                    if isTrial || paymentStatus {
                        if data.bookmarked > 0 {
                            isPresentedQuestionScreenFromBookmark = true
                        }
                    } else {
                        isPresentedPaymentScreen = true
                    }
                }
                .background(
                    NavigationLink("", destination: AudioMantraDetailsScreen(isFrom: .bookmared, subjectId: data.id.description), isActive: $isPresentedQuestionScreenFromBookmark).opacity(0)
                )
             
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.orange, lineWidth: 1)
            
            
        }
        .background(Color.white).cornerRadius(15)
    }
}

/*
struct AudioMantraCellView_Previews: PreviewProvider {
    static var previews: some View {
        AudioMantraCellView()
    }
}
*/
