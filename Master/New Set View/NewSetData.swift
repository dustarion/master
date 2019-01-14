//
//  NewSetData.swift
//  Master
//
//  Created by Dalton Ng on 29/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import Foundation

struct NewSetData {
    var title: String
    var courseCode: String
    var questions: [NewQuestion]
    
    func printAll() {
        print("" + title + "" + courseCode)
        
        for q in questions {
            print(q)
        }
    }
    
}

struct NewQuestion {
    var question: String
    var answer: String
}
