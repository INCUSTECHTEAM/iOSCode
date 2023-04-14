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
    @State var showIknowButtons = false
    let courseSelection = CourseEnvironment.shared
    
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
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        if noteQuestionsVM.noteQuestionDataModel.knownQuestions.isEmpty == false || noteQuestionsVM.noteQuestionDataModel.bookmarkedQuestions.isEmpty == false {
                            noteQuestionsVM.updateDataToServer(subjectId: subjectId, completion: {
                                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            })
                        } else {
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
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
                    
                    
                    
                    Text("\(noteQuestionsVM.noteQuestionDataModel.index + 1)/\(noteQuestionsVM.noteQuestionDataModel.questionIds.count)")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                    
                    
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
                
                
                if courseSelection.checkSelectedCourse() == Courses.USMLESTEP1.rawValue || courseSelection.checkSelectedCourse() == Courses.USMLESTEP2.rawValue { 
                    bottomButtons()
                } else {
                    bottomButtonsForNeet()
                        .padding()
                }
                
                
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
                
                NotesQuizScreen(questions: questions) { isBookmarked in
                    self.noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: isBookmarked)
                } saveQuiz: {
                    self.noteQuestionsVM.updateDataToServer(subjectId: subjectId, completion: {
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
                
                
            }
        }
        
    }
    
    
    @ViewBuilder
    func bottomButtonsForNeet() -> some View {
        HStack(spacing: 20) {
            Button {
                if noteQuestionsVM.noteQuestionDataModel.question.questions?.isEmpty == false {
                    isPresentNoteQuiz = true
                    return
                }
                
                noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: false)
            } label: {
                Text("Next")
                    .font(.custom(K.Font.avenir, size: 16))
                    .fontWeight(.medium)
                    .frame(width: UIScreen.main.bounds.size.width / 2.7)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .foregroundColor(.orangeColor)
                    }
            }
            
            Spacer()
            
        } //: MIDDLE
    }
    
    
    @ViewBuilder
    func bottomButtons() -> some View {
        HStack {
            if isFrom != .bookmared {
                Button {
                    noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: true)
                } label: {
                    Text("Bookmark")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 2.7)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                                .foregroundColor(.orangeColor)
                        }
                }
                
            }
            
            Spacer()
            
            if isFrom != .iKnow {
                Button {
                    noteQuestionsVM.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: false)
                } label: {
                    Text("I Know")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 2.7)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                                .foregroundColor(.orangeColor)
                        }
                }
            }
        }
        .padding()
    }
    
}

struct NotesQuestionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotesQuestionsScreen(subjectId: "", isFrom: .iKnow)
    }
}
