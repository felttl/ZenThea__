//
//  ZenTheaSourceTests.swift
//  ZenTheaSourceTests
//
//  Created by felix on 02/02/2025.
//
import XCTest
import Testing
@testable import ZenTheaSource

struct ZenTheaSourceTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testSauvegardeConversations(){
        let a = ConversationDAO(
            cit: 0,
            title: "test",
            date: Date()
        )
    }
    
    

}
