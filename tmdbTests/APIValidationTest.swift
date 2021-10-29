//
//  APIValidationTest.swift
//  tmdbTests
//
//  Created by Sunil Targe on 2021/9/26.
//

import XCTest
@testable import tmdb

class APIValidationTest: XCTestCase {

    func testAPIResponse() throws {
        // Define an expectation
        let expectation = self.expectation(description: "API call and runs the callback closure")
        
        // Given
        let testableAPI = "https://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91"
        guard let url = URL(string:testableAPI) else { return }

        // When
        // Making asynchronous request
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Then
            // check for error
            if error != nil {
                XCTFail("error occured: \(String(describing: error))")
                return
            }
            
            // check for data in the response
            if data != nil {
                XCTAssertNotNil(data, "We got data in API response")
                XCTAssertNotNil(response)
            } else {
                XCTAssertNil(data)
            }
            
            // expectation fulfilled
            expectation.fulfill()
        }
        task.resume()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testDecoding() throws {
        // Given
        let testableAPI = "https://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91"
        
        // When
        let jsonData = try Data(contentsOf: URL(string: testableAPI)!)

        // then
        XCTAssertNoThrow(try JSONDecoder().decode(Response.self, from: jsonData))
    }
    
    func testMovieDetails_response_with_movieID() throws {
        // Define an expectation
        let expectation = self.expectation(description: "API should get response and runs the callback closure")
        
        // Given
        let testableAPI = "https://api.themoviedb.org/3/movie/848278?api_key=328c283cd27bd1877d9080ccb1604c91"
        guard let url = URL(string:testableAPI) else { return }

        // When
        // Making asynchronous request
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(data, "We got movie details data in the response")
            XCTAssertNotNil(response)
            
            // expectation fulfilled
            expectation.fulfill()
        }
        task.resume()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
