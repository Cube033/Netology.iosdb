//
//  CustomButton.swift
//  Navigation
//
//  Created by Дмитрий Федотов on 22.09.2022.
//

import UIKit

class CustomButton: UIButton {
    
    private var tapAction: (()->Void)?
    
    convenience init(title: String, backgroundColor: UIColor?, tapAction: (()->Void)?) {
        self.init(frame: .zero)
        var buttonConfiguration = UIButton.Configuration.filled()
        if let backgroundColorExist = backgroundColor {
            buttonConfiguration.baseBackgroundColor = backgroundColorExist
        } else {
            buttonConfiguration.baseBackgroundColor = .blue
        }
        buttonConfiguration.title = title
        buttonConfiguration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = UIFont.systemFont(ofSize: 14)
            return outgoing
          }
        layer.cornerRadius = 10.0
        translatesAutoresizingMaskIntoConstraints = false
        configuration = buttonConfiguration
        configurationUpdateHandler =  {logInButton in
            switch logInButton.state {
            case .normal:
                logInButton.alpha = 1
            case .selected:
                logInButton.alpha = 0.8
            case .highlighted:
                logInButton.alpha = 0.8
            case .disabled:
                logInButton.alpha = 0.8
            default:
                logInButton.alpha = 1
            }
        }
        self.tapAction = tapAction
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    @objc private func buttonTapped() {
        if let tapActionExist = tapAction {
            tapActionExist()
        }
    }
}
