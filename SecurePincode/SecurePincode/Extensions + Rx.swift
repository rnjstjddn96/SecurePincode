//
//  Extensions.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UIView { 
    func showSelectionAnimation(selected: Bool, scaleEffect: (scaleX: CGFloat, y: CGFloat)) {
        if selected {
              UIView.animate(withDuration: 0.1,
                             delay: 0,
                             options: [.curveLinear, .allowUserInteraction],
                             animations: { [weak self] in
                  guard let self = self else { return }
                  self.transform = CGAffineTransform(scaleX: scaleEffect.scaleX,
                                                     y: scaleEffect.y)
                             })
        } else {
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: [.curveLinear, .allowUserInteraction],
                           animations: { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
}

extension Double {
    enum SizeFactor {
        case WIDTH, HEIGHT
        
        var size: CGFloat {
            switch self {
            case .WIDTH:
                return SIZE.width
            case .HEIGHT:
                return SIZE.height
            }
        }
    }
    
    func asPercent(with sizeFactor: SizeFactor) -> CGFloat {
        return CGFloat(Double(sizeFactor.size) * (self / 100))
    }
    
    func asWidthPercent() -> CGFloat {
        return ((self / 375) * 100).asPercent(with: .WIDTH)
    }
    
    func asHeightPercent() -> CGFloat {
        return ((self / 812) * 100).asPercent(with: .WIDTH)
    }
}

extension UIButton {
    func withSelectionEffect(disposeBag: DisposeBag,
                             scaleEffect: (scaleX: CGFloat, y: CGFloat)) {
        self.rx
            .controlEvent(.touchDown)
            .bind { [weak self] in
                guard let self = self else { return }
                self.showSelectionAnimation(selected: true,
                                            scaleEffect: scaleEffect)
            }
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchCancel)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.showSelectionAnimation(selected: false,
                                            scaleEffect: scaleEffect)
            }
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchUpInside)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.showSelectionAnimation(selected: false,
                                            scaleEffect: scaleEffect)
            }
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchUpOutside)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.showSelectionAnimation(selected: false,
                                            scaleEffect: scaleEffect)
            }
            .disposed(by: disposeBag)
    }
    
    func withSelectionColor(disposeBag: DisposeBag,
                            selectedColor: UIColor) {
        self.rx
            .controlEvent(.touchDown)
            .map { selectedColor }
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchCancel)
            .map { .clear }
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchUpInside)
            .map { .clear }
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.touchUpOutside)
            .map { .clear }
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
