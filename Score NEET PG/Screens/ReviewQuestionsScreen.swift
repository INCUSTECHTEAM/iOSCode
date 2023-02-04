//
//  ReviewQuestionsScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI
import AVKit
import Combine
import Kingfisher

struct ReviewQuestionsScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var reviewQuestionVM: ReviewQuestionsViewModel = ReviewQuestionsViewModel()
    var questionId: String = ""
    let player = AVPlayer()
    var isHideUnanswered = false
    @State var isButtonPressed = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func loadAudio(url: String) -> Player {
        guard let audioFileURL = URL(string: url) else { return Player(avPlayer: AVPlayer()) }
        let playerItem = AVPlayerItem(url: audioFileURL)
        return Player(avPlayer: AVPlayer(playerItem: playerItem))
    }
    
    
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            if reviewQuestionVM.reviewQuestionDataModel.tabs.isEmpty == false {
                VStack(alignment: .leading) {
                    
                    if reviewQuestionVM.reviewQuestionDataModel.tabs.isEmpty == false {
                        ReviewScreenTabView(tabs: reviewQuestionVM.reviewQuestionDataModel.tabs, selectedTab: $reviewQuestionVM.reviewQuestionDataModel.selectedTab)
                        
                    }
                    
                    
                    //            ReviewScreenNavView()
                    //                .padding(.vertical)
                    
                    HStack {
                        VStack(spacing: 0) {
                            Button {
                                // Action
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding(.all)
                            .background {
                                Circle()
                                    .foregroundColor(.textColor)
                            }
                            
                            Text("Back")
                                .foregroundColor(.textColor)
                                .lineLimit(1)
                                .font(.custom(K.Font.sfUITextRegular, size: 12))
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            if reviewQuestionVM.reviewFilteredData().count > 0 {
                                if reviewQuestionVM.index > 0 {
                                    VStack(spacing: 0) {
                                        Button {
                                            // Action
                                            if reviewQuestionVM.index > 0 {
                                                isButtonPressed = true
                                                reviewQuestionVM.prev()
                                                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                    isButtonPressed = false
                                                }
                                            }
                                            
                                            
                                        } label: {
                                            Image(systemName: "arrowtriangle.backward.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.all)
                                        .background {
                                            Circle()
                                                .foregroundColor(.orange)
                                        }
                                        .disabled(isButtonPressed)
                                        
                                        Text("Prev")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                    }
                                }
                                
                                Text("\(reviewQuestionVM.index+1)/\(reviewQuestionVM.reviewFilteredData().count)")
                                    .foregroundColor(.textColor)
                                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                                
                                
                                if reviewQuestionVM.reviewFilteredData().count > reviewQuestionVM.index + 1 {
                                    VStack(spacing: 0) {
                                        Button {
                                            // Action
                                            if reviewQuestionVM.index < reviewQuestionVM.reviewFilteredData().count {
                                                isButtonPressed = true
                                                
                                                reviewQuestionVM.next()
                                                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                    isButtonPressed = false
                                                }
                                                
                                            }
                                        } label: {
                                            Image(systemName: "arrowtriangle.right.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                        }
                                        .disabled(isButtonPressed)
                                        .padding(.all)
                                        .background {
                                            Circle()
                                                .foregroundColor(.orange)
                                        }
                                        Text("Next")
                                            .foregroundColor(.textColor)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                    }
                                }
                            }
                            
                            
                            
                        } //: VSTACK
                        .padding(.horizontal)
                        
                    } // TOP NAVIGATION BAR
                    .padding(.horizontal)
                    //.padding(.vertical)
                    
                    if reviewQuestionVM.reviewFilteredData().count > 0 && reviewQuestionVM.reviewFilteredData().count > reviewQuestionVM.index {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 30) {
                                
                                HStack {
                                    Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionText ?? "")
                                        .foregroundColor(.textColor)
                                        .font(.custom(K.Font.avenir, size: 22))
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                }
                                
                                if reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionImageURL?.isEmpty == false && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionImageURL != nil && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionImageURL != "nan" {
                                    if let url = URL(string: (reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionImageURL ?? "")) {
                                        HStack {
                                            Spacer()
                                            KFImage(url)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                                .padding()
                                                .onTapGesture {
                                                    reviewQuestionVM.reviewQuestionDataModel.item = Item(image: reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].questionImageURL ?? "")
                                                }
                                                .fullScreenCover(item: $reviewQuestionVM.reviewQuestionDataModel.item, onDismiss: { print("Dismissed") }) {
                                                    FullScreenImageScreen(item: $0)
                                                }
                                            Spacer()
                                        }
                                    }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Answer: \(reviewQuestionVM.reviewQuestionDataModel.tabs[reviewQuestionVM.reviewQuestionDataModel.selectedTab].title == "Wrong Answer" || reviewQuestionVM.reviewQuestionDataModel.tabs[reviewQuestionVM.reviewQuestionDataModel.selectedTab].title == "Unanswered"  ? reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() ?? "" : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() ?? "")")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextBold, size: 14))
                                    }
                                    Spacer()
                                } //: HSTACK
                                
                                
                                VStack {
                                    HStack {
                                        //Spacer()
                                        Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionA ?? "")
                                            .font(.custom(K.Font.avenir, size: 16))
                                            .fontWeight(.bold)
                                            .foregroundColor(.textColor)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() == "A" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("A") ? .answerCorrectColor : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() == "A" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("A") ? .answerWrongColor : Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        //Spacer()
                                        Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionB ?? "")
                                            .font(.custom(K.Font.avenir, size: 16))
                                            .fontWeight(.bold)
                                            .foregroundColor(.textColor)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() == "B" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("B") ? .answerCorrectColor : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() == "B" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("B") ? .answerWrongColor : Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        // Spacer()
                                        Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionC ?? "")
                                            .font(.custom(K.Font.avenir, size: 16))
                                            .fontWeight(.bold)
                                            .foregroundColor(.textColor)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() == "C" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("C") ? .answerCorrectColor : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() == "C" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("C") ? .answerWrongColor : Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        //Spacer()
                                        Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionD ?? "")
                                            .font(.custom(K.Font.avenir, size: 16))
                                            .fontWeight(.bold)
                                            .foregroundColor(.textColor)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() == "D" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("D") ? .answerCorrectColor : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() == "D" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("D") ? .answerWrongColor : Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    
                                    //OPTION E
                                    
                                    if reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionE != "nan" && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionE?.isEmpty == false && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionE != nil {
                                        HStack {
                                            //Spacer()
                                            Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].optionE ?? "")
                                                .font(.custom(K.Font.avenir, size: 16))
                                                .fontWeight(.bold)
                                                .foregroundColor(.textColor)
                                            Spacer()
                                        }
                                        .padding(10)
                                        .background(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer?.uppercased() == "E" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("E") ? .answerCorrectColor : reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].userAnswer?.uppercased() == "E" || reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].correctAnswer!.uppercased().contains("E")  ? .answerWrongColor : Color.gray.opacity(0.15))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    }
                                    
                                    
                                    
                                } //BUTTONS
                                
                                if reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?.isEmpty == false {
                                    VStack {
                                        ForEach((reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?.indices)!, id: \.self) { index in
                                            //                                                                                RecordingPlayerView(player: loadAudio(url: reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?[index].audio ?? ""))
                                            
                                            
                                            //                                        let playerItem = AVPlayerItem(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3")!)
                                            //
                                            //                                        RecordingPlayerView(player: Player(avPlayer: AVPlayer(playerItem: playerItem)))
                                            
                                            if reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?[index].valid == true {
                                                RecordingPlayerViewWithoutSlider(audioData: (reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?[index])!) {
                                                    //Action
                                                    reviewQuestionVM.deleteAudio(audioId: reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].audio?[index].id?.description ?? "") {
                                                        reviewQuestionVM.getUserGTDetail(id: questionId)
                                                    }
                                                }
                                            }
                                            
                                            
                                            
                                        }
                                    }
                                }
                                
                                
                                
                                if reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].explanation != "" && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].explanation != nil && reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].explanation != "nan" {
                                    VStack {
                                        HStack {
                                            Text("Explanation:")
                                                .foregroundColor(.textColor)
                                                .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            Spacer()
                                        } //: HSTACK
                                        .padding(.vertical)
                                        
                                        Text(reviewQuestionVM.reviewFilteredData()[reviewQuestionVM.index].explanation ?? "")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.avenir, size: 20))
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 10)
                                        
                                    } //EXPLANATION VSTACK
                                }
                                
                            } //: VSTACK
                        } //: SCROLL
                        .padding()
                    }
                    
                    if isStaff {
                        Spacer(minLength: 60)
                    }
                    Spacer()
                } //: VSTACK
                .overlay(
                    RecorderBar(uploadAudio: { url in
                        reviewQuestionVM.uploadAudioRecording(questionId: reviewQuestionVM.reviewQuestionDataModel.questionDetail.id?.description ?? "", audio: url) {
                            print("commented success")
                            //gtQuestionVM.getQuestion()
                            reviewQuestionVM.getUserGTDetail(id: questionId)
                        }
                    })
                    , alignment: .bottomTrailing
                )
            }
            
            if self.reviewQuestionVM.reviewQuestionDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .background(Color.backgroundColor.ignoresSafeArea())
        .blur(radius: reviewQuestionVM.reviewQuestionDataModel.noDataAlertPresent ? 20 : 0)
        .onAppear {
            reviewQuestionVM.reviewQuestionDataModel.isHideUnanswered = isHideUnanswered
            reviewQuestionVM.reviewQuestionDataModel.questionId = questionId
            reviewQuestionVM.getUserGTDetail(id: questionId)
            
        }
        .alert(isPresented: $reviewQuestionVM.reviewQuestionDataModel.noDataAlertPresent) {
            Alert(title: Text(""), message: Text("No Questions Available"), dismissButton: .default(Text("Okay"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct ReviewQuestionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReviewQuestionsScreen()
    }
}


struct ReviewScreenTabView: View {
    
    var tabs: [TopTab]
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { row in
                HStack(spacing: 0) {
                    Button {
                        selectedTab = row
                    } label: {
                        VStack(spacing: 10) {
                            Text(tabs[row].title)
                                .font(.custom(K.Font.sfUITextBold, size: 13))
                                .foregroundColor(selectedTab == row ? .orangeColor : .textColor)
                                .lineLimit(1)
                            
                            
                            HStack {
                                Spacer()
                                Rectangle().fill(selectedTab == row ? Color.orangeColor : Color.clear)
                                    .frame(width: 80, height: 2)
                                Spacer()
                            }
                        }
                        .frame(height: 52)
                    }
                    
                }
            }
        }
    }
}

struct ReviewScreenNavView: View {
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    // Action
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
                
                Text("Back")
                    .foregroundColor(.textColor)
                    .lineLimit(1)
                    .font(.custom(K.Font.sfUITextRegular, size: 12))
            }
            
            Spacer()
            
            HStack {
                VStack {
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "arrowtriangle.backward.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.all)
                    .background {
                        Circle()
                            .foregroundColor(.orange)
                    }
                    
                    Text("Prev")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                }
                
                VStack {
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.all)
                    .background {
                        Circle()
                            .foregroundColor(.orange)
                    }
                    Text("Next")
                        .foregroundColor(.textColor)
                        .lineLimit(1)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                }
                
            } //: VSTACK
            .padding(.horizontal)
            
        } // TOP NAVIGATION BAR
        .padding(.horizontal)
    }
}
