//
//  InstagramTests.swift
//  InstagramTests
//
//  Created by ddd on 9/21/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import XCTest
@testable import Instagram


class InstagramTests: XCTestCase {
    
    var feed: [InstaFeed.Post] = []

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let defaultTimeout: NSTimeInterval = 10
        let expectation = expectationWithDescription("Waiting for response")
        InstaFeed().fetchPostDetails{ (posts: [InstaFeed.Post]) -> ()
            in
            
            expectation.fulfill()
            self.feed = posts
        }
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    func testSuccessfulMediaConnection() {
        //var feed : [InstaFeed.Post] = []
        XCTAssertNotNil(self.feed)
        print("count: " + String(self.feed.count))
    }
        
    
    func testFeedContents() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.feed.count)))
        XCTAssertNotNil(self.feed[randomIndex].userID)
        XCTAssertNotNil(self.feed[randomIndex].profilePicURL)
        XCTAssertNotNil(self.feed[randomIndex].username)
        XCTAssertNotNil(self.feed[randomIndex].created_time)
        XCTAssertNotNil(self.feed[randomIndex].caption)
        XCTAssertNotNil(self.feed[randomIndex].likes)
        XCTAssertNotNil(self.feed[randomIndex].comments)
        print(self.feed[randomIndex])
        
    }
    
    
    
    func testSuccessfulProfileRequest() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.feed.count)))
        var userProfileDetails: InstaUserProfile.ProfileHeader = InstaUserProfile.ProfileHeader(profilePicURL: "", username: "", postCount: 0, followerCount: 0, followingCount: 0)
        
        let defaultTimeout: NSTimeInterval = 10
        let expectation = expectationWithDescription("Waiting for response")
    
        InstaUserProfile().fetchProfileDetails (self.feed[Int(randomIndex)].userID)  { (header: InstaUserProfile.ProfileHeader) -> () in
            
            expectation.fulfill()
            userProfileDetails = header
        }
        
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        XCTAssertNotNil(userProfileDetails)
    }
    
    func testUserProfileInfo() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.feed.count)))
        var userProfileDetails: InstaUserProfile.ProfileHeader = InstaUserProfile.ProfileHeader(profilePicURL: "", username: "", postCount: 0, followerCount: 0, followingCount: 0)
        
        let defaultTimeout: NSTimeInterval = 10
        let expectation = expectationWithDescription("Waiting for response")
        
        InstaUserProfile().fetchProfileDetails (self.feed[Int(randomIndex)].userID)  { (header: InstaUserProfile.ProfileHeader) -> () in
            
            expectation.fulfill()
            userProfileDetails = header
        }
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
    
        XCTAssertNotNil(userProfileDetails.username)
        XCTAssertNotNil(userProfileDetails.profilePicURL)
        XCTAssertNotNil(userProfileDetails.postCount)
        XCTAssertNotNil(userProfileDetails.followingCount)
        XCTAssertNotNil(userProfileDetails.followerCount)
        print(userProfileDetails)
        
    }

    func testSuccessfulRecentMediaRequest() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.feed.count)))
        
        let defaultTimeout: NSTimeInterval = 10
        let expectation = expectationWithDescription("Waiting for response")
        
        InstaUserProfile().fetchRecentMediaDetails (self.feed[randomIndex].userID)  { (posts: [InstaUserProfile.Post]) -> () in
            
            expectation.fulfill()
            
            let recentMedia: [InstaUserProfile.Post] = posts
            XCTAssertNotNil(recentMedia)
            //print(recentMedia)
        }
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
    }
    
    func testRandomRecentPost() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.feed.count)))
    
        let defaultTimeout: NSTimeInterval = 10
        let expectation = expectationWithDescription("Waiting for response")
    
        InstaUserProfile().fetchRecentMediaDetails (self.feed[randomIndex].userID)  { (posts: [InstaUserProfile.Post]) -> () in
    
            expectation.fulfill()
    
            let recentMedia: [InstaUserProfile.Post] = posts
            XCTAssertNotNil(recentMedia)
            
            let randomPostIndex = Int(arc4random_uniform(UInt32(recentMedia.count)))
            XCTAssertNotNil(recentMedia[randomPostIndex].userID)
            XCTAssertNotNil(recentMedia[randomPostIndex].profilePicURL)
            XCTAssertNotNil(recentMedia[randomPostIndex].username)
            XCTAssertNotNil(recentMedia[randomPostIndex].created_time)
            XCTAssertNotNil(recentMedia[randomPostIndex].caption)
            XCTAssertNotNil(recentMedia[randomPostIndex].likes)
            XCTAssertNotNil(recentMedia[randomPostIndex].comments)
            print(recentMedia[randomPostIndex])
        }
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)

    }
    
//    func testBadUserID() {
//        let badUserID = "gibberish"
//        
//        let defaultTimeout: NSTimeInterval = 10
//        let expectation = expectationWithDescription("Waiting for response")
//
//        InstaUserProfile().fetchRecentMediaDetails (badUserID)  { (posts: [InstaUserProfile.Post]) -> () in
//
//            expectation.fulfill()
//
//            let recentMedia: [InstaUserProfile.Post] = posts
//            XCTAssertNil(recentMedia)
//        }
//        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
//    }
//    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
