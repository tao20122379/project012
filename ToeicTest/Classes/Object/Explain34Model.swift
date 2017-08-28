//
//  Explain3Model.swift
//  ToeicTest
//
//  Created by khactao on 3/30/17.
//
//

import Foundation

class Explain34Model: NSObject {
    var id: Int!
    var number: Int!
    var part: Int!
    var title: String! = ""
    var startTime: Double!
    var endTime: Double!
    var passage: String!
    var questionArray = Array<Part34Model>()
    var audioName: String = ""
}