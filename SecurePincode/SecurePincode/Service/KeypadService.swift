//
//  KeypadService.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import RxSwift
import RxCocoa

enum KeypadEvent {
    case reachedMax(input: String)
}

protocol KeypadServiceProtocol {
    var maxCount: Int { get }
    var eventRelay: PublishRelay<KeypadEvent> { get }
    var inputRelay: BehaviorRelay<String> { get }
    func makeInput(input: PinInput)
}

class KeypadService: KeypadServiceProtocol {
    let maxCount: Int
    var inputRelay: BehaviorRelay<String>
    var eventRelay: PublishRelay<KeypadEvent>
    
    init(maxCount: Int) {
        self.maxCount = maxCount
        self.inputRelay = .init(value: String.empty)
        self.eventRelay = PublishRelay<KeypadEvent>()
    }
    
    func makeInput(input: PinInput) {
        switch input {
        case .delete:
            let currentInput = inputRelay.value
            guard currentInput.count > 0 else { return }
            var deleted = Array(currentInput)
            deleted.remove(at: currentInput.count - 1)
            inputRelay.accept(String(deleted))
            
        case .number(let number):
            let currentInput = inputRelay.value
            guard currentInput.count < maxCount else { return }
            let appended = currentInput + number
            inputRelay.accept(appended)

            if inputRelay.value.count == self.maxCount {
                eventRelay.accept(.reachedMax(input: inputRelay.value))
            }
            
        case .clear:
            inputRelay.accept(String.empty)
        }
    }
}
