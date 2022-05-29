//
//  KeypadReactor.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import ReactorKit

class KeypadViewReactor: Reactor {
    var initialState: State = State()
    var service: KeypadServiceProtocol
    
    init(service: KeypadServiceProtocol) {
        self.service = service
    }
    
    enum Action {
        case generateNumbers
        case makeInput(input: PinInput)
    }
    
    enum Mutation {
        case setNumbers
        case setInput(input: PinInput)
    }
    
    struct State {
        var numberInitialized: Bool = false
        var numberSet: [[Int]] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .generateNumbers:
            return .just(.setNumbers)

        case .makeInput(let input):
            return .just(.setInput(input: input))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setNumbers:
            newState.numberSet = AuthUtils.generatePincodeRandomNumber()
            
        case .setInput(let input):
            service.makeInput(input: input)
        }
        
        return newState
    }
}
