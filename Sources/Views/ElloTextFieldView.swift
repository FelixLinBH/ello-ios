//
//  ElloTextFieldView.swift
//  Ello
//
//  Created by Tony DiPasquale on 3/25/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Foundation

private let ElloTextFieldViewHeight: CGFloat = 89.0

public class ElloTextFieldView: UIView {
    @IBOutlet public weak var label: ElloToggleLabel!
    @IBOutlet public weak var textField: ElloTextField!
    @IBOutlet public weak var errorLabel: ElloErrorLabel!
    @IBOutlet public weak var messageLabel: ElloLabel!

    var textFieldDidChange: (String -> ())? {
        didSet {
            textField.addTarget(self, action: "valueChanged", forControlEvents: .EditingChanged)
        }
    }

    var height: CGFloat {
        var height = ElloTextFieldViewHeight
        height += (errorLabel.text?.isEmpty ?? true) ? 0 : errorLabel.frame.height + 8
        height += (messageLabel.text?.isEmpty ?? true) ? 0 : messageLabel.frame.height + 20
        return height
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view: UIView = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        addSubview(view)
    }

    func setState(state: ValidationState) {
        textField.setValidationState(state)
    }

    func valueChanged() {
        textFieldDidChange?(textField.text)
    }

    func setErrorMessage(message: String) {
        errorLabel.setLabelText(message)
        errorLabel.sizeToFit()
    }

    func setMessage(message: String) {
        messageLabel.setLabelText(message)
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.sizeToFit()
    }

    func clearState() {
        textField.setValidationState(.None)
        setErrorMessage("")
        setMessage("")
    }
}
