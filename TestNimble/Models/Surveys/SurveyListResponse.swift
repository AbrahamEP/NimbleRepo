//
//  SurveyListResponse.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 07/11/23.
//

import Foundation

struct SurveyListResponseData: Codable {
    var data: [SurveyListResponse]
}

struct SurveyListResponse: Codable {
    var id: String
    var type: String
    var attributes: Attributes
    var relationships: Relationships?
    
    struct Attributes: Codable {
        var title: String
        var description: String
        var thankEmailAboveThreshold: String?
        var thankEmailBelowThreshold: String?
        var isActive: Bool
        var coverImageURL: String?
        var createdAt: String
        var activeAt: String
        var inactiveAt: String?
        var surveyType: String
    }
    
    struct Relationships: Codable {
        var questions: QuestionData
        
        struct QuestionData: Codable {
            var data: [Question]?
        }
        
        struct Question: Codable {
            var id: String
            var type: String
        }
    }
}
