
//
//  PincodeUpdateViewReactor.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import ReactorKit

class PincodeUpdateReactor: Reactor {
    var initialState: State = State()
    var keypadService: KeypadServiceProtocol
    var userService: UserServiceProtocol
    
    init(keypadService: KeypadServiceProtocol,
         userService: UserServiceProtocol) {
        self.keypadService = keypadService
        self.userService = userService
    }
    
    enum Action {
        case getKeypad
        case getPinStack
        case validateInput(input: String)
        case checkMatches(input: String)
        case savePincode
        case resetAll
//        case makeError(error: MPayError)
    }
    
    enum Mutation {
        case setKeypad
        case hideKeypad
        case setPinStack
        case setValidation(input: String, validation: CommonValidation)
        case checkIfMatched(input: String)
        case resetPincode
        case setDidUpdatePincode
        case dismissPincodeSetView
        
        case setInidicator(isOn: Bool)
//        case setError(error: MPayError)
    }
    
    struct State {
        var keypad: KeypadViewController?
        var pinStackView: PinStackView?
        var didValidateInput: Bool = false
        var didMatch: Bool = false
        var validation: CommonValidation = .NONE
        var tempPincode: String?
//        var error: MPayError?
        
        var didUpdatePincode: Bool = false
        var shouldDismiss: Bool = false
        var isLoading: Bool = false
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let serviceEvent = keypadService.eventRelay
            .map { [weak self] event -> Action in
                guard let self = self else { return .resetAll }
                switch event {
                case .reachedMax(let input):
                    return self.currentState.didValidateInput ?
                        Action.checkMatches(input: input) : Action.validateInput(input: input)
                }
            }
        
        return Observable.merge(action, serviceEvent)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getKeypad:
            return .just(.setKeypad)
            
        case .getPinStack:
            return .just(.setPinStack)
            
        case .validateInput(let input):
            let userPhoneNB = "010111112222"
            let userBD = "19960225"
            let phoneMiddeNumber = String((userPhoneNB.suffix(8)).prefix(4))
            let phoneLastNumber = String(userPhoneNB.suffix(5))
            
            return AuthUtils.validatePinCode(input: input,
                                             birthDay: userBD,
                                             phoneMiddleNum: phoneMiddeNumber,
                                             phoneLastNum: phoneLastNumber)
                .flatMap { validation -> Observable<Mutation> in
                    Observable.concat([
                        .just(.setValidation(input: input, validation: validation)),
                        .just(.hideKeypad),
                        .just(.setKeypad)
                    ])
                }
            
        
        case .checkMatches(let input):
            return .just(.checkIfMatched(input: input))
            
        case .savePincode:
            return .concat([
                .just(.setInidicator(isOn: true)),
                userService.updatePincode()
                    .flatMap { result -> Observable<Mutation> in
                        //TODO: API 호출 및 응답 확인
                        return .concat([
                            .just(.setDidUpdatePincode),
                            .just(.dismissPincodeSetView)
                        ])
                    },
//                    .catch { error in
//                        return .just(.setError(error: ErrorHandler.convert(error)))
//                    }
                .just(.setInidicator(isOn: false))
            ])
            
//        case .makeError(error: let error):
//            return .just(.setError(error: error))
            
        case .resetAll:
            return .just(.resetPincode)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setInidicator(let isLoading):
            newState.isLoading = isLoading
            
        case .setKeypad:
            let keypad = KeypadViewController()
            keypad.reactor = KeypadViewReactor(service: keypadService)
            newState.keypad = keypad
            
        case .hideKeypad:
            newState.keypad = nil
        
        case .setPinStack:
            let pinStackView = PinStackView(maxCount: keypadService.maxCount,
                                            type: .rect,
                                            inputRelay: keypadService.inputRelay)
            newState.pinStackView = pinStackView
            
        case .setValidation(let input, let validation):
            newState.validation = validation
            newState.didValidateInput = validation.value
            
            if validation.value {
                newState.tempPincode = input
            }
            keypadService.makeInput(input: .clear)
            
        case .checkIfMatched(let input):
            guard let saved = currentState.tempPincode else { break }
            let didMatch = (input == saved) ? CommonValidation.MATCHED : CommonValidation.NOT_MATCHED
            newState.validation = didMatch
            newState.didMatch = didMatch.value
            keypadService.makeInput(input: .clear)
            
        case .dismissPincodeSetView:
            newState.shouldDismiss = true
            //TODO: 암호화 이후 저장
//            registerService.registerUserDto.setPinHash(
//                pinHash: currentState.tempPincode!
//            )
            
            
//        case .setError(error: let error):
//            newState.error = error
            
        case .resetPincode:
            newState.validation = .NONE
            newState.didValidateInput = false
            newState.tempPincode?.removeAll()
            
            keypadService.makeInput(input: .clear)
            
        case .setDidUpdatePincode:
            newState.didUpdatePincode = true
        }
        return newState
    }
}



