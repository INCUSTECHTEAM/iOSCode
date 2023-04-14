//
//  URL+Extension.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import Foundation

extension URL {
    
    
    
    static func getUserDetails() -> URL? {
        return URL(string: "https://vongo.incusquiz.com/vongo/user/get-details")
    }
    
    static func user(mobileNumber: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/user/\(mobileNumber)/")
    }
    
    static func updateUserDetails() -> URL? {
        return URL(string: "https://vongo.incusquiz.com/vongo/user/update-details")
    }
    
    static func getSession(phoneNumber: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/sessions/\(phoneNumber)")
    }

    static func getChatBot() -> URL? {
        return URL(string: "https://chatbot.mbbscare.in/webhooks/rest/webhook")
    }
    
    static func getChatBotFavIcon() -> URL? {
        return URL(string: "\(K.baseURL)data/getpa")
    }
    
    static func getRightWrongQuestions(phoneNumber: String, isRightQuestion: Bool) -> URL? {
        return URL(string: "\(K.baseURL)progress/getwrongrightquestions/\(phoneNumber)/\(isRightQuestion ? "1" : "0")/1")
    }
    
    static func getShyfRightWrongQuestions(phoneNumber: String, category: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getwrongrightquestionshyf/\(phoneNumber)/\(category)/1")
    }
    
    static func getVimeoVideoLink(vimeoId: String) -> URL? {
        return URL(string: "https://api.vimeo.com/me/videos/\(vimeoId)")
    }
    
    static func getMockTestList(phoneNumber: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getusergtlist/\(phoneNumber)")
    }
    
    static func getMockTestQuestions(phoneNumber: String, mockTestID: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getusergtdetail/\(phoneNumber)/\(mockTestID)")
    }
    
    static func deleteAllData(phoneNumber: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/user/\(phoneNumber)")
    }
    
    static func getSubjects() -> URL? {
        return URL(string: "\(K.baseURL)data/getsubjectswithvideos")
    }
    
    static func getSubjectsWithPPT() -> URL? {
        return URL(string: "\(K.baseURL)data/getsubjectswithppt")
    }
 
    static func getHyfID(subjectID: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getquestionswithvideoshyf/\(subjectID)")
    }
    
    static func getQuestionHYF(subjectID: String, hyfID: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getquestionhyf/\(subjectID)/\(hyfID)")
    }
    
    static func getQuestionsWithPPT(subjectID: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getquestionswithppthyf/\(subjectID)")
    }
    
    static func getQuestionPPT(subjectID: String, id: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getquestionhyf/\(subjectID)/\(id)")
    }
    
    static func getMockTests(mobileNumber: String) -> URL? {
        return URL(string: "\(K.baseURL)grandtest/getgtlist/\(mobileNumber)/?mode=gt")
    }
    
    static func getSubjectTests() -> URL? {
        return URL(string: "\(K.baseURL)grandtest/getsubjectslist/")
    }
    
    static func getQBStep1SubjectTests() -> URL? {
        return URL(string: "https://usmle-backend.mbbscare.in/grandtest/getsubjectslist/")
    }
    
    static func getQBStep2SubjectTests() -> URL? {
        return URL(string: "https://usmle-2-backend.mbbscare.in/grandtest/getsubjectslist/")
    }
    
    static func getGtList(userId: String, gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getusergtlist/\(userId)/\(gtId)")
    }
    
    static func getGtAnalysis(userId: String, gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/gtanalysis/\(userId)/\(gtId)")
    }
    
    static func getStAnalysis(userId: String, stId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/stanalysis/\(userId)/\(stId)")
    }
    
    static func getGtLeaderboard(gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getgtleaderboard/?gt=\(gtId)")
    }
    
    static func getGtSubjectMock(userId: String, gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)grandtest/getgtofasubject/\(gtId)/\(userId)/")
    }
    
    static func getUserGtDetail(userId: String, questionId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getusergtdetail/\(userId)/\(questionId)")
    }
    
    static func getGtTimerDetail(userId: String, gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getusergtouterdetails/\(userId)/\(gtId)/")
    }
    
    static func getQuestionsList(userId: String, gtId: String) -> URL? {
        return URL(string: "\(K.baseURL)grandtest/getquestionslist/\(userId)/\(gtId)/")
    }
    
    static func getQuestion(questionId: String) -> URL? {
        return URL(string: "\(K.baseURL)grandtest/getaquestion/\(questionId)")
    }
    
    static func updateQuestionLastSeen() -> URL? {
        return URL(string: "\(K.baseURL)progress/updategtlastseen/")
    }
    
    static func createGtRecord() -> URL? {
        return URL(string: "\(K.baseURL)progress/creategtrecord/")
    }
    
    static func getNotesList(userId: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getnotessubjects/\(userId)/")
    }
    
    static func getNotesQuestionsList(userId: String, subjectId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getnotesbindata/\(userId)/\(subjectId)/")
    }
    
    static func getAudioMantraQuestionList(userId: String, subjectId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/getaudiosbindata/\(userId)/\(subjectId)")
    }
    
    static func getNotesOfSubjectList(subjectId: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getnotesofsubject/\(subjectId)")
    }
    
    static func getNoteQuestionData(subjectId: String, questionId: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getquestionhyf/\(subjectId)/\(questionId)")
    }
    
    static func updateNoteLastSeen() -> URL? {
        return URL(string: "\(K.baseURL)progress/updatelastseennotes/")
    }
    
    static func updateAudioMantraLastSeen() -> URL? {
        return URL(string: "\(K.baseURL)progress/updatelastseenaudio/")
    }
    
    static func topicWiseAnalysis(userId: String, subjectId: String) -> URL? {
        return URL(string: "\(K.baseURL)progress/topicwiseanalysis/\(userId)/\(subjectId)/")
    }
    
    static func grandTestAudio(audioId: String) -> URL? {
        return URL(string: "\(K.baseURL)grandtest/audio/\(audioId)/")
    }
    
    static func notesTestAudio(audioId: String) -> URL? {
        return URL(string: "\(K.baseURL)data/audio/\(audioId)/")
    }
    
    static func grandtestAudioCreate() -> URL? {
        return URL(string: "\(K.baseURL)grandtest/audio/")
    }
    
    static func noteTestAudioCreate() -> URL? {
        return URL(string: "\(K.baseURL)data/audio/")
    }
    
    static func searchNotes() -> URL? {
        return URL(string: "\(K.baseURL)data/searchhyf")
    }
    
    static func searchMockTest() -> URL? {
        return URL(string: "\(K.baseURL)grandtest/searchquestion")
    }
    
    static func getSearchHistory(id: String? = nil) -> URL? {
        return URL(string: "\(K.baseURL)progress/index/\(id != nil ? "\(id ?? "")/" : "")")
    }
    
    static func blockStatus() -> URL? {
        return URL(string: "\(K.baseURL)progress/blockstatus/")
    }
    
    static func noteQuestionReport() -> URL? {
        return URL(string: "\(K.baseURL)progress/report/")
    }
    
    static func audioMantraList(userId: String) -> URL? {
        return URL(string: "\(K.baseURL)data/getaudiossubjects/\(userId)")
    }
}
