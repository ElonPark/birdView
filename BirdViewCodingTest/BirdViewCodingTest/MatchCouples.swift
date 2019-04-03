//
//  MatchCouples.swift
//  birdview
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation

class MatchCouples {
    
    var fileName: String

    init(with fileName: String) {
        self.fileName = fileName
    }
    
    func timePrint(with text: String) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS" // 날짜 형식 설정
        let dateNow = dateFormatter.string(from: now)
        print("\(text) - \(dateNow)\n")
    }
    
    func matchCount(_ person1: [String], and person2: [String]) -> Int {
        let intersection = Set(person1).intersection(Set(person2))
        
        return intersection.count
    }
    
    func matchingCouple(with people: [Person]) -> [String : Int] {
        var beforeCount = 0
        var couplesDic = [String : Int]()
        for i in 0..<people.count {
            for j in 0..<people.count {
                guard i != j else { continue }
                guard couplesDic["\(people[j].index)-\(people[i].index)"] == nil else {
                    continue
                }
                
                let count = matchCount(people[i].hobbys, and: people[j].hobbys)
                if count > beforeCount {
                    beforeCount = count
                    couplesDic = [String : Int]()
                    couplesDic["\(people[i].index)-\(people[j].index)"] = count
                    
                } else if count == beforeCount {
                    couplesDic["\(people[i].index)-\(people[j].index)"] = count
                }
            }
        }
        
        return couplesDic
    }
    
    func printText(by couples: [String : Int]) -> String {
        var printText: String = ""
       
        for couple in couples {
            print(couple)
            if printText.isEmpty {
                printText = couple.key
                
            } else {
                printText += ", " + couple.key
            }
        }
        
        return printText
    }
    
    func startMatching() {
        let startTime = Date()
        let fileText = fileName.readTextFile()
        
        guard !fileText.isEmpty else {
            print("\(fileName).txt is empty")
            return
        }
      
        var textArray = fileText.components(separatedBy: "\n")
        var people = [Person]()
        
        for i in 0..<textArray.count {
            guard !textArray[i].isEmpty else { continue }
            let hobbys = textArray[i].components(separatedBy: " ")
            let person = Person(index: i + 1, hobbys: hobbys)
            people.append(person)
        }
        
        let couplesDic = matchingCouple(with: people)
        let text = printText(by: couplesDic)
        let endTime = Date().timeIntervalSince(startTime)
        print(text)
        print("\n실행시간: \(endTime) seconds")
        self.timePrint(with: "\n종료")
    }
}
