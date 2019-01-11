//
//  main.swift
//  birdview
//
//  Created by Nebula_MAC on 28/11/2018.
//  Copyright © 2018 park.elon. All rights reserved.
//

import Foundation

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension String {
    func readTextFile() -> String {
        var text: String = ""
        
        do {
            let path = URL(fileURLWithPath: "/Users/Nebula/Github/birdview/birdview/resource/")
            let fileURL = path.appendingPathComponent(self).appendingPathExtension("txt")
//            print(fileURL)
            text = try String(contentsOf: fileURL, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
            
            return text
        }
        
        return text
    }
}

struct Person {
    let index: Int
    let hobbys: [String]
}

struct Couple {
    let key1: Int
    let key2: Int
    let matchCount: Int
}

class MatchCouples {
    
    var fileName: String = "testdata"
    var couplesDic = [String : Couple]()
    
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
        var intersection = [String]()
        var hobbys1 = [String : Bool]()
        var hobbys2 = [String : Bool]()
        
        for hobby in person1 {
            hobbys1[hobby] = true
        }
        
        for hobby in person2 {
            guard let h1 = hobbys1[hobby], h1 && hobbys2[hobby] == nil else { continue }
            hobbys2[hobby] = true
            intersection.append(hobby)
        }
        
        return intersection.count
    }
    
    
    func match(to my: Person, by others: [Person]) {
        var beforeCount: Int = 0
        
        for other in others {
            guard my.index != other.index else { continue }
            guard couplesDic["\(my.index)-\(other.index)"] == nil else { continue }
            guard couplesDic["\(other.index)-\(my.index)"] == nil else { continue }
            
            let count = matchCount(my.hobbys, and: other.hobbys)
            if count >= beforeCount {
                beforeCount = count
                
               let couple = Couple(key1: my.index, key2: other.index, matchCount: count)
                couplesDic["\(my.index)-\(other.index)"] = couple
            }
        }
    }
    
    
    func matchingCouple(with people: [Person], completion: @escaping () -> Void) {
        let dispathGroup = DispatchGroup()
        let queue = DispatchQueue(label: "park.elon", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let chunks = people.chunked(by: people.count / 8)
        
        for person in people {
            for chunk in chunks {
                dispathGroup.enter()
                queue.async {
                    self.match(to: person, by: chunk)
                    dispathGroup.leave()
                }
            }
        }
        
        dispathGroup.notify(queue: queue) {
            completion()
        }
    }
    
    func printText(by couples: [Couple]) -> String {
        var printText: String = ""
        var beforeCount: Int = 1
        
        for couple in couples {
            if couple.matchCount > beforeCount {
                beforeCount = couple.matchCount
                printText = "\(couple.key1 + 1)-\(couple.key2 + 1)"
                
            } else if couple.matchCount == beforeCount {
                printText += ", \(couple.key1 + 1)-\(couple.key2 + 1)"
            }
        }
        
        return printText
    }
    
    func startMatching() {
        let startTime = Date()
        let fileText = fileName.readTextFile()
        
        guard !fileText.isEmpty else { print("\(fileName).txt is empty"); return }
        
        let textArray = fileText
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .enumerated()
            .compactMap { Person(index: $0.offset, hobbys: $0.element.components(separatedBy: " ")) }
        
        print("\(textArray.count)명\n")
        
        matchingCouple(with: textArray) {
            let text = self.printText(by: self.couplesDic.values.sorted { $0.key1 < $1.key2 })
            let endTime = Date().timeIntervalSince(startTime)
            print(text)
            print("\n실행시간: \(endTime) seconds")
            self.timePrint(with: "\n종료")
        }
    }
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



