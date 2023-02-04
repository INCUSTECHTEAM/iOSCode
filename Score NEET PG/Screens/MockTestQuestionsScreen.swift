//
//  MockTestQuestionsScreen.swift
//  Score MLE
//
//  Created by Manoj kumar on 03/08/22.
//

import SwiftUI
import Kingfisher

struct MockTestQuestionsScreen: View {
    // MARK: - PROPERTIES
    
    @State private var mockQuestion: MockQuestion = MockQuestion()
    @State private var questionIndex: Int = 0
    @State private var item: Item? = nil
    @State private var isLoading: Bool = false
    var mockTestId: String
    
    
    //MARK: - FUNCTIONS
    
    private func getQuestions(mockTestID: String) {
        isLoading = true
        NetworkManager.shared.getMockQuestions(mockTestID: mockTestID) { result in
            isLoading = false
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.mockQuestion = data
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            CustomNavigationView(name: "Answer")
            
            ScrollView(.vertical, showsIndicators: false) {
                if mockQuestion.count > 0 {
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
                            
                            if questionIndex < (mockQuestion.count - 1) {
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
                            
                        }
                        
                        Text(mockQuestion[questionIndex].questionText ?? "")
                            .font(.custom(K.Font.sfUITextRegular, size: 16))
                            .foregroundColor(.textColor)
                            .padding()
                        
                        if ((mockQuestion[questionIndex].questionImageURL) != nil) && mockQuestion[questionIndex].questionImageURL != "nan" {
                            if let url = URL(string: (mockQuestion[questionIndex].questionImageURL)!) {
                                HStack {
                                    Spacer()
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .padding()
                                        .onTapGesture {
                                            item = Item(image: (mockQuestion[questionIndex].questionImageURL)!)
                                        }
                                        .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
                                            FullScreenImageScreen(item: $0)
                                        }
                                    Spacer()
                                }
                            }
                        }
                        
                        Text("Answer: \(mockQuestion[questionIndex].userAnswer ?? "")")
                            .font(.custom(K.Font.sfUITextRegular, size: 16))
                            .foregroundColor(.textColor)
                            .padding()
                        
                        
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text(mockQuestion[questionIndex].optionA ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(mockQuestion[questionIndex].correctAnswer == "A" ? .answerButtonColor : mockQuestion[questionIndex].userAnswer == "A" ? .red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(mockQuestion[questionIndex].optionB ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(mockQuestion[questionIndex].correctAnswer == "B" ? .answerButtonColor : mockQuestion[questionIndex].userAnswer == "B" ? .red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(mockQuestion[questionIndex].optionC ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(mockQuestion[questionIndex].correctAnswer == "C" ? .answerButtonColor : mockQuestion[questionIndex].userAnswer == "C" ? .red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Text(mockQuestion[questionIndex].optionD ?? "")
                                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                                    .foregroundColor(.textColor)
                                Spacer()
                            }
                            .padding(10)
                            .background(mockQuestion[questionIndex].correctAnswer == "D" ? .answerButtonColor : mockQuestion[questionIndex].userAnswer == "D" ? .red : Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        if mockQuestion[questionIndex].explanation != "nan" {
                            Text("Explanation")
                                .font(.custom(K.Font.sfUITextRegular, size: 16))
                                .foregroundColor(.textColor)
                                .padding(10)
                            HStack {
                                Spacer()
                                Text(mockQuestion[questionIndex].explanation ?? "")
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
        .onAppear(perform: {
            getQuestions(mockTestID: mockTestId)
        })
        .padding()
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

struct MockTestQuestionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MockTestQuestionsScreen(mockTestId: "3")
    }
}
