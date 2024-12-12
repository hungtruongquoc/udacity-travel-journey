import SwiftUI

private struct JournalServiceKey: EnvironmentKey {
    static var defaultValue: JournalService = UnimplementedJournalService()
}

private struct JournalServiceLiveKey: EnvironmentKey {
    static var defaultValue: JournalService = JournalServiceLive()
}

extension EnvironmentValues {
    /// A service that can used to interact with the trip journal API.
    var journalService: JournalService {
        get { self[JournalServiceKey.self] }
        set { self[JournalServiceKey.self] = newValue }
    }
    
    /// Live implementation of the journal service
    var journalServiceLive: JournalService {
        get { self[JournalServiceLiveKey.self] }
        set { self[JournalServiceLiveKey.self] = newValue }
    }
}
