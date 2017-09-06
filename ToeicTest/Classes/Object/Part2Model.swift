//
//  Part2QuestionModel.swift
//  ToeicTest
//
//  Created by khactao on 1/11/17.
//
//

import Foundation


class Part2Model: NSObject {
    //MARK: - Variable
    var bookID: Int!
    var testID: Int!
    var questionID: Int!
    var answer: Int!
    var number: Int!
    var answerSelected: Int = 0
    var timeStart: Double?
    var timeEnd: Double?
}
