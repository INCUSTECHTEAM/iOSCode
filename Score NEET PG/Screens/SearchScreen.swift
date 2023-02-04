//
//  SearchScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/01/23.
//

import SwiftUI
import Kingfisher

struct SearchScreen: View {
    //MARK: PROPERTIES
    @StateObject var searchVM = SearchViewModel()
    //MARK: Keyboard State
    @FocusState private var isKeyboardShowing: Bool
    
    //MARK: BODY
    var body: some View {
        VStack {
            CustomInlineNavigationBar(name: "Search")
                .overlay(alignment: .trailingLastTextBaseline) {
                    NavigationLink(destination: {
                        SearchHistoryScreen()
                    }, label: {
                        Text("History")
                            .foregroundColor(.textColor)
                    })
                    .padding(.trailing)
                }
            
            TopTabView(tabs: searchVM.tabs, selectedTab: $searchVM.selectedTab)
                .onChange(of: searchVM.selectedTab) { newValue in
                    searchVM.performSearch()
                }
            
            searchField()
                .disabled(paymentStatus ? false : true)
            
            if searchVM.noResultFound {
                Text("Sorry, we couldn't find any results for your search.")
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
            }
            
            if !paymentStatus {
                SubscriptionView()
                    .frame(width: 400)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    switch searchVM.selectedTab {
                    case 0:
                        if searchVM.currentQuestion != nil {
                            questionsNavButtonsView()
                            questionDetailsView()
                        } else {
                            //Error and Loader
                            if searchVM.isLoading {
                                ProgressView()
                            }
                        }
                    case 1:
                        if searchVM.currentNote != nil {
                            questionsNavButtonsView()
                            NoteView()
                        }
                        
                        if searchVM.isLoading {
                            ProgressView()
                        }
                        
                        
                        
                    default: EmptyView()
                    }
                    
                    //Spacer()
                }
                .padding()
            }
        }
        .onAppear(perform: {
            searchVM.updatePaymentStatus()
        })
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //MARK:  Search Field
    @ViewBuilder
    func searchField() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchVM.searchText, onEditingChanged: { isEditing in
                if !isEditing {
                    searchVM.performSearch()
                    searchVM.createSearchHistory()
                }
            })
            .focused($isKeyboardShowing)
            .submitLabel(.search)
            
            if !searchVM.searchText.isEmpty {
                Button {
                    searchVM.searchText = ""
                    isKeyboardShowing = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                    
                }
                
            }
        }
        .padding(.all)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.horizontal)
    }
    
    //MARK: Button Nav
    @ViewBuilder
    func questionsNavButtonsView() -> some View {
        HStack {
            Spacer()
            
            VStack(spacing: 0) {
                Button {
                    // Action
                    searchVM.prevQuestion()
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
                
                Text("Prev")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 12))
            }
            .opacity(searchVM.calculateQuestionCount().0 > 1 ? 1 : 0)
            
            
            Text("\(searchVM.calculateQuestionCount().0)/\(searchVM.calculateQuestionCount().1)")
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextRegular, size: 14))
            
            VStack(spacing: 0) {
                Button {
                    // Action
                    searchVM.nextQuestion()
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.system(size: 18))
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
            .opacity(searchVM.calculateQuestionCount().0 < searchVM.calculateQuestionCount().1 ? 1 : 0)
        } //: VSTACK
        .padding(.horizontal)
    }
    
    //MARK: Questions Details
    @ViewBuilder
    func questionDetailsView() -> some View {
        
        VStack(spacing: 30) {
            
            //MARK: QUESTION TEXT
            HStack {
                Text(searchVM.currentQuestion?.questionText ?? "Question")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.avenir, size: 22))
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            if let image = searchVM.currentQuestion?.image, image != "nan", !image.isEmpty {
                //Question Image if Available
                HStack {
                    Spacer()
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                        .onTapGesture {
                            searchVM.item = Item(image: searchVM.currentQuestion?.image ?? "")
                        }
                        .fullScreenCover(item: $searchVM.item, onDismiss: { print("Dismissed") }) {
                            FullScreenImageScreen(item: $0)
                        }
                    Spacer()
                }
            }
            
            
            VStack(spacing: 10) {
                
                //MARK: - OPTION A
                HStack {
                    //Spacer()
                    Text(searchVM.currentQuestion?.optionAText ?? "A")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.textColor)
                    Spacer()
                }
                .padding(10)
                .background(searchVM.answerColor(option: "A"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                //MARK: - OPTION B
                HStack {
                    //Spacer()
                    Text(searchVM.currentQuestion?.optionBText ?? "B")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.textColor)
                    Spacer()
                }
                .padding(10)
                .background(searchVM.answerColor(option: "B"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                //MARK: - OPTION C
                HStack {
                    //Spacer()
                    Text(searchVM.currentQuestion?.optionCText ?? "C")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.textColor)
                    Spacer()
                }
                .padding(10)
                .background(searchVM.answerColor(option: "C"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                //MARK: - OPTION D
                HStack {
                    //Spacer()
                    Text(searchVM.currentQuestion?.optionDText ?? "D")
                        .font(.custom(K.Font.avenir, size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.textColor)
                    Spacer()
                }
                .padding(10)
                .background(searchVM.answerColor(option: "D"))
                .cornerRadius(10)
                .padding(.horizontal)
                
            } //: BUTTONS
            
            
            //MARK: AUDIO
            
            if let audios = searchVM.currentQuestion?.audio?.filter({ $0.valid == true }), audios.isEmpty == false {
                VStack {
                    ForEach(0..<audios.count, id: \.self) { index in
                        RecordingPlayerViewWithoutSlider(audioData: audios[index]) {
                            searchVM.deleteAudio(audioId: audios[index].id?.description ?? "")
                        }
                    }
                }
            }
            
            //MARK: Explation
            
            if let explation = searchVM.currentQuestion?.explanation, !explation.isEmpty && explation != "nan" {
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
                    
                } //EXPLANATION VSTACK
            }
            
            
        }
    }
    
    //MARK: - Notes Tab View
    
    @ViewBuilder
    func NoteView() -> some View {
        VStack {
            Text(.init(searchVM.currentNote?.first?.fact ?? ""))
                .foregroundColor(.textColor)
                .font(.custom(K.Font.avenir, size: 22))
                .padding(.all)
        } //: VSTACK
        .overlay(content: {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(.orangeColor)
        })
        .background {
            Color.clear
        }
        .padding(.all)
        
        if let audios = searchVM.currentNote?.first?.audio?.filter({ $0.valid == true }), audios.isEmpty == false {
            VStack {
                ForEach(0..<audios.count, id: \.self) { index in
                    RecordingPlayerViewWithoutSlider(audioData: audios[index]) {
                        searchVM.deleteAudio(audioId: audios[index].id?.description ?? "")
                    }
                }
            }
        }
        
    }
    
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
