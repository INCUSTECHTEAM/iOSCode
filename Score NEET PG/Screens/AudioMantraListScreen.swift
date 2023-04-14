//
//  AudioMantraListScreen.swift
//  Score NEET PG
//
//  Created by Rahul on 13/04/23.
//

import SwiftUI

struct AudioMantraListScreen: View {
    
    @State private var scrollAmount: CGFloat = 0
    @StateObject private var vm = AudioMantraListViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                CustomInlineNavigationBar(name: "Audio Mantra")
                
                HeaderQuestionCountView()
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        let notesList = vm.list
                        ForEach(Array(notesList.enumerated()), id: \.offset, content: { (index, data) in
                            AudioMantraCellView(isTrial: index == 0 ? true : false, data: data)
                                    .padding(.horizontal)
                                    .id(index)
                        })
                    }
                }
                .simultaneousGesture(DragGesture().onChanged({ value in
                    let sensitivity: CGFloat = 0.02
                    self.scrollAmount = sensitivity * value.translation.height
                }))
                .offset(y: -scrollAmount)
                
                Spacer()
                
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            
            if self.vm.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
        }
        .onAppear {
            vm.getAudioMantraList()
        }
    }
    
    //MARK: HEADER QUESTION COUNT
    
    @ViewBuilder
    func HeaderQuestionCountView() -> some View {
        HStack {
            
            Spacer()
            
            VStack {
                
                Text(vm.totalSlideCount)
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Total Slides")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            .padding(.leading)
            
            Spacer()
            
            VStack {
                Text(vm.readCount)
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Read")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            //.padding(.leading)
            
            Spacer()
            
            VStack {
                Text(vm.bookmarkedCount)
                    .foregroundColor(.white)
                    .font(.custom(K.Font.sfUITextBold, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 80, height: 80)
                    .background {
                        Circle().fill(Color.orangeColor)
                    }
                    .padding(.vertical, 10)
                
                Text("Bookmarked")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } //: VSTACK
            .padding(.trailing)
            
            Spacer()
            
        } //: HEADER
        .frame(maxWidth: .infinity)
    }
    
}

struct AudioMantraListScreen_Previews: PreviewProvider {
    static var previews: some View {
        AudioMantraListScreen()
    }
}
