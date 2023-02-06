//
//  NetworkService.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

final class NetworkService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func fetch<T: Codable>(path: String) async -> Result<T, Error> {
        
        let endpoint = "\(Configuration.domain)/\(path)"
        
        guard let url = URL(string: endpoint) else {
            
            return .failure(Errors.invalidPath)
        }
        
        let request = URLRequest(url: url)
        
        
        do {
            
            let (data, _) = try await session.data(for: request)
            let responseModel = try self.decoder.decode(T.self, from: data)
            
            return .success(responseModel)
            
        } catch {
            
            return .failure(error)
        }
    }
}


// MARK: - Configuration

extension NetworkService {
    
    enum Configuration {
        
        static let domain: String = "https://the-trivia-api.com/api"
    }
}

// MARK: - Error

extension NetworkService {
    
    enum Errors: Error {
        
        case invalidPath
        case invalidResponse
    }
}
