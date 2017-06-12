//
//  Part6Model.swift
//  ToeicTest
//
//  Created by khactao on 3/26/17.
//
//

import Foundation

class Part6Model: NSObject {
    var sectionID: Int!
    var questionArray = Array<Part6QuestionModel>()
    var title: String! 
    var passage1: String! = ""
    var passage2: String! = ""
    var passage3: String! = ""
    var passage4: String! = ""
}