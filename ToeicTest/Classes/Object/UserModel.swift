//
//  UserModel.swift
//  ToeicTest
//
//  Created by khactao on 5/3/17.
//
//

import Foundation

class UserModel: NSObject {
    var id: Int!
    var name: String! = ""
    var sex: Sex = .male
    var email: String! = ""
    var password: String! = ""
    var birdDay: String! = ""


}