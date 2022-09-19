//
//  ContentView.swift
//  StepperTCA
//
//  Created by Rubén Sánchez on 19/9/22.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: Store<State, Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack(alignment: .center, spacing: 16) {
                    Button(action: { viewStore.send(.decreaseCounter) }) {
                        Image(systemName: "minus")
                            .frame(width: 40, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .disabled(viewStore.state.disabledDecreaseCounter)
                    
                    Text("\(viewStore.state.counter)")
                        .font(.system(.title3))
                    
                    Button(action: { viewStore.send(.increaseCounter) }) {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .disabled(viewStore.state.disabledIncreaseCounter)
                }
            }
            .padding()
        }
    }
}


enum Action: Equatable {
    case increaseCounter
    case decreaseCounter
    case disableIncreaseButton(Bool)
    case disableDecreaseButton(Bool)
}


struct State: Equatable {
    let bounds: ClosedRange<Int>
    
    var counter: Int
    var disabledDecreaseCounter: Bool = true
    var disabledIncreaseCounter: Bool = false
    
    public init(bounds: ClosedRange<Int> = (0...10)) {
        self.bounds = bounds
        self.counter = bounds.lowerBound
    }
}

struct Environment {
    // Dependencies
}

let reducer = Reducer<State, Action, Environment> { state, action, environment in
    switch action {
    case .decreaseCounter:
        state.counter -= 1
        return Effect(value: .disableDecreaseButton(state.counter <= state.bounds.lowerBound)).concatenate(with: Effect(value: .disableIncreaseButton(state.counter >= state.bounds.upperBound)))
    case .increaseCounter:
        state.counter += 1
        return Effect(value: .disableIncreaseButton(state.counter >= state.bounds.upperBound)).concatenate(with: Effect(value: .disableDecreaseButton(state.counter <= state.bounds.lowerBound)))
    case let .disableIncreaseButton(disable):
        state.disabledIncreaseCounter = disable
        return Effect.none
    case let .disableDecreaseButton(disable):
        state.disabledDecreaseCounter = disable
        return Effect.none
    }
}


// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: .init(
                initialState: State(bounds: (1...5)),
                reducer: reducer,
                environment: Environment())
        )
    }
}
