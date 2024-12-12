import Foundation
import MapKit

/// Represents a token that is returns when the user authenticates.
struct Token: Codable {
    let accessToken: String
    let tokenType: String
}

/// Represents a trip.
struct Trip: Identifiable, Sendable, Hashable, Codable {
    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var events: [Event]
}

/// Represents an event in a trip.
struct Event: Identifiable, Sendable, Hashable, Codable {
    var id: Int
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var medias: [Media]
    var transitionFromPrevious: String?
}

/// Represents a location.
struct Location: Sendable, Hashable, Codable {
    var latitude: Double
    var longitude: Double
    var address: String?
    
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    // CLLocationCoordinate2D isn't Codable, but we don't need to encode it
    // since it's a computed property derived from latitude and longitude
}

/// Represents a media with a URL.
struct Media: Identifiable, Sendable, Hashable, Codable {
    var id: Int
    var url: URL?
}