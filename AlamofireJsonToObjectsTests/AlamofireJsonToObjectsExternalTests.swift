//
//  AlamofireJsonToObjectsExternalTests.swift
//  AlamofireJsonToObjects
//
//  Created by Edwin Vermeer on 6/30/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import UIKit
import XCTest
import Alamofire
import EVReflection

class User: EVObject {
    var id: Int = 0
    var name: String?
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
}

class Address: EVObject {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?
}

class Company: EVObject {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}

class Geo: EVObject {
    var lat: String?
    var lng: String?
}

class AlamofireJsonToObjectsExternalTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        EVReflection.setBundleIdentifier(User)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResponseObject() {
        let URL:URLStringConvertible = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_users_array_json"
        let expectation = expectationWithDescription("\(URL)")

        Alamofire.request(.GET, URL)
            .responseArray { (response: Result<[User]>) in
            expectation.fulfill()

            if let result = response.value {
                print("\(result.description)")
                
                XCTAssertTrue(result.count == 10, "We should have 10 users")
                
                if let testUser:User = result[2] {
                    XCTAssertTrue(testUser.id == 3, "3rd user id should be 3")
                    XCTAssertTrue(testUser.name == "Clementine Bauch", "3rd user name should be Clementine Bauch")
                    
                    if let address:Address = testUser.address {
                        XCTAssertTrue(address.street == "Douglas Extension", "3rd user address street should be Douglas Extension")
                        XCTAssertTrue(address.suite == "Suite 847", "3rd user address suite should be Suite 847")
                        
                        if let geo:Geo = address.geo {
                            XCTAssertTrue(geo.lat == "-68.6102", "3rd user address geo lat should be -68.6102")
                            XCTAssertTrue(geo.lng == "-47.0653", "3rd user address geo lat should be -47.0653")
                        }
                    } else {
                        XCTFail("No 3rd user address in response")
                    }
                } else {
                    XCTFail("No 3rd user in response")
                }
            }
        }
        waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }
}