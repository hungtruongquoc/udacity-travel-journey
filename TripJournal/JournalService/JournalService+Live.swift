//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Hung Truong on 12/11/24.
//
import Combine
import Foundation

class JournalServiceLive: JournalService {
    private func storeToken(_ token: Token) throws {
        try KeychainService.shared.saveToken(token)
        authenticationSubject.send(true)
    }
    
    private let authenticationSubject = CurrentValueSubject<Bool, Never>(false)
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        authenticationSubject.eraseToAnyPublisher()
    }
    
    private func setupRequest(
        for url: URL,
        method: String,
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if requiresAuth, let token = try? KeychainService.shared.retrieveToken() {
            request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
    
    private func performNetworkRequest<T: Decodable>(request: URLRequest) async throws -> T {
       do {
           let (data, response) = try await URLSession.shared.data(for: request)
           
           guard let httpResponse = response as? HTTPURLResponse else {
               FeedbackService.shared.provideFeedback(.error)
               throw NetworkError.invalidResponse
           }
           
           switch httpResponse.statusCode {
           case 200...299:
               do {
                   let result = try JSONDecoder().decode(T.self, from: data)
                   FeedbackService.shared.provideFeedback(.success)
                   return result
               } catch {
                   print("Decoding error: \(error)")
                   print("Debug description: \(error.localizedDescription)")
                   
                   if let decodingError = error as? DecodingError {
                       switch decodingError {
                       case .keyNotFound(let key, let context):
                           print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                       case .typeMismatch(let type, let context):
                           print("Type '\(type)' mismatch: \(context.debugDescription)")
                       case .valueNotFound(let type, let context):
                           print("Value of type '\(type)' not found: \(context.debugDescription)")
                       case .dataCorrupted(let context):
                           print("Data corrupted: \(context.debugDescription)")
                       @unknown default:
                           print("Unknown decoding error: \(decodingError)")
                       }
                   }
                   FeedbackService.shared.provideFeedback(.error)
                   throw NetworkError.decodingError
               }
           case 401:
               FeedbackService.shared.provideFeedback(.error)
               throw NetworkError.authenticationError
           case 400...499:
               FeedbackService.shared.provideFeedback(.error)
               throw NetworkError.badRequest
           case 500...599:
               FeedbackService.shared.provideFeedback(.error)
               throw NetworkError.serverError
           default:
               FeedbackService.shared.provideFeedback(.error)
               throw NetworkError.invalidResponse
           }
       } catch {
           FeedbackService.shared.provideFeedback(.error)
           throw error
       }
    }
    
    // When initializing the service, check for existing token
    init() {
       if let _ = try? KeychainService.shared.retrieveToken() {
           authenticationSubject.send(true)
       }
    }

    func register(username: String, password: String) async throws -> Token {
        guard let url = URL(string: APIEndpoints.Auth.register) else {
            throw NetworkError.invalidURL
        }
        
        let body = ["username": username, "password": password]
        let request = try setupRequest(for: url, method: "POST", body: body)
        let token: Token = try await performNetworkRequest(request: request)
        try storeToken(token)
        return token
    }

    func logOut() {
        try? KeychainService.shared.deleteToken()
        authenticationSubject.send(false)
    }

    func logIn(username: String, password: String) async throws -> Token {
        guard let url = URL(string: APIEndpoints.Auth.login) else {
           throw NetworkError.invalidURL
        }

        let parameters = [
           "grant_type": "",
           "username": username,
           "password": password
        ]
        let formBody = parameters
           .map { "\($0.key)=\($0.value)" }
           .joined(separator: "&")
           .data(using: .utf8)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = formBody

        do {
           let token: Token = try await performNetworkRequest(request: request)
           try storeToken(token)
           return token
        } catch NetworkError.badRequest, NetworkError.authenticationError {
           // Convert network error to authentication error for invalid credentials
           throw AuthenticationError.invalidCredentials
        }
    }

    func createTrip(with trip: TripCreate) async throws -> Trip {
        guard let url = URL(string: APIEndpoints.Trips.create) else {
            throw NetworkError.invalidURL
        }
        
        let request = try setupRequest(
            for: url,
            method: "POST",
            body: trip,
            requiresAuth: true
        )
        
        return try await performNetworkRequest(request: request)
    }

    func getTrips() async throws -> [Trip] {
        guard let url = URL(string: APIEndpoints.Trips.list) else {
            throw NetworkError.invalidURL
        }
        
        let request = try setupRequest(
            for: url,
            method: "GET",
            requiresAuth: true
        )
        
        return try await performNetworkRequest(request: request)
    }

    func getTrip(withId _: Trip.ID) async throws -> Trip {
        fatalError("Unimplemented getTrip")
    }

    func updateTrip(withId _: Trip.ID, and _: TripUpdate) async throws -> Trip {
        fatalError("Unimplemented updateTrip")
    }

    func deleteTrip(withId _: Trip.ID) async throws {
        fatalError("Unimplemented deleteTrip")
    }

    func createEvent(with _: EventCreate) async throws -> Event {
        fatalError("Unimplemented createEvent")
    }

    func updateEvent(withId _: Event.ID, and _: EventUpdate) async throws -> Event {
        fatalError("Unimplemented updateEvent")
    }

    func deleteEvent(withId _: Event.ID) async throws {
        fatalError("Unimplemented deleteEvent")
    }

    func createMedia(with _: MediaCreate) async throws -> Media {
        fatalError("Unimplemented createMedia")
    }

    func deleteMedia(withId _: Media.ID) async throws {
        fatalError("Unimplemented deleteMedia")
    }
}
