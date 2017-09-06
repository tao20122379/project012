//
//  Part6QuestionModel.swift
//  ToeicTest
//
//  Created by khactao on 3/28/17.
//
//

import Foundation

class Part6QuestionModel: NSObject {
    //MARK: - Variable
    var questionID: Int!
    var number: Int!
    var answer: Int!
    var answerSelected: Int = 0
    var passage1: String!
    var passage2: String?
    var answerA: String!
    var answerB: String!
    var answerC: String!
    var answerD: String!
}
