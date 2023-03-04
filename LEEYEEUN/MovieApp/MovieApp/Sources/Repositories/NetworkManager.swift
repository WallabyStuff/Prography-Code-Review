//
//  NetworkManager.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    var cancellables = Set<AnyCancellable>()
    func execute(url: URL, completion: @escaping ([Movie]) -> Void) {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: MovieDataModel.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { returnedPost in
                completion(returnedPost.data.movies)
            }
            .store(in: &cancellables)
    }
}
