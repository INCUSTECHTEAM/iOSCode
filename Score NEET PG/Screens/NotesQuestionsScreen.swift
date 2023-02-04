//
//  NotesQuestionsScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct NotesQuestionsScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var noteQuestionsVM: NoteQuestiosnViewModel = NoteQuestiosnViewModel()
    var subjectId: String = ""
    @Environment(\.presentationMode) var presentationMode
    var isFrom: questionIsFrom
    @State var isButtonPressed = false
    @State var isPresentNoteQuiz = false
    
    init(subjectId: String, isFrom: questionIsFrom) {
        self.subjectId = subjectId
        self.isFrom = isFrom
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {if noteQuestionsVM.noteQuestionDataModel.knownQuestions.isEmpty == false || noteQuestionsVM.noteQuestionDataModel.bookmarkedQuestions.isEmpty == false {
                        noteQuestionsVM.updateDataToServer(subjectId: subjectId) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        presentationMode.wrappedValue.dismiss()
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
                    
                    Text("Notes")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 20))
                        .padding(.horizontal)
                    
                    Spacer()
                    
//                    if noteQuestionsVM.noteQuestionDataModel.questionIds.count > 0 {
//                        if noteQuestionsVM.noteQuestionDataModel.index > 0 {
//                            VStack {
//                                Button {
//                                    // Action
//                                    isButtonPressed = true
//                                    noteQuestionsVM.prev(subjectId: subjectId)
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//                                        isButtonPressed = false
//                                    }
//                                    
//                                } label: {
//                                    Image(systemName: "arrowtriangle.backward.fill")
//                                        .font(.title2)
//                                        .foregroundColor(.white)
//                                }
//                                .padding(.all, 10)
//                                .background {
//                                    Circle()
//                                        .foregroundColor(.orange)
//                                }
//                                .disabled(isButtonPressed)
//                                
//                                Text("Prev")
//                                    .foregroundColor(.textColor)
//                                    .font(.custom(K.Font.sfUITextRegular, size: 12))
//                            } //: VSTACK
//                            .padding(.horizontal)
//                        }
                        
                        Text("\(noteQuestionsVM.noteQuestionDataModel.index + 1)/\(noteQuestionsVM.noteQuestionDataModel.questionIds.count)")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                        
//                        if noteQuestionsVM.noteQuestionDataModel.isFrom != .toRead {
//                            if noteQuestionsVM.noteQuestionDataModel.questionIds.count > noteQuestionsVM.noteQuestionDataModel.index + 1 {
//                                VStack {
//                                    Button {
//                                        // Action
//                                        isButtonPressed = true
//
//                                        noteQuestionsVM.next(subjectId: subjectId)
//
//                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//                                            isButtonPressed = false
//                                        }
//
//                                    } label: {
//                                        Image(systemName: "arrowtriangle.right.fill")
//                                            .font(.title2)
//                                            .foregroundColor(.white)
//                                    }
//                                    .padding(.all, 10)
//                                    .background {
//                                        Circle()
//                                            .foregroundColor(.orange)
//                                    }
//                                    .disabled(isButtonPressed)
//
//                                    Text("Next")
//                                        .foregroundColor(.textColor)
//                                        .font(.custom(K.Font.sfUITextRegular, size: 12))
//                                } //: VSTACK
//                                .padding(.trailing)
//                            }
//                        }
//                    }
                    
                    
                } // TOP NAVIGATION BAR
                .padding(.horizontal)
                
                
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        Text(.init(noteQuestionsVM.noteQuestionDataModel.question.fact ?? ""))
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.avenir, size: 22))
                            .padding(.all)
                            .task {
                                noteQuestionsVM.noteQuestionDataModel.isFrom = isFrom
                                noteQuestionsVM.getSubjectQuestions(subjectId: subjectId)
                            }
                    } //: VSTACK
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(isFrom == .toRead ? .orangeColor : .textColor)
                    })
                    .background {
                        if noteQuestionsVM.noteQuestionDataModel.bookmarkedQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) {
                            Color.bookmarkColor
                        } else if noteQuestionsVM.noteQuestionDataModel.knownQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) {
                            Color.knowColor
                        } else {
                            Color.clear
                        }
                        
                    }
                    .padding(.all)
                    
                    
                    VStack {
                        ForEach(noteQuestionsVM.noteQuestionDataModel.question.audio?.filter({ $0.valid == true }) ?? [], id: \.id) { audio in
                            RecordingPlayerViewWithoutSlider(audioData: audio) {
                                noteQuestionsVM.deleteAudio(request: DeleteAudioRequest(), audioId: audio.id?.description ?? "") {
                                    noteQuestionsVM.getQuestion(subjectId: subjectId)
                                }
                            }
                        }
                    }
                    
                } //: SCROLL
                .padding(.all)
                
                
                HStack(spacing: 20) {
                    
                    Button("Next") {
                        if noteQuestionsVM.noteQuestionDataModel.question.questions?.isEmpty == false {
                            isPresentNoteQuiz = true
                            return
                        }
                        
                        noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: false)
                        
                    }
                    .frame(width: UIScreen.main.bounds.size.width / 2.7)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .foregroundColor(.orangeColor)
                    }
                    
                    Spacer()
                    
                    //                    if noteQuestionsVM.noteQuestionDataModel.isFrom == .bookmared || noteQuestionsVM.noteQuestionDataModel.isFrom == .toRead {
                    //
                    //                        if noteQuestionsVM.noteQuestionDataModel.isFrom == .bookmared {
                    //                            Spacer()
                    //                        }
                    //
                    //                        Button {
                    //                            // Action
                    //                            noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: false)
                    //                        } label: {
                    //                            Text("I Know")
                    //                                .foregroundColor(noteQuestionsVM.noteQuestionDataModel.knownQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) ? .white : .orangeColor)
                    //                                .font(.custom(K.Font.avenir, size: 16))
                    //                                .fontWeight(.medium)
                    //                                .padding(.all)
                    //                        }
                    //                        .frame(maxWidth: UIScreen.main.bounds.width / 2.5)
                    //                        .overlay {
                    //                            RoundedRectangle(cornerRadius: 8)
                    //                                .stroke(lineWidth: 1)
                    //                                .foregroundColor(.orangeColor)
                    //                        }
                    //                        .background {
                    //                            if  noteQuestionsVM.noteQuestionDataModel.knownQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) {
                    //                                Color.orangeColor.cornerRadius(8, corners: .allCorners)
                    //                            } else {
                    //                                Color.clear
                    //                            }
                    //
                    //                        }
                    //                    }
                    //
                    //
                    //                    if noteQuestionsVM.noteQuestionDataModel.isFrom == .iKnow || noteQuestionsVM.noteQuestionDataModel.isFrom == .toRead {
                    //
                    //                        Button {
                    //                            // Action
                    //                            noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: true)
                    //                        } label: {
                    //                            Text("Bookmark")
                    //                                .foregroundColor(noteQuestionsVM.noteQuestionDataModel.bookmarkedQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) ? .white : .orangeColor)
                    //                                .font(.custom(K.Font.avenir, size: 16))
                    //                                .fontWeight(.medium)
                    //                                .padding(.all)
                    //
                    //                        }
                    //                        .frame(maxWidth: UIScreen.main.bounds.width / 2.5)
                    //                        .overlay {
                    //                            RoundedRectangle(cornerRadius: 8)
                    //                                .stroke(lineWidth: 1)
                    //                                .foregroundColor(.orangeColor)
                    //                        }
                    //                        .background {
                    //                            if noteQuestionsVM.noteQuestionDataModel.bookmarkedQuestions.contains(where: { $0.id == noteQuestionsVM.noteQuestionDataModel.questionIds[noteQuestionsVM.noteQuestionDataModel.index].id }) {
                    //                                Color.orangeColor.cornerRadius(8, corners: .allCorners)
                    //                            } else {
                    //                                Color.clear
                    //                            }
                    //
                    //                        }
                    //
                    //                        if noteQuestionsVM.noteQuestionDataModel.isFrom == .iKnow {
                    //                            Spacer()
                    //                        }
                    //
                    //                    }
                    
                } //: MIDDLE
                .padding(.all)
                
                if isStaff {
                    Spacer(minLength: 60)
                }
                
                Spacer()
            } //: VSTACK
            .background(Color.backgroundColor.ignoresSafeArea())
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .overlay(
                RecorderBar(uploadAudio: { url in
                    noteQuestionsVM.uploadAudioRecording(audio: url) {
                        print("commented success")
                        //gtQuestionVM.getQuestion()
                        noteQuestionsVM.getQuestion(subjectId: subjectId)
                    }
                })
                , alignment: .bottomTrailing
            )
            
            
            if self.noteQuestionsVM.noteQuestionDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                //.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .alert(isPresented: $noteQuestionsVM.noteQuestionDataModel.noDataAlertPresent) {
            Alert(title: Text(""), message: Text("No Questions Available"), dismissButton: .default(Text("Okay"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }.onChange(of: noteQuestionsVM.noteQuestionDataModel.isBack) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onDisappear {
            noteQuestionsVM.noteQuestionDataModel.index = 0
        }
        .fullScreenCover(isPresented: $isPresentNoteQuiz) {
            if let questions = noteQuestionsVM.noteQuestionDataModel.question.questions {
                NotesQuizScreen(questions: questions) { isBookmark in
                    //Call I know or Bookmark
                    noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: isBookmark)
                }
            }
        }
        
    }
}

struct NotesQuestionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotesQuestionsScreen(subjectId: "", isFrom: .iKnow)
    }
}
