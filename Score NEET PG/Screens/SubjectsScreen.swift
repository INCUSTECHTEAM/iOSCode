//
//  SubjectsScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 18/08/22.
//

import SwiftUI

struct SubjectsScreen: View {
    
    @StateObject private var vm = SubjectsViewModel()
    @Namespace private var namespace
    
    //Navigation
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
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
                    TextField("Search", text: $vm.searchText)
                    Spacer()
                }
                .padding(.all, 15)
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.cellLightGreyColor)
                }
                .padding(.horizontal)
                
                if !vm.filteredSubjects.isEmpty {
                    HStack {
                        Text(vm.filteredSubjects.count > 1 ? "\(vm.filteredSubjects.count) Subjects" : "\(vm.filteredSubjects.count) Subject")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextRegular, size: 18))
                        
                        Spacer()
                    }
                    .padding(10)
                    
                }
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(vm.filteredSubjects, id: \.id) { subject in
                            SubjectCellView(subject: subject, isHidePPT: vm.pptSubjects.contains(where: {  $0.id == subject.id }) ? true : false)
                                .padding(.horizontal)
                        }
                    }
                }
                .onAppear {
                    vm.getSubjectWithPPT()
                }
                                
                Spacer()
                
            } //: VSTACK
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            
            
            if !self.vm.isLoading && self.vm.filteredSubjects.isEmpty {
                Text(vm.subjects.isEmpty ? "No subject found" : "No results found")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 18))
            }
            
            if self.vm.isLoading {
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
