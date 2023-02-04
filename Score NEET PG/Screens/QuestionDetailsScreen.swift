//
//  QuestionDetailsScreen.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI
import Kingfisher

struct QuestionDetailsScreen: View {
    
    // MARK: - PROPERTIES
    
    @State var rightWrongQuestion: RightWrongQuestion?
    @State private var item: Item? = nil
    @State private var questionIndex: Int = 0
    @State var questions: [RightWrongQuestion]
    
    // MARK: - BODY
    var body: some View {
        VStack {
            CustomNavigationView(name: "Answer")
            
            
            ScrollView(.vertical, showsIndicators: false) {
                if questions.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        
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
                                .padding(0)
                                .padding(.horizontal, 5)
                                .background(Color.clear).cornerRadius(20)
                                
                            }
                            
                        }
                        
                        Text(questions[questionIndex].questionName ?? "")
                            .font(.custom(K.Font.sfUITextRegular, size: 16))
                            .foregroundColor(.textColor)
                            .padding()
                        
                        if ((questions[questionIndex].questionImageURL) != nil) && questions[questionIndex].questionImageURL != "nan" {
                            if let url = URL(string: (questions[questionIndex].questionImageURL)!) {
                                HStack {
                                    Spacer()
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200, alignment: .center)
                                        .padding()
                                        .onTapGesture {
                                            item = Item(image: (questions[questionIndex].questionImageURL)!)
                                        }
                                        .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
                                            FullScreenImageScreen(item: $0)
                                        }
                                    Spacer()
                                }
                               
                            }
                        }
                        
                        Text("Answer: \(questions[questionIndex].userAnswer ?? "")")
                            .font(.custom(K.Font.sfUITextRegular, size: 16))
                            .foregroundColor(.textColor)
                            .padding()
                        
                      
                        VStack {
                            HStack {
                                Spacer()
                                Text(questions[questionIndex].optionA ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(questions[questionIndex].answer == questions[questionIndex].optionA ? .answerButtonColor : questions[questionIndex].userAnswer == "A" ? Color.red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(questions[questionIndex].optionB ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(questions[questionIndex].answer == questions[questionIndex].optionB ? .answerButtonColor : questions[questionIndex].userAnswer == "B" ? Color.red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(questions[questionIndex].optionC ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(questions[questionIndex].answer == questions[questionIndex].optionC ? .answerButtonColor : questions[questionIndex].userAnswer == "C" ? Color.red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(questions[questionIndex].optionD ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(questions[questionIndex].answer == questions[questionIndex].optionD ? .answerButtonColor : questions[questionIndex].userAnswer == "D" ? Color.red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        if questions[questionIndex].explanation != "nan" {
                            Text("Explanation")
                                .font(.custom(K.Font.sfUITextRegular, size: 16))
                                .foregroundColor(.textColor)
                                .padding(10)
                            HStack {
                                Spacer()
                                Text(questions[questionIndex].explanation ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                    } //: VSTACK
                }
            } //: SCROLL
        } //: VSTACK
        .padding()
        .onAppear(perform: {
            withAnimation {
                questionIndex = questions.firstIndex(where: { $0.questionCode == rightWrongQuestion?.questionCode })!
            }
        })
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

//// MARK: - PREVIEW
//struct QuestionDetailsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionDetailsScreen()
//    }
//}
