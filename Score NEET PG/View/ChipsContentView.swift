//
//  ChipsContentView.swift
//  Score MLE
//
//  Created by ios on 01/08/22.
//

import SwiftUI

struct ChipsContentView: View {
    // MARK: - PROPERTIES
    
    @Binding var chips: [ChipsDataModel]
    @Binding var filteredValues: [String]
    @State var isSelected = false
    
    var count: Int
    
    let columnSpacing: CGFloat = 8
    let rowSpacing: CGFloat = 8
    var gridLayout: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 3)
    }
    
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 2), spacing: columnSpacing) {
                ForEach(chips) { chip in
                    
                    if !filteredValues.contains(where: { $0 == chip.titleKey }) {
                        ChipsView(titleKey: chip.titleKey, isSelected: false)
                            .onTapGesture {
                                filteredValues = [chip.titleKey]
                            }
                    } else {
                        ChipsView(titleKey: chip.titleKey, isSelected: true)
                            .onTapGesture {
                                filteredValues.removeAll()
                            }
                    }
                    
                    
                } //: LOOP
            } //: GRID
            .frame(height: 80)
            .padding(15)
            
            
        } //: SCROLL
    }
}

//struct ChipsContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChipsContentView()
//    }
//}
