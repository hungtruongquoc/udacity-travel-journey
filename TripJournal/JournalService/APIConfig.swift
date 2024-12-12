import Foundation

extension Bundle {
    var apiBaseURL: String {
        guard let baseURL = object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not found in Info.plist")
        }
        return baseURL
    }
}


enum APIEndpoints {
    private static let baseURL = Bundle.main.apiBaseURL
    
    // MARK: - Authentication
    struct Auth {
        private static let base = baseURL + "/auth"
        static let register = baseURL + "/register"
        static let login = baseURL + "/token"
    }
    
    // MARK: - Trips
    struct Trips {
        private static let base = baseURL + "/trips"
        
        static let list = base
        static let create = base
        
        static func detail(id: String) -> String {
            return "\(base)/\(id)"
        }

        static func update(id: String) -> String {
            return "\(base)/\(id)"
        }
        
        static func delete(id: String) -> String {
            return "\(base)/\(id)"
        }
    }
    
    // MARK: - Events
    struct Events {
        private static let base = baseURL + "/events"
        
        static let create = base
        
        static func detail(id: String) -> String {
            return "\(base)/\(id)"
        }
        
        static func update(id: String) -> String {
            return "\(base)/\(id)"
        }
        
        static func delete(id: String) -> String {
            return "\(base)/\(id)"
        }
    }
    
    // MARK: - Media
    struct Media {
        private static let base = baseURL + "/media"
        
        static let upload = base
        
        static func delete(id: String) -> String {
            return "\(base)/\(id)"
        }
    }
}
