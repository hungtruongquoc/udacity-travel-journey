//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Hung Truong on 12/11/24.
//
import Combine
import Foundation

class JournalServiceLive: JournalService {
    var isAuthenticated: AnyPublisher<Bool, Never> {
        fatalError("Unimplemented isAuthenticated")
    }

    func register(username: String, password: String) async throws -> Token {
        guard let url = URL(string: APIEndpoints.Auth.register) else {
            throw NetworkError.invalidURL
        }
        
        let body = [
            "username": username,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.badRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                return token
            } catch {
                throw NetworkError.decodingError
            }
        case 401:
            throw NetworkError.authenticationError
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    func logOut() {
        fatalError("Unimplemented logOut")
    }

    func logIn(username _: String, password _: String) async throws -> Token {
        fatalError("Unimplemented logIn")
    }

    func createTrip(with _: TripCreate) async throws -> Trip {
        fatalError("Unimplemented createTrip")
    }

    func getTrips() async throws -> [Trip] {
        fatalError("Unimplemented getTrips")
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
