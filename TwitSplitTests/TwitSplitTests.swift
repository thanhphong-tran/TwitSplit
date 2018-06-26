//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by ThanhPhong-Tran on 6/24/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import XCTest

@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    let successMessages: [String: [String]] = [
        // Original test
        "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.": [
            "1/2 I can't believe Tweeter now supports chunking",
            "2/2 my messages, so I don't have to do it myself."
        ],
        // Test message is not splitted
        "I can't believe Tweeter now supports chunking": [
            "I can't believe Tweeter now supports chunking"
        ],
        // Test message is splitted by 4
        "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.": [
            "1/4 I can't believe Tweeter now supports chunking",
            "2/4 my messages, so I don't have to do it myself.",
            "3/4 I can't believe Tweeter now supports chunking",
            "4/4 my messages, so I don't have to do it myself.",
        ],
        // Test message is splitted by 11
//        "012345678900 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789": [
//            "1/11 012345678900 0123456789 0123456789",
//            "2/11 0123456789 0123456789 0123456789 0123456789",
//            "3/11 0123456789 0123456789 0123456789 0123456789",
//            "4/11 0123456789 0123456789 0123456789 0123456789",
//            "5/11 0123456789 0123456789 0123456789 0123456789",
//            "6/11 0123456789 0123456789 0123456789 0123456789",
//            "7/11 0123456789 0123456789 0123456789 0123456789",
//            "8/11 0123456789 0123456789 0123456789 0123456789",
//            "9/11 0123456789 0123456789 0123456789 0123456789",
//            "10/11 0123456789 0123456789 0123456789 0123456789",
//            "11/11 0123456789",
//        ],
    ]
    
    let failureMessages: [String] = [
        "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSplitSuccess() {
        let splitter = TwitSplitter()
        for message in successMessages.keys {
            let results = try! splitter.splitMessage(message)
            
            // Test results count
            XCTAssertEqual(results.count, successMessages[message]!.count)
            
            // Test each splitted message
            for i in 0..<results.count { XCTAssertEqual(results[i], successMessages[message]![i]) }
        }
    }
    
    func testSplitFailure() {
        let splitter = TwitSplitter()
        for message in failureMessages {
            XCTAssertThrowsError(try splitter.splitMessage(message)) { error in
                XCTAssertEqual(error as! TwitSplittingError, TwitSplittingError.charactersExceedLimit)
            }
        }
    }
}
