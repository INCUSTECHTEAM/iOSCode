//
//  AudioMantraDetailsScreen.swift
//  Score NEET PG
//
//  Created by Rahul on 13/04/23.
//

import SwiftUI

struct AudioMantraDetailsScreen: View {
    
    //MARK: Properties
    
    var isFrom: questionIsFrom
    var subjectId: String
    
    init(isFrom: questionIsFrom, subjectId: String) {
        self.isFrom = isFrom
        self.subjectId = subjectId
    }
    
    @StateObject private var vm = AudioMantraDetailsViewModel()
    @Environment(\.dismiss) var dismiss
    
    
    //MARK: Body
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    if vm.knownQuestions.isEmpty == false || vm.bookmarkedQuestions.isEmpty == false {
                        
                        vm.updateDataToServer(subjectId: subjectId, completion: {
                            DispatchQueue.main.async {
                                self.dismiss()
                            }
                        })
                        
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss()
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
                
                Text("Audio Mantras")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextBold, size: 20))
                    .padding(.horizontal)
                
                Spacer()
                
                
                
                Text("\(vm.index + 1)/\(vm.questionIds.count)")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                
                
            } // TOP NAVIGATION BAR
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                HStack(spacing: 30) {
                    HStack {
                        Button {
                            if vm.isPlaying {
                                vm.pause()
                            } else {
                                vm.play()
                            }
                        } label: {
                            Image(systemName: vm.isPlaying ? "pause" : "play")
                                .font(.title2)
                                .padding(10)
                            
                        }
                        .padding(.vertical)
    

                        Text(vm.duration)
                            .foregroundColor(.white)
                            .font(.custom(K.Font.sFUITextLight, size: 15))
                            
                            .padding(.trailing)
                        
                    }
                    .frame(height: 50)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.gradient1, .gradient2]), startPoint: .top, endPoint: .bottom)
                            .cornerRadius(8, corners: .allCorners)
                    )
                    
                    
                    
                    Button {
                        vm.skip(subjectId: subjectId)
                    } label: {
                        Text("Skip")
                            .font(.custom(K.Font.sFUITextLight, size: 15))
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).foregroundColor(.orangeColor))
                    

                    
                }
                .padding()
                
                
                VStack {
                    Text(.init(vm.question.fact ?? ""))
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.avenir, size: 22))
                        .padding(.all)
                        
                } //: VSTACK
                .task {
                    vm.isFrom = isFrom
                    vm.getSubjectQuestions(subjectId: subjectId)
                }
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(isFrom == .toRead ? .orangeColor : .textColor)
                })
                .background {
                    if vm.bookmarkedQuestions.contains(where: { $0.id == vm.questionIds[vm.index].id }) {
                        Color.bookmarkColor
                    } else if vm.knownQuestions.contains(where: { $0.id == vm.questionIds[vm.index].id }) {
                        Color.knowColor
                    } else {
                        Color.clear
                    }
                    
                }
                .padding()
                
            }
            
            Spacer()
            
            
            HStack() {
                
                //Spacer()
                
                if isFrom != .bookmared {
                    Button {
                        vm.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: true)
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
                        vm.updateIknowOrBookmarked(subjectId: subjectId, isBookmarked: false)
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
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onChange(of: vm.isBack) { newValue in
            if newValue {
                dismiss()
            }
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}

struct AudioMantraDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AudioMantraDetailsScreen(isFrom: .toRead, subjectId: "")
    }
}
