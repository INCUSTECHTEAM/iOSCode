//
//  FilterScreen.swift
//  Score MLE
//
//  Created by ios on 01/08/22.
//

import SwiftUI

struct FilterScreen: View {
    
    // MARK: - PROPERTIES
    
    @Binding var subjectList: [ChipsDataModel]
    @Binding var FactList: [ChipsDataModel]
    @Binding var filteredSubjectValues: [String]
    @Binding var filteredFactValues: [String]
    @Binding var currentTab: RevisionTab
    
    
    
    // MARK: - FUNCTION
    
    
    
    // MARK: - BODY
    var body: some View {
        
        VStack {
            Spacer(minLength: 250)
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                        filteredFactValues.removeAll()
                        filteredSubjectValues.removeAll()
                        
                    }) {
                        Text("Clear")
                            .font(.custom(K.Font.sfUITextBold, size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: 640)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.textColor)
                            .frame(width: 60, height: 30)
                    )
                    .frame(width: 60, height: 30)
                    .padding(30)
                    
                } //: HSTACK
                
                
                VStack {
                    Text("Select By Subject")
                        .font(.custom(K.Font.sfUITextBold, size: 14))
                        .foregroundColor(.textColor)
                    
                    if filteredSubjectValues.count > 3 && filteredSubjectValues.count <= 6 {
                        
                        ChipsContentView(chips: $subjectList, filteredValues: $filteredSubjectValues, count: 2)
                    } else if filteredSubjectValues.count <= 3 {
                        
                        ChipsContentView(chips: $subjectList, filteredValues: $filteredSubjectValues, count: 1)
                    } else {
                        
                        ChipsContentView(chips: $subjectList, filteredValues: $filteredSubjectValues, count: 3)
                    }
                    
                    
                }
                
                if currentTab == .RightQuestions || currentTab == .WrongQuestions {
                    EmptyView()
                } else {
                    VStack {
                        Text("Select By Fact Type")
                            .font(.custom(K.Font.sfUITextBold, size: 14))
                            .foregroundColor(.textColor)
                        
                        ChipsContentView(chips: $FactList, filteredValues: $filteredFactValues, count: 1)
                        
                    } //: VSTACK
                }
                
                
                Spacer()
                
            }
            
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all).cornerRadius(20, corners: [.topLeft, .topRight]))
            .padding(10)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

//struct FilterScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterScreen(SubjectList: )
//    }
//}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


