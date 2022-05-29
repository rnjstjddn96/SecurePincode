//
//  PinView.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit
import SnapKit

class PinDotView: UIView {
    let EMPTY_DOT_CONTENT_SIZE = 2.3.asPercent(with: .WIDTH)
    
    lazy var emptyDotView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = EMPTY_DOT_CONTENT_SIZE / 2
        return view
    }()
    
    init(frame: CGRect = .zero,
         isEmpty: Bool) {
        
        super.init(frame: frame)
        self.configure(isEmpty: isEmpty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(isEmpty: Bool) {
        if isEmpty {
            self.backgroundColor = .clear
            self.addSubview(emptyDotView)
            emptyDotView.snp.makeConstraints { create in
                create.center.equalToSuperview()
                create.width.height.equalTo(EMPTY_DOT_CONTENT_SIZE)
            }
        } else {
            self.backgroundColor = .red
        }
    }
}

class PinRectView: UIView {
    let coreDotView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = PinType.rect.size / 6
        return view
    }()
    
    init(frame: CGRect = .zero,
         isEmpty: Bool) {
        super.init(frame: frame)
        
        if isEmpty {
            self.backgroundColor = .lightGray
        } else {
            self.backgroundColor = .red
            initCoreDotView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCoreDotView() {
        self.addSubview(coreDotView)
        
        coreDotView.snp.makeConstraints { create in
            create.center.equalToSuperview()
            create.width.height.equalToSuperview()
                .dividedBy(3)
        }
    }
}
