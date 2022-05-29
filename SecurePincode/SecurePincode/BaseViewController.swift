//
//  BaseViewController.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import ReactorKit
import RxViewController

class BaseViewController<T: Reactor>: UIViewController {
    typealias Reactor = T
    
    //MARK: RxSwift
    var disposeBag = DisposeBag()
    
    var viewEvent = PublishSubject<T.Action>()
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            self.updateConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func configureUI() {
        
    }
    
    func updateConstraints() {
        
    }
    
    func setConstraints() {
        
    }
}
