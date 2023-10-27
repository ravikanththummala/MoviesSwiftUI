//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Ravikanth on 10/26/23.
//

import SwiftUI

@main
struct MoviesSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(httpClient: HTTPClient())
            }
        }
    }
}
