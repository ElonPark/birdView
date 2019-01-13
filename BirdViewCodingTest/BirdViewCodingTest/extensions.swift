//
//  extensions.swift
//  BirdViewCodingTest
//
//  Created by Nebula_MAC on 13/01/2019.
//  Copyright © 2019 park.elon. All rights reserved.
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
            let path = URL(fileURLWithPath: "/Users/Nebula/Github/birdView/BirdViewCodingTest/BirdViewCodingTest/resource/")
            let fileURL = path.appendingPathComponent(self).appendingPathExtension("txt")
            
            text = try String(contentsOf: fileURL, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
            
            return text
        }
        
        return text
    }
}
