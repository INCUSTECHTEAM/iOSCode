//
//  SubjectMockTestListScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct SubjectMockTestListScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var subjectMocktestVM: SubjectMockTestViewModel = SubjectMockTestViewModel()
    var gtId: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - BODY
    var body: some View {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        K.byPassBaseURL = ""
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.all)
                    }
                    .padding(.horizontal)
                    .background {
                        Circle()
                            .foregroundColor(.textColor)
                    }

                    Spacer()
                    
                }
                
                List {
                    Section {
                        ForEach(subjectMocktestVM.subjectMockTestDataModel.mockTests.indices, id: \.self) { index in
                            GrandTestCellView(mockTestResponseElement: subjectMocktestVM.subjectMockTestDataModel.mockTests[index], isFromSt: true, isTrial: index == 0 ? true : false)
                        }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                    } header: {
                        HStack {
                            Text("\(subjectMocktestVM.subjectMockTestDataModel.mockTests.count) Subject")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                            
                            Spacer()
                        }
                        .padding(10)
                        .listRowInsets(EdgeInsets())
                        .background(Color.backgroundColor)
                    }
                    
                }
                .task {
                    subjectMocktestVM.getMockTests(id: gtId.description)
                }
                .listStyle(.plain)
                
                
            } //: VSTACK
            .navigationTitle("Mock Test")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        
    }
}

struct SubjectMockTestListScreen_Previews: PreviewProvider {
    static var previews: some View {
        SubjectMockTestListScreen()
    }
}
