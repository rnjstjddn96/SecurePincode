//
//  KeypadViewController.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import ReactorKit

class KeypadViewController: BaseViewController<KeypadViewReactor> {
    let buttonStack:  UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2.5.asPercent(with: .WIDTH)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemBlue
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.directionalLayoutMargins =
            NSDirectionalEdgeInsets(top: 5.asPercent(with: .WIDTH),
                                    leading: 2.5.asPercent(with: .WIDTH),
                                    bottom: 5.asPercent(with: .WIDTH),
                                    trailing: 2.5.asPercent(with: .WIDTH))
        
        return stackView
    }()

    override func configureUI() {
        self.view.backgroundColor = .systemBlue
        self.view.addSubview(buttonStack)
       
    }
    
    override func setConstraints() {
        buttonStack.snp.makeConstraints { create in
            create.height.equalToSuperview()
            create.left.right.bottom.equalToSuperview()
        }
    }
    
    private func initNumberButtons(numberSet: [[Int]]) {
        buttonStack.layoutIfNeeded()
        self.buttonStack.removeAllArrangedSubviews()
        
        numberSet.forEach { [weak self] set in
            guard let self = self else { return }
            
            let stringSet: [String] = set.map { num -> String in
                return String(num)
            }
            let stackView = UIStackView(arrangedSubviews: self.createStackViewButtions(stringSet))
            stackView.axis = .horizontal
            stackView.spacing = 2.5.asPercent(with: .WIDTH)
            stackView.distribution = .fillEqually
            self.buttonStack.addArrangedSubview(stackView)
        }
    }
    
    private func createStackViewButtions(_ names: [String]) -> [UIButton] {
        let buttons = names.indices.map { [weak self] index -> UIButton in
            guard let self = self else { return UIButton() }
            let button = UIButton()

            button.withSelectionColor(disposeBag: self.disposeBag,
                                      selectedColor: .lightText)
            button.withSelectionEffect(disposeBag: self.disposeBag,
                                       scaleEffect: (scaleX: 0.95, y: 0.95))
            button.layer.cornerRadius = 10
            
            switch names[index] {
            case "10":
                button.backgroundColor = .systemBlue

            case "11":
                button.backgroundColor = .systemBlue
                button.adjustsImageWhenHighlighted = false
                button.setImage(UIImage(named: "backspace"), for: .normal)
                
                button.rx
                    .controlEvent(.touchUpInside)
                    .map { Reactor.Action.makeInput(input: .delete) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)

            default:
                button.titleLabel?.font = .systemFont(ofSize: 24)
                button.backgroundColor = .systemBlue
                button.setTitleColor(.systemBackground, for: .normal)
                button.setTitle(names[index], for: .normal)
                
                button.rx
                    .controlEvent(.touchUpInside)
                    .map { Reactor.Action.makeInput(input: .number(number: names[index])) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
            }

            return button
        }
        
        return buttons
    }
}

extension KeypadViewController: View {
    func bind(reactor: KeypadViewReactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.generateNumbers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.numberSet }
            .distinctUntilChanged()
            .bind { [weak self] in
                guard let self = self else { return }
                self.initNumberButtons(numberSet: $0)
            }
            .disposed(by: disposeBag)
    }
}


