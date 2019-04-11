//
//  main.swift
//  BirdViewCodingTest
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
//

import Foundation


enum Config: String {
    case debug = "testData"
    case release = "버드뷰_500000x10"
    
    func name() -> String {
        return self.rawValue
    }
}

// - MARK: START

func main() {
    Log.info("시작")
    let file: Config = .debug
    let couples = MatchCouples(with: file.name())
    couples.match()
    Log.info("종료")
}
main()
