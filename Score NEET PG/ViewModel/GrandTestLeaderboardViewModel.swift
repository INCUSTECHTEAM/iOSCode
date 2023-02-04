//
//  GrandTestLeaderboardViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct GrandTestLeaderboardDataModel {
    let tabs: [TopTab] = [.init(title: "Analysis"),
                          .init(title: "Leaderboard")]
    var selectedTab: Int = 0
    var progress: CGFloat = 0.7
    var gtData = GtlistResponseElement()
    var gtAnaysis = GtAnalysisResponse()
    var gtLeaderboard = GtLeaderboard()
    var isLoading = false
}

class GrandTestLeaderboardViewModel: ObservableObject {
    @Published var leaderboardDataModel: GrandTestLeaderboardDataModel = GrandTestLeaderboardDataModel()
    let leaderboardResource: LeaderboardResource = LeaderboardResource()
    
    func getGtList(id: String) {
        leaderboardDataModel.isLoading = true
        leaderboardResource.getGtListData(gtId: id) { [weak self] (result) in
            self?.leaderboardDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.leaderboardDataModel.gtData = response.first ?? GtlistResponseElement()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func getGtAnalysis(id: String) {
        leaderboardDataModel.isLoading = true
        leaderboardResource.getGtAnalysis(gtId: id) { [weak self] (result) in
            self?.leaderboardDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.leaderboardDataModel.gtAnaysis = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func getStAnalysis(id: String) {
        leaderboardDataModel.isLoading = true
        leaderboardResource.getStAnalysis(stId: id) { [weak self] (result) in
            self?.leaderboardDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.leaderboardDataModel.gtAnaysis = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func getGtLeaderboard(id: String) {
        leaderboardDataModel.isLoading = true
        leaderboardResource.getGtLeaderboard(gtId: id) { [weak self] (result) in
            self?.leaderboardDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.leaderboardDataModel.gtLeaderboard = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
}
