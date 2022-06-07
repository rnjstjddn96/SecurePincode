//
//  PincodeUpdateViewController.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import ReactorKit

class PincodeUpdateViewController: BaseViewController<PincodeUpdateReactor> {
    var keypadSecureIndicator = UIView()
    
    let lockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "lock")
        return imageView
    }()
    
    let secureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = Strings.Register.Pincode.USING_SECURE_KEYPAD
        label.textColor = .lightGray
        return label
    }()
    
    lazy var inputGuideMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var inputWarningMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    lazy var btnRestrictedNumberGuide: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.Register.Pincode.RESTRICTED_NUMBER, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
       
    lazy var btnReset: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.Register.Pincode.INPUT_RESET, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    override func configureUI() {
        self.view.backgroundColor = .systemBackground

    }
}

extension PincodeUpdateViewController {
    private func setKeypad(keypad: KeypadViewController) {
        
        let KEYPAD_HEIGHT = 85.asPercent(with: .WIDTH)
        keypad.willMove(toParent: self)
        self.addChild(keypad)
        self.view.addSubview(keypad.view)
        keypad.didMove(toParent: self)
        
        keypad.view.snp.makeConstraints { create in
            create.left.right.bottom.equalToSuperview()
            create.height.equalTo(KEYPAD_HEIGHT)
        }
        
//        let keypadIncomingAnimation = AnimationType.from(direction: .bottom,
//                                                   offset: KEYPAD_HEIGHT)
//
//        let keypadSecureMessageIncomingAnimation
//            = AnimationType.vector(.zero)
        
        self.setKeypadSecureMessageView(keypad: keypad.buttonStack)
        
//        loadingIndicator.view.sendSubviewToBack(keypad.view)
//        loadingIndicator.view.sendSubviewToBack(keypadSecureIndicator)
        
//        UIView.animate(views: [keypad.view],
//                       animations: [keypadIncomingAnimation],
//                       duration: 0.5)
//
//        UIView.animate(views: [self.keypadSecureIndicator],
//                       animations: [keypadSecureMessageIncomingAnimation],
//                       duration: 1.4)
    }
    
    private func setPinStackView(pinStackView: PinStackView) {
        
        self.view.addSubview(pinStackView)
        pinStackView.snp.makeConstraints { [weak self] create in
            guard let _ = self else { return }
            create.centerX.equalToSuperview()
            create.top.equalToSuperview()
                .offset(40.asPercent(with: .WIDTH))
            create.width.equalTo(pinStackView.pinStackWidth)
            create.height.equalTo(pinStackView.pinType.size)
        }
        
        self.setInputGuideMessage(pinStackView: pinStackView)
        self.setInputWarningMessage(pinStackView: pinStackView)
        self.setBtnRestrictedNumberGuide()
        self.setBtnReset()
    }
}

extension PincodeUpdateViewController {
    private func setKeypadSecureMessageView(keypad: UIView) {
        self.view.addSubview(keypadSecureIndicator)
        keypadSecureIndicator.addSubview(lockImage)
        keypadSecureIndicator.addSubview(secureLabel)
        
        keypadSecureIndicator.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.centerX.equalToSuperview()
            create.bottom.equalTo(keypad.snp.top)
                .offset(-5.3.asPercent(with: .WIDTH))
            create.width.lessThanOrEqualTo(self.view)
            create.height.equalTo(4.2.asPercent(with: .WIDTH))
        }
        
        lockImage.snp.makeConstraints { create in
            create.left.top.bottom.equalToSuperview()
            create.width.equalTo(2.9.asPercent(with: .WIDTH))
        }
        
