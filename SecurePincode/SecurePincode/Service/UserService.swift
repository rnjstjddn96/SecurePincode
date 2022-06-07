//
//  UserService.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import RxSwift

protocol UserServiceProtocol {
    func updatePincode() -> Observable<Bool>
}

class UserService: UserServiceProtocol {
    //TODO: API 연동
    func updatePincode() -> Observable<Bool> {
        return .just(true)
    }
}
