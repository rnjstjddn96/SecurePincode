//
//  ViewController.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let btnoOpenPincodeAuthView: UIButton = {
        let button = UIButton()
        button.setTitle("핀코드 인증 호출", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let btnoOpenPincodeUpdateView: UIButton = {
        let button = UIButton()
        button.setTitle("핀코드 설정 호출", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(btnoOpenPincodeAuthView)
        self.view.addSubview(btnoOpenPincodeUpdateView)
        
        btnoOpenPincodeAuthView.rx
            .controlEvent(.touchUpInside)
            .bind { [weak self] in
                guard let self = self else { return }
                let pincodeViewController = PincodeAuthViewController()
                pincodeViewController.reactor = PincodeAuthReactor(
                    pinAuthService: PinAuthService(),
                    keypadService: KeypadService(maxCount: 6)
                )
                self.present(pincodeViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        btnoOpenPincodeUpdateView.rx
            .controlEvent(.touchUpInside)
            .bind { [weak self] in
                guard let self = self else { return }
                let pincodeUpdateViewController = PincodeUpdateViewController()
                pincodeUpdateViewController.reactor = PincodeUpdateReactor(
                    keypadService: KeypadService(maxCount: 6),
                    userService: UserService())
                self.navigationController?.pushViewController(pincodeUpdateViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnoOpenPincodeAuthView.snp.makeConstraints { [weak self] create in
            guard let _ = self else { return }
            create.center.equalToSuperview()
        }
        
        self.btnoOpenPincodeUpdateView.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.centerX.equalToSuperview()
            create.top.equalTo(self.btnoOpenPincodeAuthView.snp.bottom)
        }
    }


}

