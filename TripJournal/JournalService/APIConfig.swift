enum APIEndpoints {
    private static let baseURL = "https://your-api-base-url.com"  // Replace with your actual base URL
    
    // MARK: - Authentication
    struct Auth {
        private static let base = baseURL + "/auth"
        static let register = baseURL + "/register"
        static let token = baseURL + "/token"
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
