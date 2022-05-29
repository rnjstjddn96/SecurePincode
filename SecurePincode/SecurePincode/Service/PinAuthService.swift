//
//  PinAuthService.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import RxCocoa
import RxSwift

enum AuthResult {
    case success
    case failure(_ reason: Error)
    
    var description: String {
        switch self {
        case .success:
            return "인증에 성공하였습니다."
            
        case .failure(let error):
            return error.localizedDescription
        }
    }
}

enum AuthContext {
    case standBy
    case inProgress(_ purpose: AuthPurpose)
    case resolved(_ result: AuthResult)
    
    var id: Int {
        switch self {
        case .standBy:
            return 0
        case .inProgress:
            return 1
        case .resolved:
            return 2
        }
    }
    
    var isOpened: Bool {
        switch self {
        case .standBy:
            return false
        case .inProgress:
            return true
        case .resolved:
            return true
        }
    }
}

extension AuthContext: Equatable {
    static func == (lhs: AuthContext, rhs: AuthContext) -> Bool {
        return lhs.id == rhs.id
    }
}

enum AuthPurpose: Equatable {
    case updatePincode
    
}

protocol PinAuthServiceProtocol {
    var currentContext: BehaviorSubject<AuthContext> { get }
    var authLoading: BehaviorRelay<Bool> { get }
    
    func requestPincodeAuth(input: String) -> Observable<AuthResult>
    func updateContext(context: AuthContext)
    func setAuthLoading(_ loading: Bool)
}

class PinAuthService: PinAuthServiceProtocol {
    var currentContext: BehaviorSubject<AuthContext> = .init(value: .standBy)
    var authLoading: BehaviorRelay<Bool> = .init(value: false)
    
    func updateContext(context: AuthContext) {
        self.currentContext.on(.next(context))
    }
    
    func setAuthLoading(_ loading: Bool) {
        self.authLoading.accept(loading)
    }
    
    func requestPincodeAuth(input: String) -> Observable<AuthResult> {
        return Observable.create { observer -> Disposable in
            guard !input.isEmpty else {
                //비정상적인 요청
                return Disposables.create()
            }
            //MARK: 핀코드 인증 로직 추가
            observer.on(.next(.success))
            observer.on(.completed)
            
            return Disposables.create()
        }
    }

}
