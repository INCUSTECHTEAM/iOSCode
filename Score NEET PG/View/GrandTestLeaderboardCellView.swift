//
//  GrandTestLeaderboardCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import SwiftUI
import Kingfisher

struct GrandTestLeaderboardCellView: View {
    //MARK: - PROPERTIES
    
    var leader: GtLeaderboardElement
    
    //MARK: - BODY
    var body: some View {
        HStack {
            KFImage(URL(string: leader.user?.photo ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(30)
                .padding()
                
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(leader.user?.firstName ?? "") \(leader.user?.lastName ?? "")")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .multilineTextAlignment(.leading)
                
                Text("#")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .multilineTextAlignment(.leading)
            }
            //.frame(width: 150)
            .padding(.trailing)
            
            Spacer()
            
            Text("\(leader.score ?? 0)")
                .foregroundColor(.orangeColor)
                .font(.custom(K.Font.sfUITextBold, size: 18))
                .lineLimit(1)
                .padding(.horizontal)
            
        }
        .background(Color.white).cornerRadius(10)
    }
}

struct GrandTestLeaderboardCellView_Previews: PreviewProvider {
    static var previews: some View {
        GrandTestLeaderboardCellView(leader: GtLeaderboardElement())
            .background(Color.black.ignoresSafeArea())
    }
}
