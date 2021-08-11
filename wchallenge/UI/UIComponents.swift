//
//  UIComponents.swift
//  wchallenge
//
//  Created by Diego Hernandez on 9/08/21.
//

import Foundation
import UIKit

extension UIColor {
    static var appMainColor: UIColor {
        return UIColor(named: "primaryColor") ?? UIColor.color255Values(red: 0, green: 143, blue: 233, alpha: 1)
    }
    
    static var appSecondaryColor: UIColor {
        return UIColor(named: "secondaryColor") ?? UIColor.color255Values(red: 85, green: 191, blue: 240, alpha: 1)
    }
    
    static var appTextColor: UIColor {
        return UIColor(named: "textColor") ?? UIColor.color255Values(red: 41, green: 41, blue: 41, alpha: 1)
    }
    
    static var appSuccessColor: UIColor {
        return UIColor(named: "successColor") ?? UIColor.color255Values(red: 22, green: 201, blue: 141, alpha: 1)
    }
    
    static var appErrorColor: UIColor {
        return UIColor(named: "errorColor") ?? UIColor.color255Values(red: 216, green: 70, blue: 99, alpha: 1)
    }
    
    static var appEmergencyColor: UIColor {
        return UIColor(named: "emergencyColor") ?? UIColor.color255Values(red: 234, green: 117, blue: 95, alpha: 1)
    }
    
    static var appDefaultColor: UIColor {
        return UIColor(named: "defaultColor") ?? UIColor.color255Values(red: 230, green: 231, blue: 232, alpha: 1)
    }
    
    static var appInactiveColor: UIColor {
        return UIColor(named: "inactiveColor") ?? UIColor.color255Values(red: 109, green: 110, blue: 113, alpha: 1)
    }
    
    static var appBackgroundColor: UIColor {
        return UIColor(named: "backgroundColor") ?? UIColor.color255Values(red: 236, green: 236, blue: 225, alpha: 1)
    }
}

class WButton: UIButton {
    
    enum ButtonStyle {
        case primary
        case secondary
        case third
        case dropdown
    }
    
    var buttonStyle = ButtonStyle.primary
    
    @available(*, unavailable, message: "Reserved for Interface Bulder use 'buttonStyle' enum instead")
    @IBInspectable var buttonStyleName: String? {
        willSet {
            guard let name = newValue else { return }
            switch name {
            case "primary":
                buttonStyle = .primary
            case "secondary":
                buttonStyle = .secondary
            case "third":
                buttonStyle = .third
            case "dropdown":
                buttonStyle = .dropdown
            default:
                buttonStyle = .primary
            }
        }
    }
    
    func reloadStyleButton(){
        setupStyle()
    }
    
    fileprivate var normalBgColor: UIColor!
    fileprivate var disabledBgColor: UIColor!
    fileprivate var highlightedBgColor: UIColor!
    fileprivate var rightImageView: UIImageView?
    
    override var isHighlighted: Bool {
        didSet {
            updateBgColor()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateBgColor()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: self.traitCollection) ?? false {
                setupStyle()
            }
        }
    }
    
    fileprivate func setupStyle() {
        contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        layer.cornerRadius = 5
        switch buttonStyle {
        case .primary:
            rightImageView?.removeFromSuperview()
            rightImageView = nil
            layer.borderWidth = 0
            normalBgColor = UIColor(named: "primaryColor")
            disabledBgColor = UIColor.gray
            setBackgroundImage(UIImage(named: "img_main button"), for: .normal)
            layer.cornerRadius = 20
            clipsToBounds = true
            titleLabel?.font = AppFont.boldFont(size: 18)
            //highlightedBgColor = UIColor.color255Values(red: 0, green: 171, blue: 163, alpha: 1)
            setTitleColor(UIColor.white, for: UIControl.State())
            updateBgColor()
        case .secondary:
            let borderUIColor = UIColor(named: "secondaryColor")
            layer.borderWidth = 2
            layer.borderColor = borderUIColor?.cgColor
            normalBgColor = nil
            setBackgroundImage(nil, for: .normal)
            titleLabel?.font = AppFont.boldFont(size: 18)
            layer.cornerRadius = 20
            clipsToBounds = true
            setTitleColor(UIColor(named: "secondaryColor") ?? UIColor.black, for: UIControl.State())
            updateBgColor()
        case .third:
            let borderUIColor = UIColor(named: "dropdowBorderColor")
            layer.borderWidth = 2
            layer.borderColor = borderUIColor?.cgColor
            normalBgColor = UIColor(named: "dropdownBtnBgColor") ?? UIColor.white
            layer.cornerRadius = 20
            clipsToBounds = true
            titleLabel?.font = AppFont.boldFont(size: 18)
            setTitleColor(UIColor(named: "dropdownTextColor") ?? UIColor.black, for: UIControl.State())
            updateBgColor()
        case .dropdown:
            let borderUIColor = UIColor(named: "dropdowBorderColor") ?? UIColor.color255Values(red: 230, green: 230, blue: 230, alpha: 1)
            if rightImageView == nil {
                let imgView = UIImageView(image: UIImage(named: "chevron.down"))
                var vFrame = imgView.frame
                let separation: CGFloat = 8
                let x = frame.size.width - vFrame.size.width - (separation * 2)
                let y = (frame.size.height/2.0) - (vFrame.size.height/2.0)
                vFrame.origin.x = x
                vFrame.origin.y = y
                imgView.frame = vFrame
                imgView.tintColor = borderUIColor
                self.addSubview(imgView)
                let rightInset = vFrame.width - separation
                if titleEdgeInsets.right < (rightInset) {
                    var insets = titleEdgeInsets
                    insets.right = rightInset
                    titleEdgeInsets = insets
                }
                rightImageView = imgView
            }
            layer.borderWidth = 2
            layer.borderColor = borderUIColor.cgColor
            normalBgColor = UIColor(named: "dropdownBtnBgColor") ?? UIColor.white
            titleLabel?.font = AppFont.mediumFont(size: 18)
            setTitleColor(UIColor(named: "dropdownTextColor") ?? UIColor.black, for: UIControl.State())
            updateBgColor()
        }
    }
    
    fileprivate func updateBgColor() {
        backgroundColor = isHighlighted ? highlightedBgColor : normalBgColor
        backgroundColor = isEnabled ? normalBgColor : disabledBgColor
    }
}


