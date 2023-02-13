//
//  NotesQuizScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/02/23.
//

import SwiftUI
import Kingfisher

struct NotesQuizScreen: View {
    //MARK: PROPERTIES
    
    let questions: [QuestionDetail]
    @ObservedObject private var vm: NotesQuizViewModel
    
    @State private var showReportAlert = false
    
    var noteQuestionBookmarkStatus: (_ isBookmarked: Bool) -> Void
    var saveQuiz: () -> Void
    
   
    
    init(questions: [QuestionDetail], noteQuestionBookmarkStatus: @escaping (_ isBookmarked: Bool) -> Void, saveQuiz: @escaping () -> Void) {
        self.questions = questions
        self.vm = NotesQuizViewModel(questions: self.questions)
        self.noteQuestionBookmarkStatus = noteQuestionBookmarkStatus
        self.saveQuiz = saveQuiz
        
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    @Environment(\.dismiss) private var dismiss
    
    //MARK: BODY
    var body: some View {
        VStack {
            
            NavBar()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    HStack {
                        Text("Question")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                        Spacer()
                    } //HSTACK
                    
                    QuestionView()
                    
                    ButtonsView()
                    
                    if vm.isQuestionAttempt {
                        ExplationView()
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.lightBlue)
                            }
                    }
                    
                    
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .alert(isPresented: $showReportAlert, content: {
            Alert(title: Text("Are You Sure"), message: Text("Do you really want to report this Question?"), primaryButton: .default(Text("Report"), action: {
                vm.reportQuestion()
            }), secondaryButton: .cancel(Text("Dismiss")){
                // Handle Cancel button action
            })
        })
        .onChange(of: vm.goBack, perform: { newValue in
            dismiss()
            noteQuestionBookmarkStatus(vm.setNoteBookmarkedStatus())
        })
        .onChange(of: vm.userAnswer, perform: { newValue in
            if let _ = newValue {
                vm.isQuestionAttempt = true
            }
        })
        .background(Color.backgroundColor.ignoresSafeArea(.all))
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        HStack {
            Button {
                if vm.isQuestionAttempt {
                    noteQuestionBookmarkStatus(vm.setNoteBookmarkedStatus())
                    dismiss()
                    saveQuiz()
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.all)
            .background {
                Circle()
                    .foregroundColor(.textColor)
            }
            
            Text("Question")
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextBold, size: 20))
                .padding(.leading)
            
            Spacer()
            
            
//            VStack {
//                Button {
//                    vm.prevQuestion()
//                } label: {
//                    Image(systemName: "arrowtriangle.backward.fill")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                }
//                .padding(.all, 10)
//                .background {
//                    Circle()
//                        .foregroundColor(.orange)
//                }
//
//
//                Text("Prev")
//                    .foregroundColor(.textColor)
//                    .font(.custom(K.Font.sfUITextRegular, size: 12))
//            } //: VSTACK
//            .padding(.leading)
//            .hidden()
            
            
            Button {
                showReportAlert.toggle()
            } label: {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.textColor)
                        .frame(width: 25, height: 25)
                    
                    Text("Report")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                }
            }
            .padding(.trailing, 10)

            
            
            VStack {
                Button {
                    vm.nextQuestion()
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.all, 10)
                .background {
                    Circle()
                        .foregroundColor(.orange)
                }
                .disabled(!vm.isQuestionAttempt)
                
                Text("Next")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 12))
            } //: VSTACK
            .padding(.trailing)
            
        } // TOP NAVIGATION BAR
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func QuestionView() -> some View {
        VStack {
            HStack {
                Text(vm.currentQuestion?.questionText ?? "")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 22))
                    .fontWeight(.medium)
                    .padding()
                
                Spacer()
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            
            
            if let image = vm.currentQuestion?.image {
                HStack {
                    Spacer()
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                        .onTapGesture {
                            //Show Image
                        }
                    //                        .fullScreenCover(item: $gtQuestionVM.gtQuizDataModel.item, onDismiss: { print("Dismissed") }) {
                    //                        FullScreenImageScreen(item: $0)
                    //                        }
                    Spacer()
                }
            }
            
            if vm.isQuestionAttempt {
                HStack {
                    Text("Answer: \(vm.currentQuestion?.correctAnswer ?? "")")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.avenir, size: 18))
                        .fontWeight(.medium)
                    Spacer()
                }
                .animation(.easeInOut, value: vm.isQuestionAttempt)
            }
            
            
        }
        
        
    } //: Question View
    
    @ViewBuilder
    func ButtonsView() -> some View {
        VStack {
            if let optionA = vm.currentQuestion?.optionAText, let correctAnswer = vm.currentQuestion?.correctAnswer {
                AnswerButton(option: optionA,
                             isCorrect: vm.checkAnswer(), correctAnswer: correctAnswer,
                             selectedAnswer: $vm.userAnswer,
                             onClick: {
                    vm.userAnswer = optionA
                    vm.attemptAnswers()
                    vm.updateBlockStatus()
                })
            }
            
            if let optionB = vm.currentQuestion?.optionBText, let correctAnswer = vm.currentQuestion?.correctAnswer {
                AnswerButton(option: optionB,
                             isCorrect: vm.checkAnswer(), correctAnswer: correctAnswer,
                             selectedAnswer: $vm.userAnswer,
                             onClick: {
                    vm.userAnswer = optionB
                    vm.attemptAnswers()
                    vm.updateBlockStatus()
                })
            }
            
            if let optionC = vm.currentQuestion?.optionCText, let correctAnswer = vm.currentQuestion?.correctAnswer {
                AnswerButton(option: optionC,
                             isCorrect: vm.checkAnswer(), correctAnswer: correctAnswer,
                             selectedAnswer: $vm.userAnswer,
                             onClick: {
                    vm.userAnswer = optionC
                    vm.attemptAnswers()
                    vm.updateBlockStatus()
                })
            }
            
            if let optionD = vm.currentQuestion?.optionDText, let correctAnswer = vm.currentQuestion?.correctAnswer {
                AnswerButton(option: optionD,
                             isCorrect: vm.checkAnswer(), correctAnswer: correctAnswer,
                             selectedAnswer: $vm.userAnswer,
                             onClick: {
                    vm.userAnswer = optionD
                    vm.attemptAnswers()
                    vm.updateBlockStatus()
                })
            }
            
            if let optionE = vm.currentQuestion?.optionEText, let correctAnswer = vm.currentQuestion?.correctAnswer {
                AnswerButton(option: optionE,
                             isCorrect: vm.checkAnswer(), correctAnswer: correctAnswer,
                             selectedAnswer: $vm.userAnswer,
                             onClick: {
                    vm.userAnswer = optionE
                    vm.attemptAnswers()
                    vm.updateBlockStatus()
                })
            }
            
        }
    }
    
    @ViewBuilder
    func ExplationView() -> some View {
        if let explation = vm.currentQuestion?.explanation {
            VStack {
                HStack {
                    Text("Explanation:")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                    Spacer()
                } //: HSTACK
                .padding(.vertical)
                
                Text(explation)
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct NotesQuizScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotesQuizScreen(questions: [], noteQuestionBookmarkStatus: { isBookmarked in }, saveQuiz: {})
    }
}



struct AnswerButton: View {
    let option: String
    let isCorrect: Bool
    let correctAnswer: String
    @Binding var selectedAnswer: String?
    let onClick: () -> Void
    
    var body: some View {
        
        VStack {
            Button {
                onClick()
            } label: {
               // Spacer()
                Text(option)
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 16))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                    
                Spacer()
            }
            .disabled(selectedAnswer != nil)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(isCorrect && selectedAnswer == option || selectedAnswer != nil && option == correctAnswer ? Color.answerCorrectColor : selectedAnswer == option ? Color.answerWrongColor : Color.gray.opacity(0.15))
                    
            }
        } //: VSTACK
    }
}
