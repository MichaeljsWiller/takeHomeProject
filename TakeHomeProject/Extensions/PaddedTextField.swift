//
//  PaddedTextField.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import UIKit

/// A custom textfield that applies to its text
class PaddedTextField: UITextField {
  
  private let padding: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 5)
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
