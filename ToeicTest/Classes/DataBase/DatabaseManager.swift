//
//  DatabaseManager.swift
//  English3000
//
//  Created by HoangDuoc on 7/20/16.
//  Copyright © 2016 khactao. All rights reserved.
//

import Foundation


class DatabaseManager {
    
    func queryDatabase(dbName: String,executyQuery: String, completionHandler: CompletionHandler) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)
        let documentsDirectory = paths[0]
        let myDatabase = documentsDirectory.stringByAppendingString("/\(dbName).sqlite")
        let fileManager = NSFileManager()
        if !fileManager.fileExistsAtPath(myDatabase) {
            let sourcePath = NSBundle.mainBundle().pathForResource(dbName, ofType: "sqlite")
            do {
                try fileManager.copyItemAtPath(sourcePath!, toPath: myDatabase)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        let database = FMDatabase(path: myDatabase)
        if !database.open() {
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
    func loadBookData(dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from book ORDER BY name DESC")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var books = Array<BookModel>()
            while rs.next() {
                let book = BookModel()
                book.id = Int(rs.intForColumn("book_id"))
                book.name = rs.stringForColumn("name")
                book.bookImage = rs.stringForColumn("book_image")
                book.testNumber = Int(rs.intForColumn("test_number"))
                book.direction1 = rs.stringForColumn("direction1")
                book.direction2 = rs.stringForColumn("direction2")
                book.imageName = rs.stringForColumn("direction_image")
                books.append(book)
            }
            completionHandler(true, books)
        }
    }
    
    func loadGrammarModel(dbName: String, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from grammar_list WHERE section=%i", sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var listGrammarModels = Array<GrammarModel>()
            while rs.next() {
                let grammarModel = GrammarModel()
                grammarModel.title = rs.stringForColumn("title")
                grammarModel.content = rs.stringForColumn("content")
                listGrammarModels.append(grammarModel)
            }
            completionHandler(true, listGrammarModels)
        }
    }

    
    func loadGrammarSection(dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from grammar_section")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var grammars = Array<GrammarSection>()
            while rs.next() {
                let grammar = GrammarSection()
                grammar.sectionID = Int(rs.intForColumn("section_id"))
                grammar.title = rs.stringForColumn("title")
                DatabaseManager().loadGrammarModel(dbName, sectionID: grammar.sectionID, completionHandler: { (status, datas) in
                    if status {
                        grammar.listModel = datas as!  Array<GrammarModel>
                    }
                })
                grammars.append(grammar)
            }
            completionHandler(true, grammars)
        }
    }

    func loadTestData(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from test where book_id = %i and test_id = %i" , bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let testData: TestModel = TestModel()
            while rs.next() {
                testData.audioName = rs.stringForColumn("audio_name")
                testData.imageName = rs.stringForColumn("img_name")
                testData.highScore = Int(rs.intForColumn("high_score"))
                testData.numberPartData = Int(rs.intForColumn("number_part_data"))
                testData.percent_part1 =  CGFloat(rs.doubleForColumn("percent_part1"))
                testData.percent_part2 =  CGFloat(rs.doubleForColumn("percent_part2"))
                testData.percent_part3 =  CGFloat(rs.doubleForColumn("percent_part3"))
                testData.percent_part4 =  CGFloat(rs.doubleForColumn("percent_part4"))
                testData.percent_part5 =  CGFloat(rs.doubleForColumn("percent_part5"))
                testData.percent_part6 =  CGFloat(rs.doubleForColumn("percent_part6"))
                testData.percent_part7 =  CGFloat(rs.doubleForColumn("percent_part7"))
            }
            if testData.audioName != nil {
                    completionHandler(true, testData)
            }
            else {
                 completionHandler(false, testData)
            }
        }
    }
    
    
    func loadPart1Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part1_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part1Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let question = Part1Model()
                question.questionID = Int(rs.intForColumn("question_id"))
                question.answer = Int(rs.intForColumn("answer"))
                question.answerSelected = 0
                resultDatas.append(question)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
        
    }
    
    func loadPart2Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part2_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part2Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let questionData = Part2Model()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answer = Int(rs.intForColumn("answer"))
                questionData.answerSelected = 0
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
    }
    
    func loadPart3Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part3_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answer = Int(rs.intForColumn("answer"))
                questionData.question = rs.stringForColumn("question")
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
                        questionData.answerA = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                
                }
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
        
    }
    
    func getAnswerName(number: Int) -> String {
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
    
    func loadPart4Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part4_data WHERE book_id = %i and test_id = %i ORDER BY question_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answer = Int(rs.intForColumn("answer"))
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
                        questionData.answerA = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                        
                    }
                }

                questionData.question = rs.stringForColumn("question")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
    }
    
    
    func loadPart5Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part5_data WHERE book_id = %i and test_id = %i", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answerSelected = 0
                questionData.answer = Int(rs.intForColumn("answer"))
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                    }
                }
                
                questionData.question = rs.stringForColumn("question")
                resultDatas.append(questionData)
            }
            if resultDatas.count > 0 {
                resultDatas.shuffle(resultDatas.count)
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
    }
    
    
    func loadPart6DataQuestion(dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part6_data_question WHERE book_id = %i and test_id = %i and section_id = %i ORDER BY question_id ASC", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part6QuestionModel>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            while rs.next() {
                let questionData = Part6QuestionModel()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answer = Int(rs.intForColumn("answer"))
                questionData.answerSelected = 0
                questionData.passage1 = rs.stringForColumn("passage1")
                questionData.passage2 = rs.stringForColumn("passage2")
                for i in 0..<numberArray.count {
                    if numberArray[i] == questionData.answer {
                        questionData.answer = i+1
                        break
                    }
                }
                for i in 0..<numberArray.count {
                    switch i {
                    case 0:
                        questionData.answerA = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                        
                    }
                }
                resultDatas.append(questionData)
            }
            completionHandler(true, resultDatas)
        }
    }
    
    
    func loadPart6Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part6_data_section WHERE book_id = %i and test_id = %i", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part6Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let part6Model = Part6Model()
                part6Model.sectionID = Int(rs.intForColumn("section_id"))
                part6Model.title = rs.stringForColumn("title")
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
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
    }
    
    func loadPart7DataQuestion(dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part7_data_question WHERE book_id = %i and test_id = %i and section_id = %i ORDER BY question_id ASC", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part34Model>()
            let rs = data as! FMResultSet
            var numberArray: Array = Array<Int>()
            numberArray = [1,2,3,4]
            numberArray.shuffle(4)
            while rs.next() {
                let questionData = Part34Model()
                questionData.questionID = Int(rs.intForColumn("question_id"))
                questionData.answer = Int(rs.intForColumn("answer"))
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
                        questionData.answerA = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 1:
                        questionData.answerB = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 2:
                        questionData.answerC = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    case 3:
                        questionData.answerD = rs.stringForColumn(self.getAnswerName(numberArray[i]))
                        break
                    default:
                        break
                        
                    }
                }
                
                questionData.question = rs.stringForColumn("question")
                resultDatas.append(questionData)
            }
            resultDatas.shuffle(resultDatas.count)
            completionHandler(true, resultDatas)
        }
    }
    
    func loadPart7Data(dbName: String, bookID: Int, testID: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM part7_data_section WHERE book_id = %i and test_id = %i ORDER BY section_id ASC", bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            var resultDatas = Array<Part7Model>()
            let rs = data as! FMResultSet
            while rs.next() {
                let part7Model = Part7Model()
                part7Model.sectionID = Int(rs.intForColumn("section_id"))
                part7Model.title = rs.stringForColumn("title")
                part7Model.passseage1 = rs.stringForColumn("passeage1")
                part7Model.passseage2 = rs.stringForColumn("passeage2")

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
                completionHandler(true, resultDatas)
            }
            else {
                completionHandler(false, resultDatas)
            }
        }
    }
    
    func loadExplainPart1(dbName: String, bookID: Int, testID: Int, questionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part1_data WHERE book_id = %i and test_id = %i and question_id = %i", bookID, testID, questionID)
        
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let explain = Explain1Model()
            while rs.next() {
                let question = Part34Model()
                if rs.stringForColumn("answerA") != nil {
                    question.answerA = rs.stringForColumn("answerA")
                }
                if rs.stringForColumn("answerB") != nil  {
                    question.answerB = rs.stringForColumn("answerB")
                }
                if rs.stringForColumn("answerC") != nil {
                    question.answerC = rs.stringForColumn("answerC")
                }
                if rs.stringForColumn("answerD") != nil  {
                    question.answerD = rs.stringForColumn("answerD")
                }
    
                explain.startTime = rs.doubleForColumn("time_start")
                explain.endTime = rs.doubleForColumn("time_end")
                explain.question = question
                
                explain.imageName = BaseViewController.iamgeName! + String(format: "%i", questionID)
            }
            completionHandler(true, explain)
        }
        
    }
    
    func loadExplainPart2(dbName: String, bookID: Int, testID: Int, questionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part2_data WHERE book_id = %i and test_id = %i and question_id = %i", bookID, testID, questionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            
            let rs = data as! FMResultSet
            let explain = Explain2Model()
            while rs.next() {
                let question = Part34Model()
                question.question = rs.stringForColumn("question")
                if rs.stringForColumn("answerA") != nil {
                    question.answerA = rs.stringForColumn("answerA")
                }
                if rs.stringForColumn("answerB") != nil  {
                    question.answerB = rs.stringForColumn("answerB")
                }
                if rs.stringForColumn("answerC") != nil {
                    question.answerC = rs.stringForColumn("answerC")
                }
                if rs.stringForColumn("answerD") != nil  {
                    question.answerD = rs.stringForColumn("answerD")
                }
                explain.startTime = rs.doubleForColumn("start_time")
                explain.endTime = rs.doubleForColumn("end_time")
                explain.question = question
            }
            completionHandler(true, explain)
        }
    }
    
    
    func loadExplainPart3(dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part3_section WHERE book_id = %i and test_id = %i and section_id = %i", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let explain = Explain34Model()
            while rs.next() {
                explain.passage = rs.stringForColumn("passage")
                explain.startTime = rs.doubleForColumn("time_start")
                explain.endTime = rs.doubleForColumn("time_end")
            }
            for i in 0..<3 {
                let question = TestViewController.questionPar3List[(sectionID-1)*3+i]
                question.number = 40+(sectionID-1)*3+i+1
                explain.questionArray.append(question)
            }
            completionHandler(true, explain)
        }
    }
    
    
    func loadExplainPart4(dbName: String, bookID: Int, testID: Int, sectionID: Int, completionHandler: CompletionHandler) {
        
        let executyQuery = String(format: "SELECT * FROM explain_part4_section WHERE book_id = %i and test_id = %i and section_id = %i", bookID, testID, sectionID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let explain = Explain34Model()
            while rs.next() {
                explain.title = rs.stringForColumn("title")
                explain.passage = rs.stringForColumn("passage")
                explain.startTime = rs.doubleForColumn("time_start")
                explain.endTime = rs.doubleForColumn("time_end")
            }
            for i in 0..<3 {
                let question = TestViewController.questionPar4List[(sectionID-1)*3+i]
                question.number = 70+(sectionID-1)*3+i+1
                explain.questionArray.append(question)
            }
            completionHandler(true, explain)
        }
    }
    
    
    func loadScoreData(dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = "SELECT * FROM score_data"
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results = Array<ScoreModel>()
            while rs.next() {
                let scoreData = ScoreModel()
                scoreData.number = Int(rs.intForColumn("number"))
                scoreData.scoreListening = Int(rs.intForColumn("score_listening"))
                scoreData.scoreReading = Int(rs.intForColumn("score_reading"))
                results.append(scoreData)
            }
            completionHandler(true, results)
        }
    }
    
    func loadScoreListenning(dbName: String, numberAnswerTrue: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM score_data WHERE number=%i", numberAnswerTrue)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results: Int = 5
            while rs.next() {
                results = Int(rs.intForColumn("score_listening"))
            }
            completionHandler(true, results)
        }
    }
    
    func loadScoreReading(dbName: String, numberAnswerTrue: Int, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "SELECT * FROM score_data WHERE number=%i", numberAnswerTrue)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            var results: Int = 5
            while rs.next() {
                results = Int(rs.intForColumn("score_reading"))
            }
            completionHandler(true, results)
        }
    }
    
    
    // MARK: - User
    func checkAccount(dbName: String, userName: String, password: String) -> Bool {
        let executyQuery = String(format: "select * from account WHERE user_name = '%@' and password= '%@'", userName, password)
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if rs.stringForColumn("user_name") != nil {
                    isUser = true
                }
            }
        }
        return isUser
    }
    
    func checkAccountName(dbName: String, userName: String) -> Bool {
        let executyQuery = String(format: "select * from account WHERE user_name = '%@'", userName)
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if rs.stringForColumn("user_name") != nil {
                    isUser = true
                }
            }
        }
        return isUser
    }

    
    func checkAccountSave(dbName: String) -> Bool {
        let executyQuery = String(format: "select * from account")
        var isUser: Bool = false
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                if Int(rs.intForColumn("status")) == 1 {
                    isUser = true
                }
            }
        }
        return isUser
    }
    
    func addUser(dbName: String, user: UserModel) {
        if !checkAccountName(dbName, userName: user.name) {
            let executyQuery = String(format: "INSERT INTO account (user_name, password, email, bird_day, status) VALUES ('%@', '%@', '%@', '%@', %i)", user.name, user.password!, user.email!, user.birdDay!, 1)
            self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
                let rs = data as! FMResultSet
                while rs.next() {
                    
                }
            }
        }
    }
    
    func login(dbName: String, user: UserModel) {
            let executyQuery = String(format: " UPDATE account SET status = 1 WHERE user_name = '%@'", user.name)
            self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
                let rs = data as! FMResultSet
                while rs.next() {
                    
                }
            }
    }
    
    func logOut(dbName: String, user: UserModel) {
        let executyQuery = String(format: " UPDATE account SET status = 0 WHERE user_name='%@'", user.name)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                
            }
        }
    }
    
    func getUserSave(dbName: String, completionHandler: CompletionHandler) {
        let executyQuery = String(format: "select * from account WHERE status = 1")
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let user = UserModel()
            while rs.next() {
                user.name = rs.stringForColumn("user_name")
                if Int(rs.intForColumn("sex")) == 0 {
                    user.sex = .male
                }
                else {
                    user.sex = .female
                }
                user.password = rs.stringForColumn("password")
                user.birdDay = rs.stringForColumn("bird_day")
                user.email = rs.stringForColumn("email")
            }
            completionHandler(true, user)
        }
    }
    
    func getUserData(dbName: String, userName: String, completionHandler: CompletionHandler){
        let executyQuery = String(format: "select * from account WHERE user_name = '%@'", userName)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            let user = UserModel()
            while rs.next() {
                user.name = rs.stringForColumn("user_name")
                if Int(rs.intForColumn("sex")) == 0 {
                    user.sex = .male
                }
                else {
                    user.sex = .female
                }
                user.password = rs.stringForColumn("password")
                user.birdDay = rs.stringForColumn("bird_day")
                user.email = rs.stringForColumn("email")
            }
            completionHandler(true, user)
        }
    }
    
    func updateUserSex(dbName: String, sex: Int, email: String){
        let executyQuery = String(format: "UPDATE account SET sex = %i WHERE email='%@'", sex, email)
        NSLog(executyQuery)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
            }
        }
    }
    
    func updateUserBirthday(dbName: String, birdDay: String, email: String){
        let executyQuery = String(format: "UPDATE account SET bird_day = '%@' WHERE email='%@'", birdDay, email)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
            }
        }
    }
    
    
    
    // MARK: - Experience
    func updateExpertience(dbName: String, bookID: Int, testID: Int, part: Int, percent: Double){
        let executyQuery = String(format: "UPDATE test SET percent_part%i = percent_part%i + %f WHERE book_id=%i AND test_id=%i", part, part, percent, bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                
            }
        }
    }
    
    // MARK: - HigtScore
    func updateHighScore(dbName: String, bookID: Int, testID: Int, score: Int){
        let executyQuery = String(format: "UPDATE test SET high_score = %i WHERE book_id=%i AND test_id=%i", score, bookID, testID)
        self.queryDatabase(dbName, executyQuery: executyQuery) { (state, data) in
            let rs = data as! FMResultSet
            while rs.next() {
                
            }
        }
    }

    
}


