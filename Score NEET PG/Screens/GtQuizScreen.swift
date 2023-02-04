//
//  GtQuizScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import SwiftUI
import Kingfisher

struct GtQuizScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var gtQuestionVM: GtQuizViewModel = GtQuizViewModel()
    //@StateObject var nw = NetworkMonitor()
    @Environment(\.presentationMode) var presentationMode
    @State var isButtonPressed = false
    
    var gtId: String = ""
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init(gtId: String) {
        self.gtId = gtId
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                HStack {
                    Button {
                        //Action
                        
                        gtQuestionVM.updateTime {
                            gtQuestionVM.updateLastSeen() {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                    } label: {
                        if #available(iOS 16.0, *) {
                            Image(systemName: "pause")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            // Fallback on earlier versions
                            Image(systemName: "pause")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .background{
                        Circle()
                            .foregroundColor(.textColor)
                            .frame(width: 40, height: 40)
                    }
                    
                    
                    .padding(.horizontal)
                    
                    CustomProgressView(progress: .constant(1), text: gtQuestionVM.gtQuizDataModel.timeRemaining.description)
                        .frame(width: 80, height: 80)
                        .task {
                            gtQuestionVM.getTimer(gtId: gtId)
                        }
                    
                    Button {
                        //Action
                        
                        gtQuestionVM.updateLastSeen {
                            gtQuestionVM.completeQuiz {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                    } label: {
                        if #available(iOS 16.0, *) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            // Fallback on earlier versions
                            Image(systemName: "stop.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .background{
                        Circle()
                            .foregroundColor(.orangeColor)
                            .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal)
                    
                } //HSTACK HEADER
                .padding(.vertical)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        if gtQuestionVM.gtQuizDataModel.questionsIdsList.isEmpty == false {
                            HStack {
                                Text("Question: \(gtQuestionVM.gtQuizDataModel.index+1)/\(gtQuestionVM.gtQuizDataModel.questionsIdsList.count)")
                                    .foregroundColor(.textColor)
                                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                                Spacer()
                            }
                        }
                        HStack {
                            Text("Question")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                            Spacer()
                        }
                        
                        if gtQuestionVM.gtQuizDataModel.questionsIdsList.isEmpty == false {
                            VStack {
                                HStack {
                                    Text(gtQuestionVM.gtQuizDataModel.question.questionText ?? "")
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
                                
                                
                                if gtQuestionVM.gtQuizDataModel.question.image?.isEmpty == false && gtQuestionVM.gtQuizDataModel.question.image != nil && gtQuestionVM.gtQuizDataModel.question.image != "nan" {
                                    if let url = URL(string: (gtQuestionVM.gtQuizDataModel.question.image ?? "")) {
                                        HStack {
                                            Spacer()
                                            KFImage(url)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                                .padding()
                                                .onTapGesture {
                                                    gtQuestionVM.gtQuizDataModel.item = Item(image: gtQuestionVM.gtQuizDataModel.question.image ?? "")
                                                }
                                                .fullScreenCover(item: $gtQuestionVM.gtQuizDataModel.item, onDismiss: { print("Dismissed") }) {
                                                    FullScreenImageScreen(item: $0)
                                                }
                                            Spacer()
                                        }
                                    }
                                }
                                
                                
                            }
                            .task {
                                 gtQuestionVM.getQuestion()
                            }
                        }
                        
                        
                        VStack {
                            QuizOptionView(option: gtQuestionVM.gtQuizDataModel.question.optionAText ?? "", isMatched: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectA, isSelected: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectASelected) {
                               
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectASelected = true
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectA = gtQuestionVM.gtQuizDataModel.question.correctAnswer?.uppercased() == "A" ? true : false
                                    gtQuestionVM.validateUserAnswer(gtId: gtId, option: "A")
                               
                            }
                            
                            QuizOptionView(option: gtQuestionVM.gtQuizDataModel.question.optionBText ?? "", isMatched: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectB, isSelected: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectBSelected) {
                                
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectBSelected = true
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectB = gtQuestionVM.gtQuizDataModel.question.correctAnswer?.uppercased() == "B" ? true : false
                                    gtQuestionVM.validateUserAnswer(gtId: gtId, option: "B")
                                
                            }
                            
                            QuizOptionView(option: gtQuestionVM.gtQuizDataModel.question.optionCText ?? "", isMatched: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectC, isSelected: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectCSelected) {
                                
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectCSelected = true
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectC = gtQuestionVM.gtQuizDataModel.question.correctAnswer?.uppercased() == "C" ? true : false
                                    gtQuestionVM.validateUserAnswer(gtId: gtId, option: "C")
                                
                            }
                            
                            QuizOptionView(option: gtQuestionVM.gtQuizDataModel.question.optionDText ?? "", isMatched: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectD, isSelected: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectDSelected) {
                               
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectDSelected = true
                                    gtQuestionVM.gtQuizDataModel.IsOptionCorrectD = gtQuestionVM.gtQuizDataModel.question.correctAnswer?.uppercased() == "D" ? true : false
                                    gtQuestionVM.validateUserAnswer(gtId: gtId, option: "D")
                               
                                
                            }
                            
                            
                            if gtQuestionVM.gtQuizDataModel.question.optionEText != "nan" && gtQuestionVM.gtQuizDataModel.question.optionEText?.isEmpty == false && gtQuestionVM.gtQuizDataModel.question.optionEText != nil {
                                
                                QuizOptionView(option: gtQuestionVM.gtQuizDataModel.question.optionEText ?? "", isMatched: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectE, isSelected: $gtQuestionVM.gtQuizDataModel.IsOptionCorrectESelected) {
                                    
                                        gtQuestionVM.gtQuizDataModel.IsOptionCorrectESelected = true
                                        gtQuestionVM.gtQuizDataModel.IsOptionCorrectE = gtQuestionVM.gtQuizDataModel.question.correctAnswer?.uppercased() == "E" ? true : false
                                        gtQuestionVM.validateUserAnswer(gtId: gtId, option: "E")
                                    
                                }
                                
                            }
                            
                            
                        } //BUTTONS
                        
                        
                        
                        Button {
                            
                                gtQuestionVM.validateUserAnswer(gtId: gtId)
                            
                        } label: {
                            Spacer()
                            Text("Skip Question")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 16))
                                .padding(.all)
                            Spacer()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.textColor)
                        }
                        .padding(.all)
                        
                        
                        
                        //COMMENTS AUDIOS
//                        VStack {
//                            ForEach(gtQuestionVM.gtQuizDataModel.question.audio?.filter({ $0.valid == true }) ?? [AudioData](), id: \.id) { audio in
//                                RecordingPlayerViewWithoutSlider(audioData: audio) {
//                                    gtQuestionVM.deleteAudio(audioId: audio.id?.description ?? "") {
//                                        gtQuestionVM.getQuestion()
//                                    }
//                                }
//                            }
//                        }
                        
                        
                        //MARK: EXPLANATION
//                        if gtQuestionVM.gtQuizDataModel.question.explanation?.isEmpty == false && gtQuestionVM.gtQuizDataModel.question.explanation != "nan" && gtQuestionVM.gtQuizDataModel.question.explanation != nil {
//                            VStack {
//                                HStack {
//                                    Text("Explanation:")
//                                        .foregroundColor(.textColor)
//                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
//                                    Spacer()
//                                } //: HSTACK
//                                .padding(.vertical)
//
//                                Text(gtQuestionVM.gtQuizDataModel.question.explanation ?? "")
//                                    .foregroundColor(.textColor)
//                                    .font(.custom(K.Font.avenir, size: 20))
//                                    .fontWeight(.medium)
//                                    .padding(.horizontal, 10)
//                            }
//                        }
                        
                        
                        
                        Spacer()
                    } //: VSTACK
                } //: SCROLL
//                if isStaff {
//                    Spacer(minLength: 60)
//                }
                
            } //: VSTACK
            .padding(.horizontal)
            .background(Color.backgroundColor.ignoresSafeArea(.all))
            .onReceive(timer) { time in
                if gtQuestionVM.gtQuizDataModel.timeRemaining > 0 {
                    gtQuestionVM.gtQuizDataModel.timeRemaining -= 1
                } else {
                    gtQuestionVM.gtQuizDataModel.timeRemaining = 0
                    //Any other code that should happen after countdown
                    gtQuestionVM.updateLastSeen {
                        gtQuestionVM.completeQuiz {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                gtQuestionVM.progress()
            }
            .onAppear {
                gtQuestionVM.getQuestionsIds(gtId: gtId)
                gtQuestionVM.getAllQuestionDetails(id: gtId)
                gtQuestionVM.gtQuizDataModel.gtId = gtId
                
                
            }
            .onChange(of: gtQuestionVM.gtQuizDataModel.isQuizCompleted) { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
//            .overlay(
//                RecorderBar(uploadAudio: { url in
//                    gtQuestionVM.uploadAudioRecording(audio: url) {
//                        print("commented success")
//                        gtQuestionVM.getQuestion()
//                    }
//                })
//                , alignment: .bottomTrailing
//            )
            
            
            if self.gtQuestionVM.gtQuizDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            
        } //: ZSTACK
        .onDisappear(perform: {
            gtQuestionVM.updateTime {
                gtQuestionVM.updateLastSeen() {
                    print("save")
                }
            }
            
        })
        .alert(item: $gtQuestionVM.gtQuizDataModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .alert(isPresented: $gtQuestionVM.gtQuizDataModel.noDataAlertPresent) {
            Alert(title: Text(""), message: Text("No Questions Available"), dismissButton: .default(Text("Okay"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        
        
    }
}

struct GtQuizScreen_Previews: PreviewProvider {
    static var previews: some View {
        GtQuizScreen(gtId: "")
    }
}