class WLabel: UILabel {
    
    var appTextStyle = AppFont.TextStyle.label
    
    @IBInspectable var customFontStyle: String?
    
    @IBInspectable var customFontSize: CGFloat = 18
    
    @IBInspectable var appTextStyleName: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    fileprivate func setupFontStyle() {
        guard let name = appTextStyleName else { return }
        switch name {
        case "label":
            appTextStyle = .label
        case "heading1":
            appTextStyle = .heading1
        case "heading2":
            appTextStyle = .heading2
        case "heading3":
            appTextStyle = .heading3
        case "heading4":
            appTextStyle = .heading4
        case "heading5":
            appTextStyle = .heading5
        case "heading6":
            appTextStyle = .heading6
        case "link":
            appTextStyle = .link
        case "body":
            appTextStyle = .bodyText
        case "small":
            appTextStyle = .small
        case "custom":
            appTextStyle = AppFont.TextStyle.custom(customFontStyle ?? "regular", customFontSize)
        default:
            appTextStyle = .label
        }
    }
    
    fileprivate func setupStyle() {
        setupFontStyle()
        updateFont()
    }
    
    fileprivate func updateFont() {
        textColor = UIColor.appTextColor
        font = UIFont.appFontForStyle(appTextStyle)
    }
}

extension UIColor {
    static func color255Values(red:Int, green:Int, blue:Int, alpha:CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}

extension UIFont {
    static func appFontForStyle(_ style:AppFont.TextStyle) -> UIFont {
        return AppFont.fontForStyle(style)
    }
}

class WTextField: UITextField {
    
    var normalBorderColor = UIColor(named: "dropdowBorderColor") ?? UIColor.color255Values(red: 230, green: 230, blue: 230, alpha: 1)
    var editingBorderColor = UIColor.appMainColor
    
    fileprivate var registerd = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: self.traitCollection) ?? false {
                setupStyle()
            }
        }
    }
    
    fileprivate func setupStyle() {
        if !registerd {
            registerd = true
            NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEndEditing(_:)), name: UITextField.textDidEndEditingNotification, object: self)
        }
        
        layer.cornerRadius = 6
        layer.borderWidth = 2
        layer.borderColor = normalBorderColor.cgColor
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
        font = AppFont.regularFont(size: 18)
    }
    
    @objc fileprivate func onTextDidBeginEditing( _ notification: Notification? ) {
        layer.borderColor = editingBorderColor.cgColor
    }
    
    @objc fileprivate func onTextDidEndEditing( _ notification: Notification? ) {
        layer.borderColor = normalBorderColor.cgColor
    }
}

struct AppFont {
    /**
    Family: Quicksand - Font: Quicksand-Regular
    Family: Quicksand - Font: Quicksand-Light
    Family: Quicksand - Font: Quicksand-SemiBold
    Family: Quicksand - Font: Quicksand-Bold
    Family: Quicksand - Font: Quicksand-Medium
    */
    
    enum TextStyle {
        case heading1
        case heading2
        case heading3
        case heading4
        case heading5
        case heading6
        case bodyText
        case small
        case label
        case link
        case custom(String, CGFloat)
    }
    
    fileprivate struct Styles {
        static let heading1 = AppFont.regularFont(size: 40)
        static let heading2 = AppFont.regularFont(size: 32)
        static let heading3 = AppFont.mediumFont(size: 28)
        static let heading4 = AppFont.mediumFont(size: 24)
        static let heading5 = AppFont.mediumFont(size: 20)
        static let heading6 = AppFont.mediumFont(size: 18)
        static let bodyText = AppFont.regularFont(size: 16)
        static let small = AppFont.regularFont(size: 14)
        static let label = AppFont.lightFont(size: 16)
        static let link = AppFont.semiboldFont(size: 16)
    }
    
    static func fontForStyle(_ style: AppFont.TextStyle) -> UIFont {
        switch style {
        case .heading1:
            return Styles.heading1
        case .heading2:
            return Styles.heading2
        case .heading3:
            return Styles.heading3
        case .heading4:
            return Styles.heading4
        case .heading5:
            return Styles.heading5
        case .heading6:
            return Styles.heading6
        case .bodyText:
            return Styles.bodyText
        case .small:
            return Styles.small
        case .label:
            return Styles.label
        case .link:
            return Styles.link
        case .custom(let fontStyle, let size):
            switch fontStyle {
            case "bold":
                return AppFont.boldFont(size: size)
            case "regular":
                return AppFont.regularFont(size: size)
            case "medium":
                return AppFont.mediumFont(size: size)
            case "light":
                return AppFont.lightFont(size: size)
            case "semibold":
                return AppFont.semiboldFont(size: size)
            default:
                return Styles.label
            }
        }
    }
    
    
    static func regularFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func lightFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func semiboldFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func boldFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mediumFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

