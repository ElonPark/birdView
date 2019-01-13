//
//  MatchCouplesByHobbys.swift
//  BirdViewCodingTest
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation

class MatchCouplesByHobbys {
    var people = [Person]()
    
    var couples: [Character : [Int]] = [
        "A": [Int](),
        "B": [Int](),
        "C": [Int](),
        "D": [Int](),
        "E": [Int](),
        "F": [Int](),
        "G": [Int](),
        "H": [Int](),
        "I": [Int](),
        "J": [Int](),
        "K": [Int](),
        "L": [Int](),
        "M": [Int](),
        "N": [Int](),
        "O": [Int](),
        "P": [Int](),
        "Q": [Int](),
        "R": [Int](),
        "S": [Int](),
        "T": [Int](),
        "U": [Int](),
        "V": [Int](),
        "W": [Int](),
        "X": [Int](),
        "Y": [Int](),
        "Z": [Int]()
    ]
    
    func main(with config: Config) {
        let startTime = Date()
        let fileText = config.name().readTextFile()
        let data = fileText.components(separatedBy: "\n")
        
        for index in 0..<data.count {
            guard !data[index].isEmpty else { continue }
            
            for hobby in data[index] {
                guard var h = couples[hobby] else { continue }
                h.append(index + 1)
                couples[hobby] = h
            }
        }
        
        for (hobby, person) in couples {
            print("\(hobby): \(person)\n")
        }
        
        let endTime = Date().timeIntervalSince(startTime)
        print("\n실행시간: \(endTime) seconds")
    }
}
