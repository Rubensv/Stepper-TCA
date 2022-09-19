//
//  StepperTCAApp.swift
//  StepperTCA
//
//  Created by Rubén Sánchez on 19/9/22.
//

import SwiftUI

@main
struct StepperTCAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: State(),
                    reducer: reducer,
                    environment: Environment()))
        }
    }
}
