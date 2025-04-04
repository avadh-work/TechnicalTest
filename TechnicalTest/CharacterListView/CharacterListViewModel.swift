//
//  CharacterListViewModel.swift
//  TechnicalTest
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

import Foundation
import Combine

/// ViewModel responsible for fetching and managing character data.
/// Implements pagination to load more characters as needed.
class CharacterViewModel: ObservableObject {
    /// A published array of characters that updates the UI when changed.
    @Published var characters: [Character] = []
    
    /// A set of cancellables to store Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The API service used to fetch character data.
    private let apiService: APIServiceProtocol
    
    /// Stores the URL for fetching the next page of characters.
    var nextURL: String?
    
    /// Initializes the ViewModel with an API service.
    /// - Parameter apiService: The API service to fetch character data, defaults to `APIService.shared`.
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    /// Loads the initial list of characters from the API.
    func loadCharacters() {
        apiService.fetchData(url: nil)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] (characterResponse: CharacterResponse) in
                self?.characters = characterResponse.results ?? []
                self?.nextURL = characterResponse.info?.next // Save the next URL for pagination
            })
            .store(in: &cancellables)
    }
    
    /// Loads the next page of characters if available.
    func loadNextPage() {
        guard let nextPageURL = nextURL else { return }
        
        apiService.fetchData(url: nextPageURL)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] (characterResponse: CharacterResponse) in
                self?.characters.append(contentsOf: characterResponse.results ?? [])
                self?.nextURL = characterResponse.info?.next // Update the next URL
            })
            .store(in: &cancellables)
    }
}
