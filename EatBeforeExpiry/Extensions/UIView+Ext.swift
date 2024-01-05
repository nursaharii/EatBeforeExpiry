//
//  UIView+Ext.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 15.12.2023.
//

import Foundation

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var bottomRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            clipsToBounds = newValue > 0
            
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var topRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    func addTopBorders(color: UIColor) {
        let thickness: CGFloat = 1.0
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: thickness)
        topBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(topBorder)
    }

    func addShadow() {
        layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.15).cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = cornerRadius
        layer.masksToBounds = false
    }
    func addShadow(offset: Int, alpha: CGFloat) {
        layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: alpha).cgColor
        layer.shadowOffset = CGSize(width: offset, height: offset)  //Here you control x and y
        layer.shadowOpacity = 1
        layer.shadowRadius = cornerRadius
        layer.masksToBounds = false
    }
    func addBottomShadow() {
        layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.2).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.masksToBounds = false
    }
    func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
