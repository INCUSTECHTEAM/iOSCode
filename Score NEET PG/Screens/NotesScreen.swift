//
//  NotesScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI
import Combine

struct NotesScreen: View {
    //MARK: - PROPERTIES
    
    @StateObject var notesVM = NotesViewModel()
    @State var cellChange = false
    @State private var scrollAmount: CGFloat = 0
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                CustomInlineNavigationBar(name: "Notes")
                
                HeaderQuestionCountView()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        let notesList = notesVM.notesDataModel.notesList.data ?? []
                        ForEach(Array(notesList.enumerated()), id: \.offset, content: { (index, noteData) in
                                NotesCellView(note: noteData, isTrial: index == 0 ? true : false)
                                    .padding(.horizontal)
                                    .id(index)
                        })
                    }
                }
                .simultaneousGesture(DragGesture().onChanged({ value in
                    let sensitivity: CGFloat = 0.02
                    self.scrollAmount = sensitivity * value.translation.height
                }))
                .offset(y: -scrollAmount)
              
                
                
                Spacer()
            }
            .onAppear(perform: {
                notesVM.getNotes()
            })
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $notesVM.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            
            if self.notesVM.notesDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .navigationBarBackButtonHidden()
        
    }
    
    //MARK: HEADER QUESTION COUNT
    
    @ViewBuilder
    func HeaderQuestionCountView() -> some View {
        HStack {
            
            Spacer()
            
            VStack {
                
                Text(notesVM.notesDataModel.notesList.stats?.totalCount?.description ?? "")
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Total Slides")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            .padding(.leading)
            
            Spacer()
            
            VStack {
                Text(notesVM.notesDataModel.notesList.stats?.totalToBeRead?.description ?? "")
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Read")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            //.padding(.leading)
            
            Spacer()
            
            VStack {
                Text(notesVM.notesDataModel.notesList.stats?.totalBookmarked?.description ?? "")
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Bookmarked")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            .padding(.trailing)
            
            Spacer()
            
        } //: HEADER
        .frame(maxWidth: .infinity)
    }
    
}

struct NotesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotesScreen()
    }
}

