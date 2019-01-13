//
//  main.swift
//  BirdViewCodingTest
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation

struct Person {
    let index: Int
    let hobbys: [String]
}

struct Couple {
    let key1: Int
    let key2: Int
    let matchCount: Int
}

struct MatchCouple {
    let key1: Int
    let key2: Int
    let match: Set<Character>
}

enum Config: String {
    case debug = "testData"
    case release = "버드뷰_500000x10"
    
    func name() -> String {
        return self.rawValue
    }
}

// - MARK: START

let file: Config = .debug
let couple = MatchCouples(with: file.name())
couple.timePrint(with: "시작")
couple.startMatching()
/*
let startTime = Date()
var people = [Person]()
var couplesDic = [String : MatchCouple]()

let fileText = file.name().readTextFile()
let data = fileText.components(separatedBy: "\n")

var count: Int = 0

for i in 0..<data.count {
    for j in 0..<data.count {
        guard i != j else { continue }
        guard couplesDic["\(j + 1)-\(i + 1)"] == nil else { continue }
        guard !data[i].isEmpty else { continue }
        guard !data[j].isEmpty else { continue }
        
        let hobbys1 = Set(data[i])
        let hobbys2 = Set(data[j])
        
        var intersection = hobbys1.intersection(hobbys2)
        intersection.remove(" ")
        
        if intersection.count > count {
            count = intersection.count
            couplesDic["\(i + 1)-\(j + 1)"] = MatchCouple(key1: i, key2: j, match: intersection)
        }
    }
}

for (k, v) in couplesDic {
    print("\(k): \(v.match.count)개 : \(v.match)")
}


let endTime = Date().timeIntervalSince(startTime)
print("\n실행시간: \(endTime) seconds")
*/
//실행시간: 5.135006904602051 seconds
//실행시간: 6.617677927017212 seconds
//실행시간: 6.465930104255676 seconds

//실행시간: 5.116236090660095 seconds
//실행시간: 5.11040997505188 seconds
//실행시간: 5.122105956077576 seconds
