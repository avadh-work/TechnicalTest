//
//  APIService.swift
//  TechnicalTest
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

import Foundation
import NetworkManager
import Combine

/// A protocol defining the expected API service behavior.
/// Used to abstract the networking layer for easier testing and flexibility.
protocol APIServiceProtocol {
    /// Fetches data from a given URL.
    /// - Parameter url: The optional URL string to request data from.
    /// - Returns: A publisher that emits a decoded object or an error.
    func fetchData<T: Decodable>(url: String?) -> AnyPublisher<T, Error>
}

/// A concrete implementation of `APIServiceProtocol`.
/// Provides generic networking capabilities to fetch data from a remote source.
class APIService: @preconcurrency APIServiceProtocol {

    /// Shared singleton instance.
    static let shared = APIService()

    /// The default base URL for API requests.
    private let baseURL = "https://rickandmortyapi.com/api/character"

    /// The network service used to perform the request.
    private let networkService: NetworkServiceProtocol

    /// Initializer for injecting a network service.
    /// - Parameter networkService: The service responsible for executing network requests.
    init(networkService: NetworkServiceProtocol = NetworkManager.shared) {
        self.networkService = networkService
    }

    /// Fetches data from the provided URL or the default base URL.
    /// - Parameter url: The optional string URL to fetch data from.
    /// - Returns: A publisher that emits a decoded object or an error.
    @MainActor
    func fetchData<T: Decodable>(url: String?) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url ?? baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        // Delegates the network request and decoding to the injected network service.
        return networkService.fetch(url: url)
    }
}