        secureLabel.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.right.height.equalToSuperview()
            create.left.equalTo(self.lockImage.snp.right)
                .offset(1.6.asPercent(with: .WIDTH))
        }
    }
    
    private func setInputGuideMessage(pinStackView: PinStackView) {
        self.view.addSubview(inputGuideMessage)
        inputGuideMessage.text = Strings.Register.Pincode.INPUT_PIN_NUMBER
        inputGuideMessage.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.bottom.equalTo(pinStackView.snp.top)
                .offset(-5.8.asPercent(with: .WIDTH))
            create.centerX.equalToSuperview()
            create.width.lessThanOrEqualTo(self.view)
        }
    }
    
    private func setInputWarningMessage(pinStackView: PinStackView) {
        self.view.addSubview(inputWarningMessage)
        inputWarningMessage.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.top.equalTo(pinStackView.snp.bottom)
                .offset(5.8.asPercent(with: .WIDTH))
            create.centerX.equalToSuperview()
            create.width.lessThanOrEqualTo(self.view)
            create.height.equalTo(9.asPercent(with: .WIDTH))
        }
    }
    
    private func setBtnRestrictedNumberGuide() {
        self.view.addSubview(btnRestrictedNumberGuide)
        btnRestrictedNumberGuide.isHidden = true
        btnRestrictedNumberGuide.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.top.equalTo(self.inputWarningMessage.snp.bottom)
                .offset(5.7.asPercent(with: .WIDTH))
            create.centerX.equalToSuperview()
            create.width.lessThanOrEqualTo(self.view)
        }
    }
    
    private func setBtnReset() {
        self.view.addSubview(btnReset)
        btnReset.isHidden = true
        btnReset.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.top.equalTo(self.inputWarningMessage.snp.bottom)
                .offset(5.7.asPercent(with: .WIDTH))
            create.centerX.equalToSuperview()
            create.width.lessThanOrEqualTo(self.view)
        }
    }
    
    private func mutateInputGuideMessage(didValidate: Bool) {
        self.inputGuideMessage.text = didValidate ?
            Strings.Register.Pincode.INPUT_PIN_NUMBER_AGAIN : Strings.Register.Pincode.INPUT_PIN_NUMBER
    }
    
    private func mutateInputWarningMessage(validation: CommonValidation) {
        self.inputWarningMessage.text = validation.desc ?? ""
    }
    
    private func mutateBtnRestrictedNumberGuide(didValidate: Bool) {
        if didValidate {
            btnRestrictedNumberGuide.isHidden = true
            btnReset.isHidden = false
        } else {
            btnReset.isHidden = true
            btnRestrictedNumberGuide.isHidden = false
        }
    }
}

extension PincodeUpdateViewController: View {
    func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.getKeypad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map { Reactor.Action.getPinStack }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        btnReset.rx
            .controlEvent(.touchUpInside)
            .map { Reactor.Action.resetAll }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        btnRestrictedNumberGuide.rx
//            .controlEvent(.touchUpInside)
//            .bind { [weak self] _ in
//                guard let self = self else { return }
//                AlertUtils.displayBottomSheet(parent: self,
//                                              popupViewController: PinRestrictedGuideView(),
//                                              shrinkPresentingViewController: true,
//                                              sizes: [.fixed(56.asPercent(with: .WIDTH))])
//            }
//            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.keypad }
            .distinctUntilChanged()
            .bind { [weak self] keypad in
                guard let self = self else { return }
                if let _keypad = keypad {
                    self.setKeypad(keypad: _keypad)
                }
//                else {
//                    self.removeChild()
//                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.pinStackView }
            .distinctUntilChanged()
//            .filterNil()
            .filter { $0 != nil }
            .bind { [weak self] pinStack in
                guard let self = self else { return }
                self.setPinStackView(pinStackView: pinStack!)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.didValidateInput }
            .skip(2)
            .distinctUntilChanged()
            .bind { [weak self] didValidate in
                guard let self = self else { return }
                self.mutateInputGuideMessage(didValidate: didValidate)
                self.mutateBtnRestrictedNumberGuide(didValidate: didValidate)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validation }
            .distinctUntilChanged()
            .bind { [weak self] validation in
                guard let self = self else { return }
                self.mutateInputWarningMessage(validation: validation)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.didMatch }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in
                Reactor.Action.savePincode
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shouldDismiss }
            .distinctUntilChanged()
            .bind { [weak self] dismiss in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
//        reactor.state
//            .map { $0.didUpdatePincode }
//            .distinctUntilChanged()
//            .bind { [weak self] didUpdatePincode in
//                guard let _ = self,
//                      didUpdatePincode else { return }
//                AlertUtils.displayToast(message: Strings.Auth.Pincode.PINCODE_UPDATED,
//                                        duration: 0.5)
//
//            }
//            .disposed(by: disposeBag)
    }
}
