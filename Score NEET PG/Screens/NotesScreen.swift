//
//  NotesScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct NotesScreen: View {
    //MARK: - PROPERTIES
    
    @StateObject var notesVM = NotesViewModel()
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var body: some View {
        ZStack {
                VStack {
                    
                    CustomInlineNavigationBar(name: "Notes")
                    
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
                    
                    
                    List {
                        ForEach(notesVM.notesDataModel.notesList.data?.indices ?? [].indices, id: \.self) { index in
                            NotesCellView(note: notesVM.notesDataModel.notesList.data?[index] ?? NotesData(), isTrial: index == 0 ? true : false)
                                .padding(.horizontal)
                        }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    
                    Spacer()
                }
                .onAppear(perform: {
                    notesVM.getNotes()
                })
                .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                .navigationBarTitleDisplayMode(.inline)
            
            if self.notesVM.notesDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        
    }
}

struct NotesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotesScreen()
    }
}
