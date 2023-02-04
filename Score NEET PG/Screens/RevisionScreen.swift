//
//  RevisionScreen.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI

struct RevisionScreen: View {
    // MARK: - PROPERTIES
    
    @State var currentTab: RevisionTab = .RightQuestions
    @State private var rightWrongQuestions: [RightWrongQuestion] = []
    @State private var shyfQuestions: ShyfRightWrongQuestions = ShyfRightWrongQuestions()
    @State private var mockTestList: MockTest = []
    @State var isPresentedFilter = false
    @State var questionsSubjectList: [ChipsDataModel] = []
    @State var FactList: [ChipsDataModel] = [
        ChipsDataModel(titleKey: "Fact"),
        ChipsDataModel(titleKey: "Video")
    ]
    
    @StateObject var storeManager = StoreManager()
    @State var isLoading = false
    @State var filteredSubjectValues: [String] = []
    @State var filteredFactValues: [String] = []
    
    @State private var item: Item? = nil
    
    private var tabList: [RevisionTab] = [
        .RightQuestions,
        .WrongQuestions,
        .BookmarkHYF,
        .KnownHYF,
        .UnknownHYF,
        .MockTest
    ]
    
    // MARK: - FUNCTIONS
    
    
    private func getVideoURL(vimeoId: String) {
        isLoading = true
        VimeoManager.shared.getVideoURL(vimeoId: vimeoId) { result in
            isLoading = false
            switch result {
            case .success(let url):
                item = Item(image: url)
            case .failure(_):
                break
            }
        }
    }
    
    
    private func getRightWrongQuestions() {
        
        questionsSubjectList.removeAll()
        rightWrongQuestions.removeAll()
        
        NetworkManager.shared.getrightWrongQuestions(isRightQuestion: currentTab == .RightQuestions ? true : false) { result in
            switch result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    if currentTab == .RightQuestions || currentTab == .WrongQuestions {
                        let subjectNames = data.compactMap({ $0.subjectDisplayName })
                        subjectNames.forEach { subject in
                            if !questionsSubjectList.contains(where: { $0.titleKey == subject }) {
                                questionsSubjectList.append(ChipsDataModel(titleKey: subject))
                            }
                        }
                    }
                        
                    withAnimation {
                        self.rightWrongQuestions = data
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getShyfQuestions(category: String) {
        var id = "b"
        
        if currentTab == .BookmarkHYF {
            id = "b"
        } else if currentTab == .UnknownHYF {
            id = "n"
        } else if currentTab == .KnownHYF {
            id = "k"
        }
        
        questionsSubjectList.removeAll()
        shyfQuestions.removeAll()
        
        NetworkManager.shared.getShyfRightWrongQuestions(category: id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    
                    if currentTab == .BookmarkHYF || currentTab == .KnownHYF || currentTab == .UnknownHYF {
                        let subjects = data.compactMap({ $0.subjectDisplayName })
                        
                        print(questionsSubjectList)
                        
                        subjects.forEach { subject in
                            if !questionsSubjectList.contains(where: { $0.titleKey == subject }) {
                                questionsSubjectList.append(ChipsDataModel(titleKey: subject))
                            }
                        }
                    }
                    withAnimation {
                        self.shyfQuestions = data
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func getMockTestList() {
        NetworkManager.shared.getMockTestList { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    withAnimation {
                        self.mockTestList = data
                    }
                    
                }
            case .failure(_):
                break
            }
        }
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Revision")
                        .font(.custom(K.Font.sfUITextBold, size: 24))
                        .foregroundColor(.textColor)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tabList, id: \.self) { tab in
                            Button(action: {
                                filteredSubjectValues.removeAll()
                                filteredFactValues.removeAll()
                                currentTab = tab
                                if paymentStatus {
                                    getRightWrongQuestions()
                                    getMockTestList()
                                }
                                
                                if currentTab != .RightQuestions || currentTab != .WrongQuestions {
                                    if paymentStatus {
                                        getShyfQuestions(category: currentTab.rawValue)
                                    }
                                    
                                } else if currentTab == .MockTest {
                                    if paymentStatus {
                                        getMockTestList()
                                    }
                                }
                                
                            }) {
                                if tab.rawValue == "Wrong Questions" || tab.rawValue == "Unknown HYF" {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .tint(currentTab == tab ? .textColor : .gray)
                                } else if tab.rawValue == "Bookmark HYF" {
                                    Image(systemName: "bookmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .tint(currentTab == tab ? .textColor : .gray)
                                } else {
                                    Image("Right Questions")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .tint(currentTab == tab ? .textColor : .gray)
                                }
                                
                                
                                Text(tab.rawValue)
                                    .foregroundColor(currentTab == tab ? .textColor : .gray)
                                    .font(.custom(K.Font.sfUITextBold, size: 15))
                            }
                            .padding(10)
                            .padding(.bottom, 10)
                        }
                    } //: HSTACK
                } //: SCROLL
                
                
                if currentTab != .MockTest {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                            if !rightWrongQuestions.isEmpty || !shyfQuestions.isEmpty {
                                isPresentedFilter.toggle()
                            }
                            
                        }) {
                            Text("Filter")
                                .font(.custom(K.Font.sfUITextRegular , size: 15))
                                .foregroundColor(.textColor)
                            
                            
                            Image(systemName: "square.fill.text.grid.1x2")
                                .font(.custom(K.Font.sfUITextRegular , size: 15))
                                .foregroundColor(.textColor)
                        }
                        .padding(.horizontal)
                        .transparentSheet(isPresented: $isPresentedFilter, content: {
                           // FilterScreen(subjectList: $questionsSubjectList, FactList: $FactList)
                            
                            FilterScreen(subjectList: $questionsSubjectList, FactList: $FactList, filteredSubjectValues: $filteredSubjectValues, filteredFactValues: $filteredFactValues, currentTab: $currentTab)
                            
                        })
                        
                        
                    } //: HSTACK
                }
                
                
                
                
                HStack {
                    
                    if currentTab == .RightQuestions || currentTab == .WrongQuestions {
                        Text("\(rightWrongQuestions.count) \(rightWrongQuestions.count > 1 ? "Questions" : "Question")")
                            .font(.custom(K.Font.sfUITextRegular , size: 15))
                            .foregroundColor(.textColor)
                            .padding(.horizontal)
                    } else if currentTab == .MockTest {
                        if mockTestList.count > 0 {
                            Text("\(mockTestList.count) \(mockTestList.count > 1 ? "Mock Tests" : "Mock Test")")
                                .font(.custom(K.Font.sfUITextRegular , size: 15))
                                .foregroundColor(.textColor)
                                .padding(.horizontal)
                        }
                    } else {
                        Text("\(shyfQuestions.count) \(shyfQuestions.count > 1 ? "Questions" : "Question")")
                            .font(.custom(K.Font.sfUITextRegular , size: 15))
                            .foregroundColor(.textColor)
                            .padding(.horizontal)
                    }
                    
                    
                    
                    Spacer()
                } //: HSTACK
                
                
                if !paymentStatus {
                    SubscriptionView()
                        .frame(width: 400)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
                        
                        if currentTab == .RightQuestions || currentTab == .WrongQuestions {
                           
                            if filteredSubjectValues.isEmpty {
                                ForEach(rightWrongQuestions, id: \.questionCode) { question in
                                    NavigationLink(destination: QuestionDetailsScreen(rightWrongQuestion: question, questions: rightWrongQuestions)) {
                                        RightWrongQuestionCellView(rightWrongQueston: question)
                                            .padding(.horizontal)
                                    }
                                }
                            } else {
                                ForEach(rightWrongQuestions.filter({ $0.subjectDisplayName == filteredSubjectValues.first }), id: \.questionCode) { question in
                                    NavigationLink(destination: QuestionDetailsScreen(rightWrongQuestion: question, questions: rightWrongQuestions)) {
                                        RightWrongQuestionCellView(rightWrongQueston: question)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            
                           
                        } else if currentTab == .MockTest {
                            
                            ForEach(mockTestList, id: \.testName) { test in
                                NavigationLink(destination: MockTestQuestionsScreen(mockTestId: test.testID.description)) {
                                    MockTestCellView(mockTest: test)
                                        .padding(.horizontal)
                                }
                            }
                            
                        } else {
                            
                            
                            if filteredFactValues.isEmpty {
                                
                                
                                
                                ForEach(shyfQuestions.filter({ (filteredSubjectValues.isEmpty ? true : $0.subjectDisplayName == filteredSubjectValues.first) }), id: \.questionCode) { question in
                            
                                    if question.questionVideoURL != nil && question.questionVideoURL != "nan" {
                                        SHYFVideoCellView(shyfRightWrongQuestion: question)
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                //item = Item(image: question.questionVideoURL ?? "")
                                                getVideoURL(vimeoId: question.questionVideoURL ?? "")
                                                
                                            }
//                                            .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
//                                                VideoPlayerScreen(item: $0)
//                                            }
                                            .fullScreenCover(item: $item) { itemsss in
                                                AutoRotate(url: URL(string: itemsss.image)!)
                                            }
                                    } else {
                                        NavigationLink(destination: SYHFDetailsScreen(shyfRightWrongQuestion: question, questions: shyfQuestions.filter({ $0.questionVideoURL?.rangeOfCharacter(from: CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])) == nil }))) {
                                            SHYFCellView(shyfRightWrongQuestion: question)
                                                .padding(.horizontal)
                                        }
                                    }
                                    
                                    
                                }
                            } else {
                                
                                
                                if filteredFactValues.first == "Video" {
                                    
                                    ForEach(shyfQuestions.filter({ $0.questionVideoURL != nil && $0.questionVideoURL != "nan" && (filteredSubjectValues.isEmpty ? true : $0.subjectDisplayName == filteredSubjectValues.first) }), id: \.questionCode) { question in
                                
                                        if question.questionVideoURL != nil && question.questionVideoURL != "nan" {
                                            SHYFVideoCellView(shyfRightWrongQuestion: question)
                                                .padding(.horizontal)
                                                .onTapGesture {
                                                    item = Item(image: question.questionVideoURL ?? "")
                                                }
                                                .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
                                                    VideoPlayerScreen(item: $0)
                                                }
                                        } else {
                                            NavigationLink(destination: SYHFDetailsScreen(shyfRightWrongQuestion: question, questions: shyfQuestions.filter({ $0.questionVideoURL?.rangeOfCharacter(from: CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])) == nil }))) {
                                                SHYFCellView(shyfRightWrongQuestion: question)
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    
                                    ForEach(shyfQuestions.filter({ $0.questionVideoURL?.rangeOfCharacter(from: CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])) == nil && (filteredSubjectValues.isEmpty ? true : ($0.subjectDisplayName == filteredSubjectValues.first)) }), id: \.questionCode) { question in
                                
                                        if question.questionVideoURL != nil && question.questionVideoURL != "nan" {
                                            SHYFVideoCellView(shyfRightWrongQuestion: question)
                                                .padding(.horizontal)
                                                .onTapGesture {
                                                    item = Item(image: question.questionVideoURL ?? "")
                                                }
                                                .fullScreenCover(item: $item, onDismiss: { print("Dismissed") }) {
                                                    VideoPlayerScreen(item: $0)
                                                }
                                        } else {
                                            NavigationLink(destination: SYHFDetailsScreen(shyfRightWrongQuestion: question, questions: shyfQuestions.filter({ $0.questionVideoURL?.rangeOfCharacter(from: CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])) == nil }))) {
                                                SHYFCellView(shyfRightWrongQuestion: question)
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                          
                        }
                        
                        
                    } //: VSTACK
                } //: SCROLL
                
                
            } //: VSTACK
            .overlay {
                if paymentStatus {
                    if currentTab == .RightQuestions || currentTab == .WrongQuestions {
                        if rightWrongQuestions.isEmpty {
                            Text("Sorry! No question available")
                                .font(.custom(K.Font.sfUITextRegular , size: 15))
                                .foregroundColor(.textColor)
                        }
                    } else {
                        if shyfQuestions.isEmpty {
                            Text("Sorry! No question available")
                                .font(.custom(K.Font.sfUITextRegular , size: 15))
                                .foregroundColor(.textColor)
                        }
                    }
                }
                
                if isLoading {
                    GeometryReader { proxy in
                        Loader()
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    }
                    //.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
                }
                
            }
            .onAppear {
                if paymentStatus {
                    getRightWrongQuestions()
                }
                
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            
            
            
        } //: NAVIGATION
        
        
    }
}

// MARK: - FILTER CARD




struct RevisionScreen_Previews: PreviewProvider {
    static var previews: some View {
        RevisionScreen()
    }
}

// MARK: - REVISION TAB CASES
enum RevisionTab: String, CaseIterable {
    case RightQuestions = "Right Questions"
    case WrongQuestions = "Wrong Questions"
    case BookmarkHYF = "Bookmark HYF"
    case KnownHYF = "Known HYF"
    case UnknownHYF = "Unknown HYF"
    case MockTest = "Mock Text"
}


extension View {
    
    func transparentSheet<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        sheet(isPresented: isPresented) {
            ZStack {
                content()
            }
            .background(TransparentBackground())
        }
    }
}

struct TransparentBackground: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}





