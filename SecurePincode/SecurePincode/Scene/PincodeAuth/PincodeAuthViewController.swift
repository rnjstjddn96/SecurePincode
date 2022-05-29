//
//  PincodeAuthViewController.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import ReactorKit
import RxCocoa

class PincodeAuthViewController: BaseViewController<PincodeAuthReactor> {
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "PIN 번호 입력"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
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
        label.textColor = .gray
        return label
    }()
    
    override func configureUI() {
        self.view.backgroundColor = .clear
        self.view.addSubview(contentView)
        self.view.bringSubviewToFront(self.contentView)
        
        view.isOpaque = false
        self.preferredContentSize = CGSize(width: SIZE.width,
                                           height: 132.5.asPercent(with: .WIDTH))
        
        contentView.addSubview(descriptionLabel)
        contentView.layer.cornerRadius = 30
    }
    
    override func setConstraints() {
        contentView.snp.makeConstraints { create in
            create.left.right.bottom.equalToSuperview()
            create.height.equalTo(132.5.asPercent(with: .WIDTH))
        }
        descriptionLabel.snp.makeConstraints { create in
            create.top.equalToSuperview()
                .offset(11.4.asPercent(with: .WIDTH))
            create.centerX.equalToSuperview()
            create.width.lessThanOrEqualToSuperview()
        }
    }
}

extension PincodeAuthViewController {
    private func setKeypad(keypad: KeypadViewController) {
        let KEYPAD_HEIGHT = 85.asPercent(with: .WIDTH)
        keypad.willMove(toParent: self)
        self.addChild(keypad)
        self.contentView.addSubview(keypad.view)
        keypad.didMove(toParent: self)
        keypad.view.snp.makeConstraints { create in
            create.left.right.bottom.equalToSuperview()
            create.height.equalTo(KEYPAD_HEIGHT)
        }

        self.setKeypadSecureMessageView(keypad: keypad.buttonStack)
    }
    
    private func setPinStackView(pinStackView: PinStackView) {
        self.contentView.addSubview(pinStackView)
        
        pinStackView.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.centerX.equalToSuperview()
            create.top.equalTo(self.contentView)
                .offset(22.9.asPercent(with: .WIDTH))
            create.width.equalTo(pinStackView.pinStackWidth)
            create.height.equalTo(pinStackView.pinType.size)
        }
    }
}

extension PincodeAuthViewController {
    private func setKeypadSecureMessageView(keypad: UIView) {
        self.contentView.addSubview(keypadSecureIndicator)
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
}

extension PincodeAuthViewController: View {
    func bind(reactor: PincodeAuthReactor) {
        self.rx
            .viewDidLoad
            .map { Reactor.Action.`init` }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        reactor.state
            .map { $0.keypad }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .bind { [weak self] keypad in
                guard let self = self else { return }
                self.setKeypad(keypad: keypad!)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.pinStackView }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .bind { [weak self] pinStack in
                guard let self = self else { return }
                self.setPinStackView(pinStackView: pinStack!)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shouldDismiss }
            .distinctUntilChanged()
            .bind { [weak self] in
                guard let self = self, $0 else { return }
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
    }
}
