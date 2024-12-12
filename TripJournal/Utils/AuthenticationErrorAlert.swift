//
//  AuthenticationErrorAlert.swift
//  TripJournal
//
//  Created by Hung Truong on 12/11/24.
//

import Foundation
import SwiftUI

struct AuthenticationErrorAlert: ViewModifier {
    let error: AuthenticationError?
    let isPresented: Binding<Bool>
    
    func body(content: Content) -> some View {
        content.alert(
            "Authentication Error",
            isPresented: isPresented,
            presenting: error
        ) { _ in
            Button("OK") {
                isPresented.wrappedValue = false
            }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}

// Add a convenience extension to View
extension View {
    func authenticationErrorAlert(
        error: AuthenticationError?,
        isPresented: Binding<Bool>
    ) -> some View {
        modifier(AuthenticationErrorAlert(error: error, isPresented: isPresented))
    }
}

