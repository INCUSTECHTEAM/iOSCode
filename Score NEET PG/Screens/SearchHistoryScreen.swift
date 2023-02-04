//
//  SearchHistoryScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 13/01/23.
//

import SwiftUI

struct SearchHistoryScreen: View {
    
    @ObservedObject private var searchHistoryVM = SearchHistoryViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationView(name: "Topic")
                .padding(.all)
            
            if searchHistoryVM.historyList.isEmpty {
                Text("No data available")
                    .font(.custom(K.Font.sfUITextRegular, size: 18))
                    .padding()
            } else {
                List {
                    ForEach(searchHistoryVM.historyList, id: \.id) { history in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Button {
                                    searchHistoryVM.deleteItems(history)
                                } label: {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 30)
                                        .padding(.leading, 10)
                                }

                                Text(history.word ?? "")
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        print("On Tap Text")
                                    }
                            }
                            Divider()
                        }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: searchHistoryVM.deleteItems)
                }
                .listStyle(.plain)
                .refreshable {
                    searchHistoryVM.getHistory()
                }
            }
            
            Spacer()
        }
        .onAppear {
            searchHistoryVM.getHistory()
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}

struct SearchHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryScreen()
    }
}
