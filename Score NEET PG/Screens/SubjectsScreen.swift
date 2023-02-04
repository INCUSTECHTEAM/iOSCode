//
//  SubjectsScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 18/08/22.
//

import SwiftUI

struct SubjectsScreen: View {
    
    //MARK: - PROPERTIES
    @State private var subjects = Subject()
    @State private var pptSubjects = Subject()
    @State private var searchText = ""
    @State private var isLoading = false
    
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var filteredSubjects: Subject {
        if searchText.isEmpty {
            return subjects
        } else {
            return subjects.filter { $0.subjectName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    //MARK: - FUNCTIONS
    
    private func getSubjects() {
        isLoading = true
        NetworkManager.shared.getSubjects { result in
            isLoading = false
            switch result {
            case .success(let subjects):
                self.subjects = subjects
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getSubjectWithPPT() {
        isLoading = true
        NetworkManager.shared.getSubjectsWithPPT { result in
            isLoading = false
            switch result {
            case .success(let subjects):
                self.pptSubjects = subjects
                getSubjects()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            VStack {
                
                CustomInlineNavigationBar(name: "Videos")
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    TextField("Search", text: $searchText)
                    Spacer()
                }
                .padding(.all, 15)
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.cellLightGreyColor)
                }
                .padding(.horizontal)
                
                List {
                    Section(content: {
                        ForEach(filteredSubjects) { subject in
                            SubjectCellView(subject: subject, isHidePPT: pptSubjects.contains(where: {  $0.id == subject.id }) ? true : false)
                            //.background(NavigationLink("", destination: VideoListScreen(subjectID: subject.id.description)).opacity(0))
                            //.background(NavigationLink("", destination: PPTListView(subjectID: subject.id.description)).opacity(0))
                        }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                    }, header: {
                        if !filteredSubjects.isEmpty {
                            HStack {
                                Text(filteredSubjects.count > 1 ? "\(filteredSubjects.count) Subjects" : "\(filteredSubjects.count) Subject")
                                    .foregroundColor(.textColor)
                                    .font(.custom(K.Font.sfUITextRegular, size: 18))
                                
                                Spacer()
                            }
                            .padding(10)
                            .listRowInsets(EdgeInsets())
                            .background(Color.backgroundColor)
                            
                        }
                        
                    })
                }
                .listStyle(.plain)
                .onAppear {
                    //getSubjects()
                    getSubjectWithPPT()
                }
                
                Spacer()
                
            } //: VSTACK
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            
            if self.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
        } //: ZSTACK
    }
}

struct SubjectsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsScreen()
    }
}
