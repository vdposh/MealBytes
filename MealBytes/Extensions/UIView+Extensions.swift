//
//  UIView+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10.06.2026.
//

import UIKit

extension UIScrollView {
    func scrollToTop(animated: Bool = true) {
        let topInset = safeAreaInsets.top
        setContentOffset(CGPoint(x: 0, y: -topInset), animated: animated)
    }
}

extension UIView {
    func findScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        for subview in subviews {
            if let scrollView = subview.findScrollView() {
                return scrollView
            }
        }
        return nil
    }
}
