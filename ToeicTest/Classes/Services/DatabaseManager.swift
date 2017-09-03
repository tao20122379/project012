//
//  DatabaseManager.swift
//  English3000
//
//  Created by HoangDuoc on 7/20/16.
//  Copyright © 2016 khactao. All rights reserved.
//

import Foundation


class DatabaseManager {
    func queryDatabase(_ dbName: String,executyQuery: String, completionHandler: CompletionHandler) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask , true)
        let documentsDirectory = paths[0]
        let myDatabase = documentsDirectory + "/\(dbName).sqlite"
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: myDatabase) {
            let sourcePath = Bundle.main.path(forResource: dbName, ofType: "sqlite")
            do {
                try fileManager.copyItem(atPath: sourcePath!, toPath: myDatabase)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        let database = FMDatabase(path: myDatabase)
        if !(database.open()) {
            return
        }
        do {
            let resultDatas = try database.executeQuery(executyQuery, values: nil)
            completionHandler(true, resultDatas)
        } catch let error as NSError {
            completionHandler(false, error)
        }
        database.close()
    }
    
    
    // MARK: - LoadData
    func loadBookData(_ dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from book ORDER BY name DESC")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var books = Array<BookModel>()
            while rs.next() {
                let book = BookModel()
                book.id = Int(rs.int(forColumn: "book_id"))
                book.name = rs.string(forColumn: "name")
                book.bookImage = rs.string(forColumn: "book_image")
                book.testNumber = Int(rs.int(forColumn: "test_number"))
                book.direction1 = rs.string(forColumn: "direction1")
                book.direction2 = rs.string(forColumn: "direction2")
                book.imageName = rs.string(forColumn: "direction_image")
                books.append(book)
            }
            completionHandler(true, books as AnyObject)
        }
    }
    
    func loadGrammarModel(_ dbName: String, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from grammar_list WHERE section=%i", sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var listGrammarModels = Array<GrammarModel>()
            while rs.next() {
                let grammarModel = GrammarModel()
                grammarModel.title = rs.string(forColumn: "title")
                grammarModel.content = rs.string(forColumn: "content")
                listGrammarModels.append(grammarModel)
            }
            completionHandler(true, listGrammarModels as AnyObject)
        }
    }

    
    func loadGrammarSection(_ dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from grammar_section")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var grammars = Array<GrammarSection>()
            while rs.next() {
                let grammar = GrammarSection()
                grammar.sectionID = Int(rs.int(forColumn: "section_id"))
                grammar.title = rs.string(forColumn: "title")
                DatabaseManager().loadGrammarModel(dbName, sectionID: grammar.sectionID, completionHandler: { (status, datas) in
                    if status {
                        grammar.listModel = datas as!  Array<GrammarModel>
                    }
                })
                grammars.append(grammar)
            }
            completionHandler(true, grammars as AnyObject)
        }
    }

    func loadTestData(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from test where book_id = %i and test_id = %i" , bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let testData: TestModel = TestModel()
            while rs.next() {
                testData.audioName = rs.string(forColumn: "audio_name")
                testData.imageName = rs.string(forColumn: "image_part1")
                testData.highScore = Int(rs.int(forColumn: "high_score"))
                testData.numberPartData = Int(rs.int(forColumn: "number_part_data"))
            }
            if testData.audioName != nil {
                completionHandler(true, testData)
            }
            else {
                completionHandler(false, testData)
            }
        }
    }
    
    
    func loadPart1Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part1_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part1Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let questionData = Part1Model()
                questionData.bookID = bookID
                questionData.testID = testID
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.answerSelected = 0
                questionData.timeStart = rs.double(forColumn: "time_start")
                questionData.timeEnd = rs.double(forColumn: "time_end")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    func loadPart2Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part2_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part2Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let questionData = Part2Model()
                questionData.bookID = bookID
                questionData.testID = testID
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.answerSelected = 0
                questionData.timeStart = rs.double(forColumn: "time_start")
                questionData.timeEnd = rs.double(forColumn: "time_end")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    func loadPart3Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part3_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            while rs.next() {
                let questionData = Part34Model()
                questionData.sectionID = Int(rs.int(forColumn: "section_id"))
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.question = rs.string(forColumn: "question")
                questionData.answerSelected = 0
                numberArray.shuffle(4)
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
        
    }
    
    func getAnswerName(_ number: Int) -> String {
        switch number {
        case 1:
            return "answerA"
        case 2:
            return "answerB"
        case 3:
            return "answerC"
        case 4:
            return "answerD"
        default:
            return ""
        }
    }
    
    func loadPart4Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part4_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.sectionID = Int(rs.int(forColumn: "section_id"))
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.answerSelected = 0
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                        
                    }
                }

                questionData.question = rs.string(forColumn: "question")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    
    func loadPart5Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part5_data WHERE book_id = %i and test_id = %i", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answerSelected = 0
                questionData.answer = Int(rs.int(forColumn: "answer"))
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                
                questionData.question = rs.string(forColumn: "question")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                resultDatas.shuffle(resultDatas.count)
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    
    func loadPart6DataQuestion(_ dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part6_data_question WHERE book_id = %i and test_id = %i and section_id = %i ORDER BY question_id ASC", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part6QuestionModel>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            while rs.next() {
                let questionData = Part6QuestionModel()
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.answerSelected = 0
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                resultDatas.append(questionData)
            }
            completionHandler(true, resultDatas as AnyObject)
        }
    }
    
    
    func loadPart6Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part6_data_section WHERE book_id = %i and test_id = %i", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part6Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let part6Model = Part6Model()
                part6Model.sectionID = Int(rs.int(forColumn: "section_id"))
                part6Model.title = rs.string(forColumn: "title")
                part6Model.passage1 = rs.string(forColumn: "passage1")
                part6Model.passage2 = rs.string(forColumn: "passage2")
                part6Model.passage3 = rs.string(forColumn: "passage3")
                part6Model.passage4 = rs.string(forColumn: "passage4")
                DatabaseManager().loadPart6DataQuestion("toeic_test", bookID: bookID, testID: testID, sectionID: part6Model.sectionID!, completionHandler: { (state, datas) in
                    if state == true {
                        let questiomArray = datas as! Array<Part6QuestionModel>
                        questiomArray.forEach({ (questionData) in
                            part6Model.questionArray.append(questionData)
                        })
                    }
                })
                resultDatas.append(part6Model)
            }
            resultDatas.shuffle(resultDatas.count)
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    func loadPart7DataQuestion(_ dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part7_data_question WHERE book_id = %i and test_id = %i and section_id = %i ORDER BY question_id ASC", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.int(forColumn: "question_id"))
                questionData.answer = Int(rs.int(forColumn: "answer"))
                questionData.answerSelected = 0
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                questionData.question = rs.string(forColumn: "question")
                resultDatas.append(questionData)
            }
            resultDatas.shuffle(resultDatas.count)
            completionHandler(true, resultDatas as AnyObject)
        }
    }
    
    func loadPart7Data(_ dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part7_data_section WHERE book_id = %i and test_id = %i ORDER BY section_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part7Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let part7Model = Part7Model()
                part7Model.sectionID = Int(rs.int(forColumn: "section_id"))
                part7Model.title = rs.string(forColumn: "title")
                part7Model.passseage1 = rs.string(forColumn: "passeage1")
                part7Model.passseage2 = rs.string(forColumn: "passeage2")

                DatabaseManager().loadPart7DataQuestion("toeic_test", bookID: bookID, testID: testID, sectionID: part7Model.sectionID!, completionHandler: { (state, datas) in
                    if state == true {
                        let questiomArray = datas as! Array<Part34Model>
                        questiomArray.forEach({ (questionDAta) in
                            part7Model.questionArray.append(questionDAta)
                        })
                    }
              
                })
                resultDatas.append(part7Model)
            }
            //resultDatas.shuffle(resultDatas.count)
            let numberSection = resultDatas.count
            var start = 153
            for i in 0..<numberSection {
                resultDatas[i].numberQuestionString = String(format: "%i-%i", start, start + (resultDatas[i].questionArray).count - 1)
                (resultDatas[i].questionArray).forEach({ (data) in
                    data.number = start
                    start = start + 1
                })
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas as AnyObject)
            }
            else {
                completionHandler(false, resultDatas as AnyObject)
            }
        }
    }
    
    func loadExplainPart1(_ dbName: String, bookID: Int, testID: Int, questionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part1_data WHERE book_id = %i and test_id = %i and question_id = %i", bookID, testID, questionID)
        
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let explain = Explain1Model()
            while rs.next() {
                let question = Part34Model()
                
                if rs.string(forColumn: "answerA") != nil {
                    question.answerA = rs.string(forColumn: "answerA")
                }
                if rs.string(forColumn: "answerB") != nil  {
                    question.answerB = rs.string(forColumn: "answerB")
                }
                if rs.string(forColumn: "answerC") != nil {
                    question.answerC = rs.string(forColumn: "answerC")
                }
                if rs.string(forColumn: "answerD") != nil  {
                    question.answerD = rs.string(forColumn: "answerD")
                }
    
                explain.startTime = rs.double(forColumn: "time_start")
                explain.endTime = rs.double(forColumn: "time_end")
                explain.question = question
            }
            completionHandler(true, explain)
        }
        
    }
    
    func loadExplainPart2(_ dbName: String, bookID: Int, testID: Int, questionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part2_data WHERE book_id = %i and test_id = %i and question_id = %i", bookID, testID, questionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let explain = Explain2Model()
            while rs.next() {
                let question = Part34Model()
                question.question = rs.string(forColumn: "question")
                if rs.string(forColumn: "answerA") != nil {
                    question.answerA = rs.string(forColumn: "answerA")
                }
                if rs.string(forColumn: "answerB") != nil  {
                    question.answerB = rs.string(forColumn: "answerB")
                }
                if rs.string(forColumn: "answerC") != nil {
                    question.answerC = rs.string(forColumn: "answerC")
                }
                explain.startTime = rs.double(forColumn: "time_start")
                explain.endTime = rs.double(forColumn: "time_end")
                explain.question = question
            }
            completionHandler(true, explain)
        }
    }
    
    
    func loadExplainPart3(_ dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part3_section WHERE book_id = %i and test_id = %i and section_id = %i", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let explain = Explain34Model()
            while rs.next() {
                explain.passage = rs.string(forColumn: "passage")
                explain.startTime = rs.double(forColumn: "time_start")
                explain.endTime = rs.double(forColumn: "time_end")
            }
            completionHandler(true, explain)
        }
    }
    
    
    func loadExplainPart4(_ dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part4_section WHERE book_id = %i and test_id = %i and section_id = %i", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let explain = Explain34Model()
            while rs.next() {
                explain.title = rs.string(forColumn: "title")
                explain.passage = rs.string(forColumn: "passage")
                explain.startTime = rs.double(forColumn: "time_start")
                explain.endTime = rs.double(forColumn: "time_end")
            }
       
            completionHandler(true, explain)
        }
    }
    
    
    func loadScoreData(_ dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = "SELECT * FROM score_data"
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results = Array<ScoreModel>()
            while rs.next() {
                let scoreData = ScoreModel()
                scoreData.number = Int(rs.int(forColumn: "number"))
                scoreData.scoreListening = Int(rs.int(forColumn: "score_listening"))
                scoreData.scoreReading = Int(rs.int(forColumn: "score_reading"))
                results.append(scoreData)
            }
            completionHandler(true, results as AnyObject)
        }
    }
    
    func loadScoreListenning(_ dbName: String, numberAnswerTrue: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM score_data WHERE number=%i", numberAnswerTrue)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results: Int = 5
            while rs.next() {
                results = Int(rs.int(forColumn: "score_listening"))
            }
            completionHandler(true, results as AnyObject)
        }
    }
    
    func loadScoreReading(_ dbName: String, numberAnswerTrue: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM score_data WHERE number=%i", numberAnswerTrue)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results: Int = 5
            while rs.next() {
                results = Int(rs.int(forColumn: "score_reading"))
            }
            completionHandler(true, results as AnyObject)
        }
    }
    
    
    // MARK: - User
    func checkAccount(_ dbName: String, userName: String, password: String) -> Bool {
        let executyQuery = String(format: "select * from account WHERE user_name = '%@' and password= '%@'", userName, password)
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if rs.string(forColumn: "user_name") != nil {
                    isUser = true
                }
            }
        }
        return isUser
    }
    
    func checkAccountName(_ dbName: String, userName: String) -> Bool {
        let executyQuery = String(format: "select * from account WHERE user_name = '%@'", userName)
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if rs.string(forColumn: "user_name") != nil {
                    isUser = true
                }
            }
        }
        return isUser
    }

    
    func checkAccountSave(_ dbName: String) -> Bool {
        let executyQuery = String(format: "select * from account")
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if Int(rs.int(forColumn: "status")) == 1 {
                    isUser = true
                }
            }
        }
        return isUser
    }
    
    func addUser(_ dbName: String, user: UserModel) {
        if !checkAccountName(dbName, userName: user.name) {
            let executyQuery = String(format: "INSERT INTO account (user_name, password, email, bird_day, status) VALUES ('%@', '%@', '%@', '%@', %i)", user.name, user.password!, user.email!, user.birdDay!, 1)
            self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
                let rs = data as! FMResultSet
                while rs.next() {
                    
                }
            }
        }
    }
    
    func login(_ dbName: String, user: UserModel) {
            let executyQuery = String(format: " UPDATE account SET status = 1 WHERE user_name = '%@'", user.name)
            self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
                let rs = data as! FMResultSet
                while rs.next() {
                    
                }
            }
    }
    
    func logOut(_ dbName: String, user: UserModel) {
        let executyQuery = String(format: " UPDATE account SET status = 0 WHERE user_name='%@'", user.name)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                
            }
        }
    }
    
    func getUserSave(_ dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from account WHERE status = 1")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let user = UserModel()
            while rs.next() {
                user.name = rs.string(forColumn: "user_name")
                if Int(rs.int(forColumn: "sex")) == 0 {
                    user.sex = .male
                }
                else {
                    user.sex = .female
                }
                user.password = rs.string(forColumn: "password")
                user.birdDay = rs.string(forColumn: "bird_day")
                user.email = rs.string(forColumn: "email")
            }
            completionHandler(true, user)
        }
    }
    
    func getUserData(_ dbName: String, userName: String, completionHandler: CompletionHandler){
        let executyQuery = String(format: "select * from account WHERE user_name = '%@'", userName)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let user = UserModel()
            while rs.next() {
                user.name = rs.string(forColumn: "user_name")
                if Int(rs.int(forColumn: "sex")) == 0 {
                    user.sex = .male
                }
                else {
                    user.sex = .female
                }
                user.password = rs.string(forColumn: "password")
                user.birdDay = rs.string(forColumn: "bird_day")
                user.email = rs.string(forColumn: "email")
            }
            completionHandler(true, user)
        }
    }
    
    func updateUserSex(_ dbName: String, sex: Int, email: String){
        let executyQuery = String(format: "UPDATE account SET sex = %i WHERE email='%@'", sex, email)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
            }
        }
    }
    
    func updateUserBirthday(_ dbName: String, birdDay: String, email: String){
        let executyQuery = String(format: "UPDATE account SET bird_day = '%@' WHERE email='%@'", birdDay, email)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
            }
        }
    }
    
    
    
    // MARK: - Experience
    func updateExpertience(_ dbName: String, bookID: Int, testID: Int, part: Int, percent: Double){
        let executyQuery = String(format: "UPDATE test SET percent_part%i = percent_part%i + %f WHERE book_id=%i AND test_id=%i", part, part, percent, bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                
            }
        }
    }
    
    // MARK: - HigtScore
    func updateHighScore(_ dbName: String, bookID: Int, testID: Int, score: Int){
        let executyQuery = String(format: "UPDATE test SET high_score = %i WHERE book_id=%i AND test_id=%i", score, bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
            }
            Constants.testData?.highScore = score
        }
    }
    
    
    // MARK: - Random Question
    
    func randomPart1Data() -> RandomModel {
        var books: Array<BookModel>?
        loadBookData(Constants.databaseName) { (status, datas) in
            if status {
                books = datas as? Array<BookModel>
            }
        }
        let bookNumber = books?.count
        let bookRandom = Int(arc4random_uniform(UInt32(bookNumber!)))
        let bookID = books![bookRandom].id
        let testNumber = books![bookRandom].testNumber
        let testID = Int(arc4random_uniform(UInt32(testNumber!)))+1
        let questionID = Int(arc4random_uniform(UInt32(10)))+1
        let randomObject: RandomModel = RandomModel()
        randomObject.bookID = bookID
        randomObject.testID = testID
        randomObject.questionID = questionID
        randomObject.id = bookID!*100+testID*1+questionID-111
        return randomObject
    }
    
    
    func randomPart2Data() -> RandomModel {
        var books: Array<BookModel>?
        loadBookData(Constants.databaseName) { (status, datas) in
            if status {
                books = datas as? Array<BookModel>
            }
        }
        let bookNumber = books?.count
        let bookRandom = Int(arc4random_uniform(UInt32(bookNumber!)))
        let bookID = books![bookRandom].id
        let testNumber = books![bookRandom].testNumber
        let testID = Int(arc4random_uniform(UInt32(testNumber!)))+1
        let questionID = Int(arc4random_uniform(UInt32(30)))+1
        let randomObject: RandomModel = RandomModel()
        randomObject.bookID = bookID
        randomObject.testID = testID
        randomObject.questionID = questionID
        randomObject.id = bookID!*1000+testID*100+questionID-1100
        return randomObject
    }
    
    
    func randomPart34Data() -> RandomModel {
        var books: Array<BookModel>?
        loadBookData(Constants.databaseName) { (status, datas) in
            if status {
                books = datas as? Array<BookModel>
            }
        }
        let bookNumber = books?.count
        let bookRandom = Int(arc4random_uniform(UInt32(bookNumber!)))
        let bookID = books![bookRandom].id
        let testNumber = books![bookRandom].testNumber
        let testID = Int(arc4random_uniform(UInt32(testNumber!)))+1
        let sectionID = Int(arc4random_uniform(UInt32(10)))+1
        let randomObject: RandomModel = RandomModel()
        randomObject.bookID = bookID
        randomObject.testID = testID
        randomObject.sectionID = sectionID
        randomObject.id = bookID!*100+testID*1+sectionID-111
        return randomObject
    }
    
    
    
    func getQuestionDataPart1Random(_ random: RandomModel) -> Part1Model {
        let executyQuery = String(format: "SELECT * FROM part1_data WHERE book_id = %i and test_id = %i and question_id = %i", random.bookID, random.testID, random.questionID)
        let question = Part1Model()
        self.queryDatabase(Constants.databaseName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                question.bookID = random.bookID
                question.testID = random.testID
                question.questionID = random.questionID
                question.answer = Int(rs.int(forColumn: "answer"))
                question.timeStart = rs.double(forColumn: "time_start")
                question.timeEnd = rs.double(forColumn: "time_end")
                question.answerSelected = 0
            }
        }
        return question
     }
    
    func getQuestionDataPart2Random(_ random: RandomModel) -> Part2Model {
        let executyQuery = String(format: "SELECT * FROM part2_data WHERE book_id = %i and test_id = %i and question_id = %i", random.bookID, random.testID, random.questionID)
        let question = Part2Model()
        self.queryDatabase(Constants.databaseName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            while rs.next() {
                question.bookID = random.bookID
                question.testID = random.testID
                question.questionID = random.questionID
                question.answer = Int(rs.int(forColumn: "answer"))
                question.timeStart = rs.double(forColumn: "time_start")
                question.timeEnd = rs.double(forColumn: "time_end")
                question.answerSelected = 0
            }
        }
        return question
    }
    
    func getQuestionDataPart3Random(_ random: RandomModel) -> Part34SectionModel {
        let executyQuery = String(format: "SELECT * FROM part3_data WHERE book_id = %i and test_id = %i and section = %i", random.bookID, random.testID, random.sectionID)
        let part3Section = Part34SectionModel()
        part3Section.bookID = random.bookID
        part3Section.testID = random.testID
        part3Section.sectionID = random.sectionID
        self.queryDatabase(Constants.databaseName, executyQuery: executyQuery) { (state, data) in
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            let rs = data as! FMResultSet
            while rs.next() {
                let question = Part34Model()
                question.questionID = random.questionID
                question.sectionID = Int(rs.int(forColumn: "section_id"))
                question.answer = Int(rs.int(forColumn: "answer"))
                question.question = rs.string(forColumn: "question")
                question.answerSelected = 0
                numberArray.shuffle(4)
                for i in 0..<numberArray.count {
                    if numberArray[i] == question.answer {
                        question.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        question.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        question.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        question.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        question.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                part3Section.questionArray.append(question)
            }
        }
        return part3Section
    }
    
    
    func getQuestionDataPart4Random(_ random: RandomModel) -> Array<Part34Model> {
        let executyQuery = String(format: "SELECT * FROM part4_data WHERE book_id = %i and test_id = %i and section = %i", random.bookID, random.testID, random.sectionID)
        var questions = Array<Part34Model>()
        self.queryDatabase(Constants.databaseName, executyQuery: executyQuery) { (state, data) in
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            let rs = data as! FMResultSet
            while rs.next() {
                let question = Part34Model()
                question.questionID = random.questionID
                question.sectionID = Int(rs.int(forColumn: "section_id"))
                question.answer = Int(rs.int(forColumn: "answer"))
                question.question = rs.string(forColumn: "question")
                question.answerSelected = 0
                numberArray.shuffle(4)
                for i in 0..<numberArray.count {
                    if numberArray[i] == question.answer {
                        question.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        question.answerA = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        question.answerB = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        question.answerC = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        question.answerD = rs.string(forColumn: self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                questions.append(question)
            }
        }
        return questions
    }
    
    
}


