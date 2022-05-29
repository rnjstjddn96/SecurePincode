//
//  PinStackView.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PinStackView: UIView {
    var disposeBag = DisposeBag()
    var inputRelay: BehaviorRelay<String>
    
    let maxCount: Int
    let pinType: PinType
    
    lazy var pinStackWidth: CGFloat =
        (pinType.size * CGFloat(maxCount)) + (pinType.spaceSize * CGFloat(maxCount - 1))
    
    init(frame: CGRect = .zero,
         maxCount: Int,
         type: PinType,
         inputRelay: BehaviorRelay<String>) {
        
        self.inputRelay = inputRelay
        self.maxCount = maxCount
        self.pinType = type
        super.init(frame: frame)
        
        self.initPinStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initPinStackView() {
        let pinStackView: UIStackView = {
            let pinStack = UIStackView()
            pinStack.axis = .horizontal
            pinStack.alignment = .center
            pinStack.distribution = .equalSpacing
            return pinStack
        }()
        
        self.addSubview(pinStackView)
        pinStackView.snp.makeConstraints { create in
            create.left.right.top.bottom.equalToSuperview()
        }
        
        inputRelay
            .asObservable()
            .bind { [weak self] input in
                guard let self = self else { return }
                pinStackView.removeAllArrangedSubviews()
                
                self.createdPinStack(input: input).forEach { [weak self] view in
                    guard let self = self else { return }
                    view.layer.cornerRadius = self.pinType.cornerRadius
                    view.snp.makeConstraints { [weak self] create in
                        guard let self = self else { return }
                        create.height.width.equalTo(self.pinType.size)
                    }
                    pinStackView.addArrangedSubview(view)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getSinglePin(hasValue: Bool) -> UIView {
        return hasValue ? pinType.view : pinType.emptyView
    }
    
    private func createdPinStack(input: String) -> [UIView] {
        var inputsAsArray: [String] = []
        
        input.forEach { num in
            inputsAsArray.append(String(num))
        }
        let remainingCount = self.maxCount - inputsAsArray.count
        for _ in 0 ..< remainingCount {
            inputsAsArray.append("")
        }
        
        let pins = inputsAsArray.indices.map { [weak self] index -> UIView in
            guard let self = self else { return UIView() }
            return inputsAsArray[index].isEmpty ? self.pinType.emptyView : self.pinType.view
        }
        
        return pins
    }
}


