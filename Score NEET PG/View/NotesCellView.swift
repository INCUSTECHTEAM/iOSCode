//
//  NotesCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct NotesCellView: View {
    //MARK: - PROPERTIES
    
    var note: NotesData
    @State var isPresentedNotesQuestionScreen = false
    @State var isPresentedNotesQuestionScreenFromKnown = false
    @State var isPresentedNotesQuestionScreenFromBookmark = false
    @State var isFrom: questionIsFrom = .toRead
    @State private var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    var isTrial: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                
                if paymentStatus == false && !isTrial {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 26))
                }
                
                Text(note.subjectName ?? "Test")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 26))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.6)
            }
            
            HStack(alignment: .center) {
                VStack {
                    Text(note.remaining?.description ?? "")
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.9)
                        .frame(width: 60, height: 60)
                        .background {
                            Circle().fill(Color.orangeColor)
                        }
                    
                    Text("To Read")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                } //: VSTACK
                .padding(.leading)
                .onTapGesture {
                    if paymentStatus == true || isTrial {
                        if note.remaining ?? 0 > 0 {
                            isFrom = .toRead
                            isPresentedNotesQuestionScreen = true
                        }
                    } else {
                        print("payment needed")
                        isPresentedPaymentScreen = true
                    }
                    
                }
                .background(
                    NavigationLink("", destination: NotesQuestionsScreen(subjectId: note.id?.description ?? "", isFrom: .toRead), isActive: $isPresentedNotesQuestionScreen).opacity(0)
                )
                
                VStack {
                    Text(note.known?.description ?? "")
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.9)
                        .frame(width: 60, height: 60)
                        .background {
                            Circle().fill(Color.orangeColor)
                        }
                    
                    Text("I Know")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                } //: VSTACK
                .padding(.leading)
                .onTapGesture {
                    if paymentStatus == true || isTrial {
                        if note.known ?? 0 > 0 {
                            isFrom = .iKnow
                            isPresentedNotesQuestionScreenFromKnown = true
                        }
                    } else {
                        print("Payment Needed")
                        isPresentedPaymentScreen = true
                    }
                }
                .background(
                    NavigationLink("", destination: NotesQuestionsScreen(subjectId: note.id?.description ?? "", isFrom: .iKnow), isActive: $isPresentedNotesQuestionScreenFromKnown).opacity(0)
                )
                
                VStack {
                    Text(note.bookmarked?.description ?? "")
                        .foregroundColor(.white)
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .minimumScaleFactor(0.5)
                        .frame(width: 60, height: 60)
                        .background {
                            Circle().fill(Color.orangeColor)
                        }
                    
                    Text("Bookmarked")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 13))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                } //: VSTACK
                .padding(.horizontal)
                .onTapGesture {
                    if paymentStatus == true || isTrial {
                        if note.bookmarked ?? 0 > 0 {
                            isFrom = .bookmared
                            isPresentedNotesQuestionScreenFromBookmark = true
                        }
                    } else {
                        print("payment needed")
                        isPresentedPaymentScreen = true
                    }
                }
                .background(
                    NavigationLink("", destination: NotesQuestionsScreen(subjectId: note.id?.description ?? "", isFrom: .bookmared), isActive: $isPresentedNotesQuestionScreenFromBookmark).opacity(0)
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
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
    }
}

struct NotesCellView_Previews: PreviewProvider {
    static var previews: some View {
        NotesCellView(note: NotesData())
            .background(Color.backgroundColor).cornerRadius(10)
    }
}
