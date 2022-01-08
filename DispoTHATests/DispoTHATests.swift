//
//  DispoTHATests.swift
//  DispoTHATests
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import XCTest
@testable import DispoTHA
import Combine

class DispoTHATests: XCTestCase {

    // MARK:- variables
    var cancellables = Set<AnyCancellable>()
    
    // MARK:- functions
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func test_NetworkModel_gifs_shouldBeEmpty() {
        // Given
        let networkModel = NetworkModel.shared
        
        // When
        let gifs = networkModel.gifs
        
        // Then
        XCTAssertTrue(gifs.isEmpty)
        XCTAssertEqual(gifs.count, 0)
    }
    
    func test_NetworkModel_fetchData_shouldReturnItems() {
        // Given
        let networkModel = NetworkModel.shared
        
        // When
        let expectation = XCTestExpectation(description: "Should return items within 3 seconds.")
        
        networkModel.$gifs
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        networkModel.loadMore(search: "fitness")
        
        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertGreaterThan(networkModel.gifs.count, 0)
    }

}
