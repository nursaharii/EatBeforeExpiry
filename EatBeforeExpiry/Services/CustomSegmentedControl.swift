//
//  CustomSegmentedControl.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 5.01.2024.
//

import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var commaSeperatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        buttons.removeAll()
        subviews.forEach{ $0.removeFromSuperview() }
        
        let buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont(name: "Archivo_Condensed-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor .constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
        updateView()
    }
     
    @objc func buttonTapped(button: UIButton){
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.2) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
        
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    func indexChanged(index: Int) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if index == buttonIndex {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.2) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
        
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .touchUpInside)
    }
    
}
