//
//  MatchCouples.swift
//  birdview
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation

struct Person: Hashable {
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
    
    private func coupleSet() -> Set<Person> {
        var matchSet = Set<Person>()
        var beforeCount = 0
        
        for i in 0..<people.count - 1 {
            let person1 = Array(people[i].value)
            let person2 = Array(people[i + 1].value)
            
            var match = ""
            for j in 0...9 {
                if person1[j] == person2[j] {
                    match.append(person1[j])
                }
            }
            
            if beforeCount < match.count {
                beforeCount = match.count
                matchSet = Set<Person>()
                matchSet.insert(Person(index: people[i].index, value: match))
                matchSet.insert(Person(index: people[i + 1].index, value: match))
            } else if beforeCount == match.count {
                matchSet.insert(Person(index: people[i].index, value: match))
                matchSet.insert(Person(index: people[i + 1].index, value: match))
            }
        }
        Log.verbose(beforeCount)
        
        return matchSet
    }
    
    private func coupleString(_ person1: Person, with person2: Person) -> String {
        return "\(person1.index + 1)-\(person2.index + 1)"
    }
    
    func matchResult() -> String {
        let coupleSet = self.coupleSet()
        let couples = Array(coupleSet).sorted { $0.value < $1.value }
        var matchSet = Set<String>()
        
        for i in 0..<couples.count - 1 {
            //취미 수가 똑같은 커플이 여럿인 경우
            if couples.count > 2 {
                guard i + 2 < couples.count else { break }
                //삼각관계
                if couples[i].value == couples[i + 1].value && couples[i].value == couples[i + 2].value {
                    matchSet.insert(coupleString(couples[i], with: couples[i + 1]))
                    matchSet.insert(coupleString(couples[i + 1], with: couples[i + 2]))
                    matchSet.insert(coupleString(couples[i], with: couples[i + 2]))

                } else if couples[i].value == couples[i + 1].value {
                    matchSet.insert(coupleString(couples[i], with: couples[i + 1]))
                    
                } else if couples[i].value == couples[i + 2].value {
                    matchSet.insert(coupleString(couples[i], with: couples[i + 2]))
                    
                } else if couples[i + 1].value == couples[i + 2].value {
                    matchSet.insert(coupleString(couples[i + 1], with: couples[i + 2]))
                }
            } else {
                matchSet.insert(coupleString(couples[i], with: couples[i + 1]))
            }
        }

        return Array(matchSet).joined(separator: ", ")
    }
}
