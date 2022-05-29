//
//  PincodeAuthReactor.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import Foundation
import ReactorKit
import RxCocoa

class PincodeAuthReactor: Reactor {
    var initialState: State
    var keypadService: KeypadServiceProtocol
    var pinAuthService: PinAuthServiceProtocol
    
    init(pinAuthService: PinAuthServiceProtocol,
         keypadService: KeypadServiceProtocol) {
        self.keypadService = keypadService
        self.pinAuthService = pinAuthService
        self.initialState = State()
    }
    
    enum Action {
        case getKeypad
        case getPinStack
        case `init`
        case auth(input: String)
        case makeError(error: Error)
    }
    
    enum Mutation {
        case setKeypad
        case setPinStack
        case setAuthResult(result: AuthResult)
        case setError(error: Error)
        case setLoading(_ loading: Bool)
    }
    
    struct State {
        var keypad: KeypadViewController?
        var pinStackView: PinStackView?
        
        var shouldDismiss: Bool = false
        var error: Error?
        
        var isLoading: Bool = false
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let serviceEvent = keypadService.eventRelay
            .map { event -> Action in
                switch event {
                case .reachedMax(let input):
                    return .auth(input: input)
                }
            }

        return .merge(action, serviceEvent)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .`init`:
            return .concat([
                .just(.setKeypad),
                .just(.setPinStack)
            ])
            
        case .getKeypad:
            return .just(.setKeypad)
            
        case .getPinStack:
            return .just(.setPinStack)
            
            
        case .auth(let input):
            return pinAuthService
                .requestPincodeAuth(input: input)
                .flatMap { result -> Observable<Mutation> in
                    return .concat([
                        .just(.setLoading(true)),
                        .just(.setAuthResult(result: result)),
                        .just(.setLoading(false))
                    ])
                }
            
        case .makeError(let error):
            return .just(.setError(error: error))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setKeypad:
            let keypad = KeypadViewController()
            keypad.reactor = KeypadViewReactor(service: keypadService)
            newState.keypad = keypad
            
        case .setPinStack:
            let pinStackView = PinStackView(maxCount: keypadService.maxCount,
                                            type: .dot,
                                            inputRelay: keypadService.inputRelay)
            newState.pinStackView = pinStackView
            
        case .setError(error: let error):
            newState.error = error

        case .setAuthResult(let result):
            pinAuthService.updateContext(context: .resolved(result))
            print("인증결과: \(result.description)")
            newState.shouldDismiss = true
            
        case .setLoading(let loading):
            pinAuthService.setAuthLoading(loading)
        }
        
        return newState
    }
}
