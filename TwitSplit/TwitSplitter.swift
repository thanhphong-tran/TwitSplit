//
//  TwitSplitter.swift
//  TwitSplit
//
//  Created by ThanhPhong-Tran on 6/24/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

public enum TwitSplittingError: Error {
    case charactersExceedLimit
    
    public var localizedDescription: String {
        switch self {
        case .charactersExceedLimit:
            return "The message contains a span of non-whitespace characters longer than 50 characters."
        }
    }
}

public class TwitSplitter {
    
    private static let CHARACTER_LIMIT: Int = 50
    
    public func splitMessage(_ message: String) throws -> [String] {
        
        // Return if message count less than or equal limit
        if message.count < TwitSplitter.CHARACTER_LIMIT { return [message] }
        
        let words: [String] = message.components(separatedBy: " ")
        var _message: String = ""
        var results = [String]()
        
        for word in words {
            let temp = _message + " " + word
            if temp.count + 4 > TwitSplitter.CHARACTER_LIMIT {
                
                // If message exceed limit before adding final word
                if _message.count + 4 > TwitSplitter.CHARACTER_LIMIT { throw TwitSplittingError.charactersExceedLimit }
                
                results.append(_message)
                _message = " " + word
            } else {
                _message += " " + word
            }
        }
        
        // Check final message before adding it
        if _message.count + 4 > TwitSplitter.CHARACTER_LIMIT { throw TwitSplittingError.charactersExceedLimit }
        results.append(_message)
        
        let n = results.count
        for i in 0..<n { results[i] = "\(i+1)" + "/" + "\(n)" + results[i] }
        
        return results
    }
}
