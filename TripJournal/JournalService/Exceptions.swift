//
//  Exceptions.swift
//  TripJournal
//
//  Created by Hung Truong on 12/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case authenticationError
    case badRequest
    case serverError
    case decodingError
}

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        }
    }
}
