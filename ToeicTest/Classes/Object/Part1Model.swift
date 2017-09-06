//
//  Part1QuestionModel.swift
//  ToeicTest
//
//  Created by khactao on 1/5/17.
//
//

import Foundation


class Part1Model: NSObject {
    //MARK: - Variable
    var bookID: Int!
    var testID: Int!
    var questionID: Int!
    var answer: Int!
    var number: Int!
    var answerSelected: Int = 0
    var imageName: String = ""
    var timeStart: Double?
    var timeEnd: Double?
}
