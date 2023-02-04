//
//  URL+Extension.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import Foundation

extension URL {
 
    static func getUserDetails() -> URL? {
        return URL(string: "\(K.baseURL)user/get-details")
    }
    
    static func user(mobileNumber: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/user/\(mobileNumber)/")
    }
    
    static func updateUserDetails() -> URL? {
        return URL(string: "\(K.baseURL)user/update-details")
    }
    
    static func getSession(phoneNumber: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/sessions/\(phoneNumber)")
    }

    static func getChatBot() -> URL? {
        return URL(string: "https://chatbot.mbbscare.in/webhooks/rest/webhook")
    }
    
    static func getChatBotFavIcon() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getpa")
    }
    
    static func getRightWrongQuestions(phoneNumber: String, isRightQuestion: Bool) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getwrongrightquestions/\(phoneNumber)/\(isRightQuestion ? "1" : "0")/1")
    }
    
    static func getShyfRightWrongQuestions(phoneNumber: String, category: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getwrongrightquestionshyf/\(phoneNumber)/\(category)/1")
    }
    
    static func getVimeoVideoLink(vimeoId: String) -> URL? {
        return URL(string: "https://api.vimeo.com/me/videos/\(vimeoId)")
    }
    
    static func getMockTestList(phoneNumber: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getusergtlist/\(phoneNumber)")
    }
    
    static func getMockTestQuestions(phoneNumber: String, mockTestID: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getusergtdetail/\(phoneNumber)/\(mockTestID)")
    }
    
    static func deleteAllData(phoneNumber: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/user/\(phoneNumber)")
    }
    
    static func getSubjects() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getsubjectswithvideos")
    }
    
    static func getSubjectsWithPPT() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getsubjectswithppt")
    }
 
    static func getHyfID(subjectID: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getquestionswithvideoshyf/\(subjectID)")
    }
    
    static func getQuestionHYF(subjectID: String, hyfID: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getquestionhyf/\(subjectID)/\(hyfID)")
    }
    
    static func getQuestionsWithPPT(subjectID: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getquestionswithppthyf/\(subjectID)")
    }
    
    static func getQuestionPPT(subjectID: String, id: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getquestionhyf/\(subjectID)/\(id)")
    }
    
    static func getMockTests(mobileNumber: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/getgtlist/\(mobileNumber)/?mode=gt")
    }
    
    static func getSubjectTests() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/getsubjectslist/")
    }
    
    static func getGtList(userId: String, gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getusergtlist/\(userId)/\(gtId)")
    }
    
    static func getGtAnalysis(userId: String, gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/gtanalysis/\(userId)/\(gtId)")
    }
    
    static func getStAnalysis(userId: String, stId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/stanalysis/\(userId)/\(stId)")
    }
    
    static func getGtLeaderboard(gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getgtleaderboard/?gt=\(gtId)")
    }
    
    static func getGtSubjectMock(userId: String, gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/getgtofasubject/\(gtId)/\(userId)/")
    }
    
    static func getUserGtDetail(userId: String, questionId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getusergtdetail/\(userId)/\(questionId)")
    }
    
    static func getGtTimerDetail(userId: String, gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getusergtouterdetails/\(userId)/\(gtId)/")
    }
    
    static func getQuestionsList(userId: String, gtId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/getquestionslist/\(userId)/\(gtId)/")
    }
    
    static func getQuestion(questionId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/getaquestion/\(questionId)")
    }
    
    static func updateQuestionLastSeen() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/updategtlastseen/")
    }
    
    static func createGtRecord() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/creategtrecord/")
    }
    
    static func getNotesList(userId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getnotessubjects/\(userId)/")
    }
    
    static func getNotesQuestionsList(userId: String, subjectId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/getnotesbindata/\(userId)/\(subjectId)/")
    }
    
    static func getNotesOfSubjectList(subjectId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getnotesofsubject/\(subjectId)")
    }
    
    static func getNoteQuestionData(subjectId: String, questionId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/getquestionhyf/\(subjectId)/\(questionId)")
    }
    
    static func updateNoteLastSeen() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/updatelastseennotes/")
    }
    
    static func topicWiseAnalysis(userId: String, subjectId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/topicwiseanalysis/\(userId)/\(subjectId)/")
    }
    
    static func grandTestAudio(audioId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/audio/\(audioId)/")
    }
    
    static func notesTestAudio(audioId: String) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/audio/\(audioId)/")
    }
    
    static func grandtestAudioCreate() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/audio/")
    }
    
    static func noteTestAudioCreate() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/audio/")
    }
    
    static func searchNotes() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/data/searchhyf")
    }
    
    static func searchMockTest() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/grandtest/searchquestion")
    }
    
    static func getSearchHistory(id: String? = nil) -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/index/\(id != nil ? "\(id ?? "")/" : "")")
    }
    
    static func blockStatus() -> URL? {
        return URL(string: "https://chatbot-backend.mbbscare.in/progress/blockstatus/")
    }
}
