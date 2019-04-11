//
//  MatchCouples.swift
//  birdview
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation

struct Person {
    var index: Int
    var value: String
}

class MatchCouples {
    
    private var people = [Person]()
    
    init(with fileName: String) {
        people = fileName.readTextFile()
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: " ").sorted().joined() }
            .enumerated()
            .map { Person(index: $0.offset, value: $0.element) }
            .sorted { $0.value < $1.value }
    }
    
    func match() {
        var couples = [String]()
        var beforeCount = 0

        for i in 0..<people.count {
            guard (i + 1) < people.count else { break }
            let person1 = Array(people[i].value)
            let person2 = Array(people[i + 1].value)
            
            var matchCount = 0
            for j in 0...9 {
                if person1[j] == person2[j] {
                    matchCount += 1
                }
            }

            if beforeCount < matchCount {
                print("match: \(matchCount)", people[i], people[i + 1])
                beforeCount = matchCount
                couples = [String]()
                couples.append("\(people[i].index + 1)-\(people[i + 1].index + 1)")
            } else if beforeCount == matchCount {
                print("before: \(beforeCount)", people[i], people[i + 1])
                couples.append("\(people[i].index + 1)-\(people[i + 1].index + 1)")
            }
        }
        Log.verbose(beforeCount)
        Log.info(couples.joined(separator: ", "))
    }
}
