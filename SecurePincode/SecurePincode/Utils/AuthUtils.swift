//
//  AuthUtils.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import LocalAuthentication
import RxSwift
import RxCocoa

final class AuthUtils {
    //키패드에 쓰일 랜덤 배열
    class func generatePincodeRandomNumber() -> [[Int]] {
        let BUTTON_NUMBER_SET: [Int] = Array(0...9)
        
        let shuffledNumbers = BUTTON_NUMBER_SET.shuffled()
        var resultNumberset: [[Int]] = []
        var tempNumberset: [Int] = []
        for index in 0..<shuffledNumbers.count {
            if((index != 0) && (index % 3 == 0)) {
                resultNumberset.append(tempNumberset)
                tempNumberset.removeAll()
            }
            tempNumberset.append(shuffledNumbers[index])
            if index == shuffledNumbers.endIndex - 1 {
                resultNumberset.append(tempNumberset)
            }
        }
        resultNumberset[3].insert(10, at: 0)
        resultNumberset[3].append(11)
        return resultNumberset
    }
    
    //MARK: regex validation
    class func commonValidation(input: String, type: Validation) -> Observable<CommonValidation> {
        return Observable.create { observer in
            if let regex = type.regex {
                let result = NSPredicate(format: "SELF MATCHES %@", regex)
                let validation = result.evaluate(with: input)
                        ? CommonValidation.VALID
                        : CommonValidation.INVALID(type)
                observer.on(.next(validation))
                observer.onCompleted()
            } else {
                observer.on(.next(CommonValidation.INVALID(type)))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    //MARK: pincode validation
    class func validatePinCode(input: String,
                               birthDay: String,
                               phoneMiddleNum: String,
                               phoneLastNum: String) -> Observable<CommonValidation> {
        
        return Observable.create { observer in
            if input.isEmpty {
                observer.on(.next(.INVALID(.PIN(birthDay: birthDay,
                                                phoneLastNumber: phoneLastNum,
                                                phoneMiddleNumber: phoneMiddleNum))))
                observer.onCompleted()
            }
            let pins: [Int] = input.map { Int(String($0)) ?? 0}
            let diffs = zip(pins, pins.dropFirst()).map(-)
            var sequenceValidation: Bool = true
            var equalValidation: Bool = true
            var userValidation: Bool = true
            for i in 0..<diffs.count - 1 {
                if diffs[i] == 1 && diffs[i] == diffs[i+1] { sequenceValidation = false }
                if diffs[i] == -1 && diffs[i] == diffs[i+1] { sequenceValidation = false }
                if diffs[i] == 0 && diffs[i] == diffs[i+1] { equalValidation = false }
            }
            
            let birthDaySuffix = birthDay.suffix(4)
            let birthDayPrefix = (birthDay.prefix(6)).suffix(4)
            if input.contains(birthDaySuffix)
                || input.contains(birthDayPrefix)
                || input.contains(phoneLastNum)
                || input.contains(phoneMiddleNum) {
                userValidation = false
            }
            
            let isValid = sequenceValidation && equalValidation && userValidation
            let validation = isValid
                ? CommonValidation.VALID
                : CommonValidation.INVALID(.PIN(birthDay: birthDay,
                                                phoneLastNumber: phoneLastNum,
                                                phoneMiddleNumber: phoneMiddleNum))
            observer.on(.next(validation))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    class func validateEmpty(input: String) -> Observable<CommonValidation> {
        return Observable.create { observer in
            if input.isEmpty {
                observer.on(.next(.INVALID(.NAME)))
                observer.onCompleted()
            }
            
            observer.on(.next(.VALID))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    class func validateBirthday(input: String) -> Observable<CommonValidation> {
        return Observable.create { observer in
            if input.isEmpty {
                observer.on(.next(.INVALID(.ID_BIRTHDAY)))
                observer.onCompleted()
            }
            
            guard let month = Int((input.prefix(4)).suffix(2)),
                  let day = Int(input.suffix(2)),
                  (1...12).contains(month),
                  (1...31).contains(day) else {
                observer.on(.next(.INVALID(.ID_BIRTHDAY)))
                observer.onCompleted()
                return Disposables.create()
            }
            
            observer.on(.next(.VALID))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    class func validateGender(input: String) -> Observable<CommonValidation> {
        return Observable.create { observer in
            if input.isEmpty {
                observer.on(.next(.INVALID(.ID_GENDER)))
                observer.onCompleted()
            }
           
            guard let input = Int(input) else {
                observer.on(.next(.INVALID(.ID_GENDER)))
                observer.onCompleted()
                return Disposables.create()
            }
            
            if (1...4).contains(input) {
                observer.on(.next(.VALID))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
//    
//    class func generateBioAuthString() -> String {
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        return String((0..<10).map { _ in letters.randomElement()!})
//    }
//
//    class func getBioStatus() -> Observable<BiometricType> {
//        Observable.create { observer in
//            let authContext = LAContext()
//            var authorizationError: NSError?
//            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
//                                                  error: &authorizationError)
//            if let error = authorizationError {
//                //생체인증이 기능을 지원하지만 사용할 수 없는 경우
//                observer.onNext(.NOT_AVAILABLE(reason: ErrorHandler.handleLAContextError(error: error).desc))
//                observer.onCompleted()
//
//            } else {
//                switch(authContext.biometryType) {
//                case .none:
//                    observer.onNext(.NONE)
//                    observer.onCompleted()
//
//                case .touchID:
//                    observer.onNext(.TOUCH_ID)
//                    observer.onCompleted()
//
//                case .faceID:
//                    observer.onNext(.FACE_ID)
//                    observer.onCompleted()
//
//                @unknown default:
//                    observer.onNext(.NONE)
//                    observer.onCompleted()
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    // 현재는 하나의 기기 당 하나의 생체인증을 지원하지만 추후 두가지를 모두 지원하는 경우를 대비하여 분리
//    class func requestBioAuth(context: LAContext = LAContext(),
//                              type: BiometricType,
//                              purpose: AuthPurpose? = nil) -> Observable<AuthResult> {
//        SceneManager.shared.setCoverNeeded(false)
//
//        if let purpose = purpose,
//           purpose == .bioAuthActivation {
//            //bioActivation => skip detecting context change
//            return Observable.getBioContext(context: context)
//                .flatMap { succeed -> Observable<AuthResult> in
//                    guard succeed else {
//                        return .just(.failure(.UNKNOWN))
//                    }
//                    guard let newContext = context.evaluatedPolicyDomainState?.base64EncodedString() else {
//                        return .just(.failure(.KNOWN(title: Strings.Auth.Bio.AUTH_FAILED,
//                                                     reason: Strings.Auth.Bio.CONTEXT_NOT_DEFINED)))
//                    }
//                    //save context
//                    return KeyChainManager.shared.setKeychainString(key: .BIO_CONTEXT, value: newContext)
//                        .flatMap { _ -> Observable<AuthResult> in
//                            return .just(.success)
//                        }
//                }
//                .catch { error -> Observable<AuthResult> in
//                    return .just(.failure(ErrorHandler.convert(error)))
//                }
//        } else {
//            //bioAuth => detecting context change
//            return Observable.combineLatest(KeyChainManager.shared.getKeychainString(key: .BIO_CONTEXT),
//                                            Observable.getBioContext(context: context))
//            .flatMap { oldContext, succeed -> Observable<AuthResult> in
//                guard succeed else {
//                    return .just(.failure(.UNKNOWN))
//                }
//                guard let newContext = context.evaluatedPolicyDomainState?.base64EncodedString() else {
//                    return .just(.failure(.KNOWN(title: Strings.Auth.Bio.AUTH_FAILED,
//                                                 reason: Strings.Auth.Bio.CONTEXT_NOT_DEFINED)))
//                }
//
//                switch oldContext == newContext {
//                case true:
//                    return .just(.success)
//                case false:
//                    return .just(.failure(.KNOWN(title: Strings.Auth.Bio.DOMAIN_STATE_CHANGED,
//                                                 reason: Strings.Auth.Bio.REACTIVATE_BIO)))
//                }
//
//            }
//            .catch { error -> Observable<AuthResult> in
//                return .just(.failure(ErrorHandler.convert(error)))
//            }
//        }
//    }
//}
//
//
//extension ObservableType where Element == Bool {
//    static func getBioContext(context: LAContext) -> Observable<Bool> {
//        return Observable.create { observer in
//            context.localizedFallbackTitle = String.empty
//            //        deviceOwnerAuthenticationWithBiometrics :
//            //        사용자가 생체 인식을 사용하여 인증해야 함을 나타냅니다. Touch ID 또는 Face ID를 사용할 수 없거나 등록하지 않은 경우, policy evaluation이 실패합니다.
//            //        Touch ID 및 Face ID인증은 모두 5회 이상 실패하면 다시 사용할 수 없으므로 다시 사용할려면 장치 암호를 입력해야 합니다.
//
//            //        deviceOwnerAuthentication : device password.
//            //        Touch ID 또는 Face ID가 등록되어 있고, 사용 중지 되지 않은 경우, 사용자에게 먼저 터치하라는 메세지가 표시됩니다.
//            //        그렇지 않은 경우, 장치 암호를 입력하라는 메세지가 표시됩니다. 장치 암호가 활성화되어 있지 않으면, policy evaluation이 실패합니다.
//            //        패스코드 인증은 6회 실패 이후에 비활성화 되며, 지연은 점진적으로 증가합니다.
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
//                                   localizedReason: Strings.Auth.Bio.CHECK) { success, error in
//                if let error = error {
//                    observer.onError(error)
//                }
//
//                observer.onNext(success)
//                observer.onCompleted()
//            }
//
//            return Disposables.create()
//        }
//    }
}
