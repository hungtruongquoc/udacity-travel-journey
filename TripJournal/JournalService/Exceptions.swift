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
