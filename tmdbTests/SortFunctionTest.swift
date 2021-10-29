//
//  SortFunctionTest.swift
//  tmdbTests
//
//  Created by Sunil Targe on 2021/9/26.
//

import XCTest
@testable import tmdb

class SortFunctionTest: XCTestCase {
    let testableSortQuery = "http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&sort_by=%@&page=1"
    let testableSortQueryParameter = "primary_release_date.asc" // replace with all sort option
    
    func testSorting_with_sort_parameters() throws {
        // Define an expectation
        let expectation = self.expectation(description: "API should get sorted response and runs the callback closure")
        
        // Given
        let testableAPI = String(format: testableSortQuery, testableSortQueryParameter)
        guard let url = URL(string:testableAPI) else { return }

        // When
        // Making asynchronous request
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(data, "We got sorted data in the response")
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
