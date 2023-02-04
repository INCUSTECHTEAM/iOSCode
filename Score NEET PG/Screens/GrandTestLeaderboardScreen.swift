//
//  GrandTestLeaderboardScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI

struct GrandTestLeaderboardScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var grandTestLeaderboardVM = GrandTestLeaderboardViewModel()
    var gTId: String = ""
    var isFromSt = false
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                CustomNavigationView(name: "Leaderboard")
                    .padding(.all)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(grandTestLeaderboardVM.leaderboardDataModel.gtData.testName ?? "")
                        .foregroundColor(.orangeColor)
                        .font(.custom(K.Font.sfUITextBold, size: 16))
                    
                    Text("Total Marks: \(grandTestLeaderboardVM.leaderboardDataModel.gtData.score ?? 0)")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 16))
                    
                    Text("Right MCQs: \(grandTestLeaderboardVM.leaderboardDataModel.gtData.rightAnswers ?? 0)")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 16))
                    
                    Text("Unattempted MCQs: \(grandTestLeaderboardVM.leaderboardDataModel.gtData.skippedAnswers ?? 0)")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 16))
                    
                    Text("Wrong Answer: \(grandTestLeaderboardVM.leaderboardDataModel.gtData.wrongAnswers ?? 0)")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 16))
                } // HEADER
                .padding(.all)
                .task {
                    grandTestLeaderboardVM.getGtList(id: gTId)
                }
                
                //MARK: CUSTOM PROGRESS VIEW
                
                HStack(alignment: .center) {
                    Spacer()
                    CustomProgressView(progress: $grandTestLeaderboardVM.leaderboardDataModel.progress, text: grandTestLeaderboardVM.leaderboardDataModel.gtData.rank?.description ?? "0")
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                
                TopTabView(tabs: grandTestLeaderboardVM.leaderboardDataModel.tabs, selectedTab: $grandTestLeaderboardVM.leaderboardDataModel.selectedTab)
                
                switch grandTestLeaderboardVM.leaderboardDataModel.selectedTab {
                case 0:
                    List {
                        Section(content: {
                            ForEach(grandTestLeaderboardVM.leaderboardDataModel.gtAnaysis, id: \.name) { subject in
                                HStack {
                                    Text(subject.name ?? "")
                                        .foregroundColor(.textColor)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        .frame(width: 100)
                                    
                                    Spacer()
                                    HStack(alignment: .center ,spacing: 25) {
                                        Text("\(subject.all ?? 0)")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                        Text("\(subject.rightAnswers ?? 0)")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                        Text("\(subject.wrongAnswers ?? 0)")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                        Text("\(subject.unanswered ?? 0)")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                        Text(subject.percentage ?? "0.00")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                        Text("\(subject.score ?? 0)")
                                            .foregroundColor(.textColor)
                                            .font(.custom(K.Font.sfUITextRegular, size: 14))
                                            
                                    }
                                    
                                    
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.backgroundColor)
                            .listRowSeparator(.hidden)
                        }, header: {
                            HStack(alignment: .center) {
                                Text(isFromSt ? "Topic" :"Subjects")
                                    .foregroundColor(.white)
                                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    .frame(width: 100)
                                
                                
                                Spacer()
                                HStack(alignment: .center ,spacing: 25) {
                                    Text("T")
                                        .foregroundColor(.white)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        //.padding(.leading, 25)
                                    Text("R")
                                        .foregroundColor(.white)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        
                                    Text("W")
                                        .foregroundColor(.white)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        
                                    Text("UA")
                                        .foregroundColor(.white)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        
                                    Text("%")
                                        .foregroundColor(.white)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                        
                                    Text("S")
                                        .foregroundColor(.white)
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
                    .task({
                        if isFromSt {
                            grandTestLeaderboardVM.getStAnalysis(id: gTId)
                        } else {
                            grandTestLeaderboardVM.getGtAnalysis(id: gTId)
                        }
                        
                    })
                    .listStyle(.plain)
                case 1:
                    List {
                        ForEach(grandTestLeaderboardVM.leaderboardDataModel.gtLeaderboard, id: \.user?.id) { leaderboard in
                            GrandTestLeaderboardCellView(leader: leaderboard)
                        }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                    }
                    .task {
                        grandTestLeaderboardVM.getGtLeaderboard(id: gTId)
                    }
                    .listStyle(.plain)
                default:
                    EmptyView()
                }
                
                
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        } //: VSTACK
        
        if self.grandTestLeaderboardVM.leaderboardDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
        }
        
    }
}

struct GrandTestLeaderboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        GrandTestLeaderboardScreen()
    }
}
