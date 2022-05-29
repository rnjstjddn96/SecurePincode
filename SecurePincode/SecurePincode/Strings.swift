//
//  Strings.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation

extension String {
    static let empty: String = ""
}

enum Strings {
    struct Register {
        struct Input {
            static let DESCRIPTION_NAME = "이름을 입력해주세요."
            static let DESCRIPTION_ID = "주민등록번호를 입력해주세요."
            static let DESCRIPTION_PHONE = "휴대폰 번호를 입력해주세요."
            static let DESCRIPTION_CONFIRM = "정보를 확인해주세요."
            static let DESCRIPTION_AGENCY = "통신사를 선택해주세요."
            
            static let INVALID_ID = "올바른 주민등록번호를 입력해주세요."
            static let INVALID_PHONE_NUMBER = "올바른 휴대폰 번호를 입력해주세요."
            static let INVALID_NAME = "올바른 이름을 입력해주세요."
            
            static let CONFIRM = "확인"
            static let TO_USER_AUTH = "본인인증하기"
        }
        
        struct Pincode {
            static let USING_SECURE_KEYPAD = "보안 키패드가 작동중입니다."
            static let INPUT_CURRENT_NUMBER = "현재 PIN 번호를 입력해주세요"
            static let INPUT_PIN_NUMBER = "새로운 PIN 번호 6자리를 입력해주세요"
            static let INPUT_PIN_NUMBER_AGAIN = "다시 한 번 입력해주세요"
            static let INPUT_CONTAINS_RESTRICTED_NUMBER = "등록 제한 번호가 포함 되어 있습니다.\n다시 입력해주세요"
            static let INPUT_NOT_MATCHES = "ⓛ 새로운 PIN 번호 입력값이 일치하지 않습니다"
            static let RESTRICTED_NUMBER = "등록 제한 번호 ?⃝"
            static let INPUT_RESET = "다시 입력"
            static let RESTRICTED_NUMBER_TITLE = "등록 제한 번호 안내"
            static let RESTRICTED_NUMBER_CONTENT = "연속된 3자리 숫자(ex. 123), 동일한 3자리 숫자 반복(ex.111), 생년월일, 휴대폰번호는 사용이 불가합니다."
        }
    }
}

