//
//  SYHFDetailsScreen.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI
import Kingfisher

struct SYHFDetailsScreen: View {
    // MARK: - PROPERTIES
    
    var shyfRightWrongQuestion : ShyfRightWrongQuestion?
    @State var questions: ShyfRightWrongQuestions
    @State private var questionIndex: Int = 0
    @State private var item: Item? = nil
    @State var showImageViewer = false
    @State var selectedImageID: String = ""
    
    // MARK: - BODY
    var body: some View {
        VStack {
            CustomNavigationView(name: "Answer")
                .padding(15)
            
            ScrollView(.vertical, showsIndicators: false) {
                if questions.count > 0 {
                    
                    
                    HStack {
                        
                        Text("Questions: \(questionIndex + 1)")
                            .font(.custom(K.Font.sfUITextRegular , size: 15))
                            .foregroundColor(.textColor)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        if questionIndex > 0 {
                            //Prev
                            Button(action: {
                                questionIndex -= 1
                            }) {
                                Text("Previous")
                                    .font(.custom(K.Font.sfUITextRegular , size: 15))
                                    .foregroundColor(.textColor)
                                    .lineLimit(1)
                            }
                            .padding(10)
                            .padding(.horizontal)
                            .background(Color.answerButtonColor).cornerRadius(20)
                            .padding(.horizontal)
                            
                        }
                        
                        if questionIndex < (questions.count - 1) {
                            //Next
                            Button(action: {
                                questionIndex += 1
                            }) {
                                Text("Next")
                                    .font(.custom(K.Font.sfUITextRegular , size: 15))
                                    .foregroundColor(.textColor)
                                    .padding(.horizontal, 5)
                                    .lineLimit(1)
                            }
                            .padding(10)
                            .padding(.horizontal, 5)
                            .background(Color.clear).cornerRadius(20)
                            
                        }
                        
                    } //: HSTACK
                    
                    
                    VStack {
                        Text(questions[questionIndex].questionName ?? "")
                            .font(.custom(K.Font.sfUITextBold, size: 16))
                            .foregroundColor(.textColor)
                            .padding()
                        
                        
                        if !questions[questionIndex].questionImageURL!.isEmpty && questions[questionIndex].questionImageURL != "nan" {
                            
                            var arr = questions[questionIndex].questionImageURL?.trimmingCharacters(in: .whitespaces).components(separatedBy: ",")
                            
                            if arr?.count ?? 0 > 1 {
                                HStack{
                                    Spacer()
                                        
                                    ImagesGridView(images: arr!, showImageViewer: $showImageViewer, selectedImageID: $selectedImageID)
                                        .padding()
                                }
                            } else {
                                if let url = URL(string: arr?.first ?? "") {
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .padding()
                                        .onTapGesture {
                                            item = Item(image: arr?.first ?? "")
                                        }
                                        .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
                                            FullScreenImageScreen(item: $0)
                                        }
                                }
                            }
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            withAnimation {
                questionIndex = questions.firstIndex(where: { $0.questionCode == shyfRightWrongQuestion?.questionCode })!
            }
        })
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

//struct SYHFDetailsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SYHFDetailsScreen()
//    }
//}
