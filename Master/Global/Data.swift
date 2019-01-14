//
//  Data.swift
//  Master
//
//  Created by Dalton Ng on 29/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit

// Need to Change
//struct MasterLevel : Codable {
//    var totalCorrect: Int
//    var totalWrong: Int
//    var box: Int
//    var lastAccessed: Double // Confirm?
//    var accessTimes:
//}

//struct Question : Codable {
//    var id: String
//    var question: String
//    var answer: String
//    var score: MasterLevel?
//}

public struct StudySetData : Codable {
    var title: String
    var ownerUid: String
    var courseCode: String
    var questions: [Question]
    
    func printAll() {
        print("" + title + "" + courseCode)
        
        for q in questions {
            print(q)
        }
    }
    
}

struct Question : Codable {
    var question: String
    var answer: String
}

