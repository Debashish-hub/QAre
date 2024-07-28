//
//  TabBarWithCenterButton.swift
//  QAre
//
//  Created by Debashish on 16/06/24.
//

import Foundation
import UIKit

@IBDesignable
public final class TabBarWithCenterButton: UITabBar {

    // MARK: - Variables -
    @objc public var centerButtonActionHandler: () -> Void = {
        // Default empty
    }

    @IBInspectable public var centerButtonColor: UIColor = UIColor(hexString: ColorConstants.init().primaryColor)
    @IBInspectable public var centerButtonHeight: CGFloat = CGFloat(55)
    @IBInspectable public var padding: CGFloat = 5.0
    @IBInspectable public var buttonImage: UIImage?
    @IBInspectable public var buttonTitle: String?

    @IBInspectable public var tabbarColor: UIColor = UIColor.lightGray
    @IBInspectable public var unselectedItemColor: UIColor = UIColor.white

    private func addShape() {
        let designlayer = CAShapeLayer()
        designlayer.path = createPath()
        designlayer.strokeColor = UIColor.clear.cgColor
        designlayer.fillColor = tabbarColor.cgColor
        designlayer.lineWidth = 0

        let uniqueID = "ABC"

        self.layer.sublayers?.first(where: { $0.accessibilityLabel == uniqueID })?.removeFromSuperlayer()

        designlayer.accessibilityLabel = uniqueID
        self.layer.insertSublayer(designlayer, at: 0)

        self.tintColor = centerButtonColor
        self.unselectedItemTintColor = unselectedItemColor
       // self.setupMiddleButton()
    }

    override public func draw(_ rect: CGRect) {
        self.addShape()
        self.backgroundColor = .white
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else {
            return nil
        }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }

    private func createPath() -> CGPath {
        let radius = CGFloat(centerButtonHeight / 2.0) + padding
        let height = frame.height
        let width = frame.width
        let halfW = frame.width / 2.0
        let cornerRadius = CGFloat(22)
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: halfW - radius - (cornerRadius / 2.0), y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0.0, y: height))

        return path.cgPath
    }

    private func setupMiddleButton() {

        let centerButton = UIButton(frame: CGRect(x: (self.bounds.width / 2) - (centerButtonHeight / 2), y: -20, width: centerButtonHeight, height: centerButtonHeight))

        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2.0
        centerButton.setImage(buttonImage, for: .normal)
        // Add to the tabbar and add click event
        self.addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
    }

    // Menu Button Touch Action
    @objc
    func centerButtonAction(sender: UIButton) {
        self.centerButtonActionHandler()
     }
}
