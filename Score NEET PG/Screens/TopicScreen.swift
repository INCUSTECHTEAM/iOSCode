//
//  TopicScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 04/12/22.
//

import SwiftUI

struct TopicScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var topicViewModel: TopicViewModel = TopicViewModel()
    var subjectID = ""
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationView(name: "Topic")
                    .padding(.all)
                
                TopTabView(tabs: topicViewModel.topicDataModel.tabs, selectedTab: $topicViewModel.topicDataModel.selectedTabIndex)
                
                switch topicViewModel.topicDataModel.selectedTabIndex {
                case 0:
                    List {
                        Section(content: {
                            ForEach(topicViewModel.topicDataModel.topicAnalysis.attempted ?? [], id: \.name) { subject in
                                HStack {
                                    Text(subject.name ?? "")
                                        .foregroundColor(.textColor)
                                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        .frame(maxWidth: 150, alignment: .leading)
                                    
                                    Spacer()
                                    HStack(alignment: .center) {
                                        Text("\(subject.all ?? 0)")
                                            .foregroundColor(.textColor)
                                            .lineLimit(1)
                                            .frame(minWidth: 25)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                            .minimumScaleFactor(0.8)
                                        
                                        Text("\(subject.rightAnswers ?? 0)")
                                            .foregroundColor(.textColor)
                                            .frame(minWidth: 25)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                        Text("\(subject.wrongAnswers ?? 0)")
                                            .foregroundColor(.textColor)
                                            .frame(minWidth: 25)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                        Text("\(subject.unanswered ?? 0)")
                                            .foregroundColor(.textColor)
                                            .frame(width: 25)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                        Text(subject.percentage ?? "0.00")
                                            .foregroundColor(.textColor)
                                            .frame(minWidth: 25)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                        Text("\(subject.skippedAnswers ?? 0)")
                                            .foregroundColor(.textColor)
                                            .frame(minWidth: 25)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                    }
                                    
                                    
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.backgroundColor)
                            .listRowSeparator(.hidden)
                        }, header: {
                            HStack(alignment: .center) {
                                Text("Topic")
                                    .foregroundColor(.white)
                                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    .frame(width: 150)
                                
                                
                                Spacer()
                                HStack(alignment: .center ,spacing: 24) {
                                    Text("T")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    //.padding(.leading, 25)
                                    Text("R")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                    Text("W")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                    Text("UA")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                    Text("%")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                    Text("S")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                } // SECTION HEADER
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .background {
                                Rectangle().fill(Color.orangeColor)
                            }
                            .padding(10)
                            .listRowInsets(EdgeInsets())
                            .background(Color.backgroundColor)
                        })
                    }
                    .listStyle(.plain)
                case 1:
                    List {
                        Section(content: {
                            ForEach(topicViewModel.topicDataModel.topicAnalysis.unattempted ?? [], id: \..name) { subject in
                                HStack {
                                    Text(subject.name ?? "")
                                        .foregroundColor(.textColor)
                                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        .frame(minWidth: 240, maxWidth: 250, alignment: .leading)
                                    
                                    Spacer()
                                    HStack(alignment: .center) {
                                        
                                        Text("\(subject.all ?? 0)")
                                            .foregroundColor(.textColor)
                                            .frame(minWidth: 30)
                                            .lineLimit(1)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                        
                                        Spacer()
                                        
                                        Text("\(subject.unanswered ?? 0)")
                                            .foregroundColor(.textColor)
                                            .lineLimit(1)
                                            .frame(minWidth: 30)
                                            .font(.custom(K.Font.sfUITextRegular, size: 12))
                                            .padding(.horizontal)
                                    }
                                    
                                    
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.backgroundColor)
                            .listRowSeparator(.hidden)
                        }, header: {
                            HStack(alignment: .center) {
                                Text("Topic")
                                    .foregroundColor(.white)
                                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    .frame(width: 250, alignment: .center)
                                
                                
                                Spacer()
                                HStack(alignment: .center) {
                                    Text("T")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    Spacer()
                                    
                                    Text("UA")
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        .padding(.horizontal)
                                    
                                } // SECTION HEADER
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .background {
                                Rectangle().fill(Color.orangeColor)
                            }
                            .padding(10)
                            .listRowInsets(EdgeInsets())
                            .background(Color.backgroundColor)
                        })
                    }
                    .listStyle(.plain)
                default:
                    EmptyView()
                }
                
                Spacer()
                
            } //VSTACK
            .onAppear(perform: {
                topicViewModel.getTopicAnalysisData(subjectId: subjectID)
            })
            .background(Color.backgroundColor.ignoresSafeArea(.all))
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            
            if self.topicViewModel.topicDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            
        }
    }
}

struct TopicScreen_Previews: PreviewProvider {
    static var previews: some View {
        TopicScreen()
    }
}
