//
//  Part34SectionModel.swift
//  ToeicTest
//
//  Created by khactao on 9/3/17.
//
//

import Foundation

class Part34SectionModel: NSObject {
    //MARK: - Variable
    var bookID: Int!
    var testID: Int!
    var sectionID: Int!
    var part: Int!
    var timeStart: Double!
    var timeEnd: Double!
    var questionArray = Array<Part34Model>()
    var audioName: String = ""
}
