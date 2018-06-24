//
//  TwitSplitter.swift
//  TwitSplit
//
//  Created by ThanhPhong-Tran on 6/24/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

public class TwitSplitter {
    
    private static let CHARACTER_LIMIT: Int = 50
    
    public func splitMessage(_ message: String) -> [String] {
        if message.count < TwitSplitter.CHARACTER_LIMIT { return [message] }
        
        let words: [String] = message.components(separatedBy: " ")
        var _message: String = ""
        var results = [String]()
        
        for word in words {
            let temp = _message + " " + word
            if temp.count + 4 > TwitSplitter.CHARACTER_LIMIT {
                results.append(_message)
                _message = " " + word
            } else {
                _message += " " + word
            }
        }
        results.append(_message)
        
        let n = results.count
        for i in 0..<n { results[i] = "\(i+1)" + "/" + "\(n)" + results[i] }
        
        return results
    }
}
