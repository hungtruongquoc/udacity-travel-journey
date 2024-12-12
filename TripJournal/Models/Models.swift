import Foundation
import MapKit

/// Represents a token that is returns when the user authenticates.
struct Token: Codable {
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

@propertyWrapper
struct UTCToLocal {
    private var date: Date
    
    var wrappedValue: Date {
        get {
            let timezone = TimeZone.current
            let seconds = TimeInterval(timezone.secondsFromGMT(for: date))
            return Date(timeInterval: seconds, since: date)
        }
        set {
            let timezone = TimeZone.current
            let seconds = -TimeInterval(timezone.secondsFromGMT(for: newValue))
            date = Date(timeInterval: seconds, since: newValue)
        }
    }
    
    init(wrappedValue: Date) {
        self.date = wrappedValue
    }
}

// Represents a trip.
struct Trip: Identifiable, Sendable, Hashable, Codable {
    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case events
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let isoFormatter = ISO8601DateFormatter()
        // Remove .withFractionalSeconds since it's causing the parsing error
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        guard let utcStartDate = isoFormatter.date(from: startDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .startDate, in: container, debugDescription: "Invalid date format")
        }
        startDate = utcStartDate.convertToLocalTime()
        
        let endDateString = try container.decode(String.self, forKey: .endDate)
        guard let utcEndDate = isoFormatter.date(from: endDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .endDate, in: container, debugDescription: "Invalid date format")
        }
        endDate = utcEndDate.convertToLocalTime()
        
        events = try container.decode([Event].self, forKey: .events)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        let utcStartDate = startDate.convertToUTC()
        let utcEndDate = endDate.convertToUTC()
        
        try container.encode(isoFormatter.string(from: utcStartDate), forKey: .startDate)
        try container.encode(isoFormatter.string(from: utcEndDate), forKey: .endDate)
        try container.encode(events, forKey: .events)
    }
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


