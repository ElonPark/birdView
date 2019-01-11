import Foundation


extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

func timePrint(with text: String) {
    
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS" // 날짜 형식 설정
    let dateNow = dateFormatter.string(from: now)
    print("\(text) - \(dateNow)\n")
}



struct Couple {
    let key1: Int
    let key2: Int
    let matchCount: Int
}


var couplesDic = [String : Couple]()


func matchCount(_ person1: [String], and person2: [String]) -> Int {
    let p1 = Set(person1)
    let p2 = Set(person2)
    let intersection = p1.intersection(p2)
    
    return intersection.count
}


func match(to myHobby: (Int, [String]), by otherHobbys: [(Int, [String])]) {
    var beforeCount: Int = 0
    
    for otherHobby in otherHobbys {
        guard myHobby.0 != otherHobby.0 else { continue }
        guard couplesDic.index(forKey: "\(myHobby.0)-\(otherHobby.0)") == nil else { continue }
        guard couplesDic.index(forKey: "\(otherHobby.0)-\(myHobby.0)") == nil else { continue }
        
        let count = matchCount(myHobby.1, and: otherHobby.1)
        if count >= beforeCount {
            beforeCount = count
            
            let couple = Couple(key1: myHobby.0, key2: otherHobby.0, matchCount: count)
            couplesDic["\(myHobby.0)-\(otherHobby.0)"] = couple
        }
    }
}


func matchingCouple(with array: [(Int, [String])], completion: @escaping () -> Void) {
    let dispathGroup = DispatchGroup()
    let chunks = array.chunked(by: 50)
    
    for (i, hobbys) in array {
        for chunk in chunks {
            dispathGroup.enter()
            DispatchQueue.global().async {
                match(to: (i, hobbys), by: chunk)
                dispathGroup.leave()
            }
        }
    }
    
    dispathGroup.notify(queue: DispatchQueue.global()) {
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

func readTextFile(withName fileName: String) -> String {
    var text: String = ""

    guard let path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {return text }
    
    do {
        let fileURL = path.appendingPathComponent(fileName + ".txt")
        text = try String(contentsOf: fileURL, encoding: .utf8)
        
    } catch {
        print(error.localizedDescription)
        
        return text
    }
    
    return text
}


// - MARK: main

func main() {
    timePrint(with: "시작")
    let fileName = "testdata"//"버드뷰_500000x10"//
    let fileText = readTextFile(withName: fileName)
    
    guard !fileText.isEmpty else { return }
    
    let textArray = fileText
        .components(separatedBy: "\n")
        .enumerated()
        .map { ($0.offset, $0.element.components(separatedBy: " ")) }
    
    matchingCouple(with: textArray) {
        let text = printText(by: couplesDic.values.sorted { $0.key1 < $1.key2 })
        
        print(text)
        timePrint(with: "\n종료")
    }
}

main()



