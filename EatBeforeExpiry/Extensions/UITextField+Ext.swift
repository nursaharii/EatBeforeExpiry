//
//  UITextField+Ext.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 19.12.2023.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
