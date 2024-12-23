import Foundation

/// An object that can be used to create a new trip.
struct TripCreate: Encodable {
    let name: String
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
       case name
       case startDate = "start_date"
       case endDate = "end_date"
   }
   
   func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(name, forKey: .name)
       
       let dateFormatter = ISO8601DateFormatter()
       try container.encode(dateFormatter.string(from: startDate), forKey: .startDate)
       try container.encode(dateFormatter.string(from: endDate), forKey: .endDate)
   }
}

/// An object that can be used to update an existing trip.
/// An object that can be used to update an existing trip.
struct TripUpdate: Encodable {
    let name: String
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        let dateFormatter = ISO8601DateFormatter()
        try container.encode(dateFormatter.string(from: startDate), forKey: .startDate)
        try container.encode(dateFormatter.string(from: endDate), forKey: .endDate)
    }
}

// Update MediaCreate struct to match API requirements
struct MediaCreate: Encodable {
    let eventId: Event.ID
    let base64Data: Data
    let caption: String?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case base64Data = "base64_data"
        case caption
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventId, forKey: .eventId)
        // Convert Data to base64 string
        let base64String = base64Data.base64EncodedString()
        try container.encode(base64String, forKey: .base64Data)
        try container.encodeIfPresent(caption, forKey: .caption)
    }
}

/// An object that can be used to create a new event.
struct EventCreate: Encodable {
    let tripId: Trip.ID
    let name: String
    let note: String?
    let date: Date
    let location: Location?
    let transitionFromPrevious: String?
    
    enum CodingKeys: String, CodingKey {
        case tripId = "trip_id"
        case name
        case note
        case date
        case location
        case transitionFromPrevious = "transition_from_previous"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripId, forKey: .tripId)
        try container.encode(name, forKey: .name)
        try container.encode(note, forKey: .note)
        
        let dateFormatter = ISO8601DateFormatter()
        let utcDate = date.convertToUTC()  // Convert to UTC before encoding
        try container.encode(dateFormatter.string(from: utcDate), forKey: .date)
        
        try container.encode(location, forKey: .location)
        try container.encode(transitionFromPrevious, forKey: .transitionFromPrevious)
    }
}

/// An object that can be used to update an existing event.
struct EventUpdate: Encodable {
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var transitionFromPrevious: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case note
        case date
        case location
        case transitionFromPrevious = "transition_from_previous"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(note, forKey: .note)
        
        let dateFormatter = ISO8601DateFormatter()
        try container.encode(dateFormatter.string(from: date), forKey: .date)
        
        try container.encode(location, forKey: .location)
        try container.encode(transitionFromPrevious, forKey: .transitionFromPrevious)
    }
}
