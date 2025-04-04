//
//  TechnicalTestTests.swift
//  TechnicalTestTests
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

import Testing
@testable import TechnicalTest

import XCTest
import Combine

/// A mock implementation of `APIServiceProtocol` for unit testing.
/// Simulates network requests by returning predefined responses or errors.
class MockAPIService: APIServiceProtocol {
    /// The mock response to return when a request is made.
    var mockResponse: CharacterResponse?
    
    /// The mock error to return when a request fails.
    var mockError: Error?
    
    /// Fetches mock data and returns a publisher that either emits the mock response or an error.
    /// - Parameter url: The URL string
    /// - Returns: A publisher emitting a mock response or an error.
    func fetchData<T: Decodable>(url: String?) -> AnyPublisher<T, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let response = mockResponse as? T {
            return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}

/// Unit tests for `CharacterViewModel` using `MockAPIService`.
final class CharacterViewModelTests: XCTestCase {
    /// The view model instance under test.
    var viewModel: CharacterViewModel!
    
    /// The mock API service used to simulate network calls.
    var mockService: MockAPIService!
    
    /// A set of cancellables to manage subscriptions.
    var cancellables: Set<AnyCancellable> = []
    
    /// Set up the test environment before each test case.
    override func setUp() {
        mockService = MockAPIService()
        viewModel = CharacterViewModel(apiService: mockService)
    }
    
    /// Clean up after each test case.
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables.removeAll()
    }
    
    /// Tests successful character loading.
    func testLoadCharacters_Success() {
        let pageInfo = PageInfo(count: 0, pages: 0, next: "https://rickandmortyapi.com/api/character?page=2", prev: "")
        let character1 = Character(id: 1, name: "Rick Sanchez", status: "", species: "", type: "", gender: "", origin: nil, location: nil, image: "", episode: [], url: "", created: "")
        
        // Assign mock response
        mockService.mockResponse = CharacterResponse(info: pageInfo, results: [character1])
        
        let expectation = expectation(description: "Characters loaded")
        
        // First, trigger character loading
        viewModel.loadCharacters()
        
        // Then, subscribe to the published property
        let cancellable = viewModel.$characters.sink { characters in
            XCTAssertEqual(characters.count, 1)
            XCTAssertEqual(characters.first?.name, "Rick Sanchez")
            
            // Verify the next page URL is correctly set
            XCTAssertEqual(self.viewModel.nextURL ?? "", "https://rickandmortyapi.com/api/character?page=2")
            expectation.fulfill()
        }
        
        cancellable.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests successful loading of the next page of characters.
    func testLoadNextPage_Success() {
        let pageInfo = PageInfo(count: 0, pages: 0, next: "", prev: "")
        let character1 = Character(id: 1, name: "Rick Sanchez", status: "", species: "", type: "", gender: "", origin: nil, location: nil, image: "", episode: [], url: "", created: "")
        let character2 = Character(id: 2, name: "Morty Smith", status: "", species: "", type: "", gender: "", origin: nil, location: nil, image: "", episode: [], url: "", created: "")
        
        // Load the first page of characters
        mockService.mockResponse = CharacterResponse(info: pageInfo, results: [character1])
        viewModel.loadCharacters()
        
        // Assign new mock response for the next page
        mockService.mockResponse = CharacterResponse(info: pageInfo, results: [character2])
        
        let expectation = expectation(description: "Next page loaded")
        
        // First, trigger next page loading
        viewModel.loadNextPage()
        
        // Then, subscribe to the published property
        let cancellable = viewModel.$characters.sink { characters in
            XCTAssertEqual(characters.count, 2)
            XCTAssertEqual(characters.last?.name, "Morty Smith")
            XCTAssertEqual("", self.viewModel.nextURL)
            expectation.fulfill()
        }
        
        cancellable.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

