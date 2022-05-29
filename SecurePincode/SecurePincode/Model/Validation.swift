//
//  Validation.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import RxSwift

enum CommonValidation {
    case NOT_MATCHED
    case MATCHED
    case VALID
    case INVALID(_ type: Validation)
    case NONE
    
    var id: Int {
        switch self {
        case .NONE:
            return 0
        case .VALID:
            return 1
        case .INVALID:
            return 2
        case .MATCHED:
            return 3
        case .NOT_MATCHED:
            return 4
        }
    }
    
    var value: Bool {
        switch self {
        case .INVALID:
            return false
        case .NOT_MATCHED:
            return false
        case .VALID:
            return true
        case .MATCHED:
            return true
        case .NONE:
            return false
        }
    }
    
    var desc: String? {
        switch self {
        case .INVALID(let type):
            switch type {
            case .PHONE_NUMBER:
                return Strings.Register.Input.INVALID_PHONE_NUMBER
            case .ID_BIRTHDAY:
                return Strings.Register.Input.INVALID_ID
            case .ID_GENDER:
                return Strings.Register.Input.INVALID_ID
            case .EMAIL:
                return Strings.Register.Input.INVALID_PHONE_NUMBER
            case .PASSWORD:
                return Strings.Register.Input.INVALID_PHONE_NUMBER
            case .NAME:
                return Strings.Register.Input.INVALID_NAME
            case .PIN:
                return Strings.Register.Pincode.INPUT_CONTAINS_RESTRICTED_NUMBER
            }
            
        case .NOT_MATCHED:
            return Strings.Register.Pincode.INPUT_NOT_MATCHES
        case .MATCHED:
            return nil
        case .VALID:
            return nil
        case .NONE:
            return nil
        }
    }
}

extension CommonValidation: Equatable {
    static func == (lhs: CommonValidation, rhs: CommonValidation) -> Bool {
        return lhs.id == rhs.id
    }    
}

enum Validation {
    case EMAIL
    case PASSWORD
    case NAME
    case PHONE_NUMBER
    case ID_BIRTHDAY
    case ID_GENDER
    
    case PIN(birthDay: String,
             phoneLastNumber: String,
             phoneMiddleNumber: String)
    
    var regex: String? {
        switch self {
        case .EMAIL:
            return "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$"
        case .PASSWORD:
            return "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@.#\\$%^&*?_~]).{8,50}"
        case .PHONE_NUMBER:
            return "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        default:
            return nil
        }
    }
}

final class ValidationUtils {
    class func isValid(input: String?, type: Validation) -> Observable<CommonValidation> {
        guard let input = input else { return .just(.INVALID(type)) }
        switch type {
        case .PIN(let birthDay, let phoneLastNumber, let phoneMiddleNumber):
            return AuthUtils.validatePinCode(input: input,
                                             birthDay: birthDay,
                                             phoneMiddleNum: phoneMiddleNumber,
                                             phoneLastNum: phoneLastNumber)
        case .NAME:
            return AuthUtils.validateEmpty(input: input)
            
        case .ID_BIRTHDAY:
            return AuthUtils.validateBirthday(input: input)
            
        case .ID_GENDER:
            return AuthUtils.validateGender(input: input)

        default:
            return AuthUtils.commonValidation(input: input, type: type)
        }
    }
}
