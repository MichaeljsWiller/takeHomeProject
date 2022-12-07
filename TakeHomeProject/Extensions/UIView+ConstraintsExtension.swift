//
//  UIView+ConstraintsExtension.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 13/09/2021.
//

import UIKit

extension UIView {
  
  /// Applies layout constraints to a view
  func anchor(
    top: NSLayoutYAxisAnchor? = nil,
    paddingTop: CGFloat = 0,
    bottom: NSLayoutYAxisAnchor? = nil,
    paddingBottom: CGFloat = 0,
    leading: NSLayoutXAxisAnchor? = nil,
    paddingLeft: CGFloat = 0,
    trailing: NSLayoutXAxisAnchor? = nil,
    paddingRight: CGFloat = 0,
    centerX: NSLayoutXAxisAnchor? = nil,
    centerY: NSLayoutYAxisAnchor? = nil,
    width: CGFloat = 0,
    height: CGFloat = 0
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
    }
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
    }
    if let centerX = centerX {
      centerXAnchor.constraint(equalTo: centerX).isActive = true
    }
    if let centerY = centerY {
      centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
}
