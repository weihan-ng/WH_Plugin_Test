//
//  PresentationDelegate.swift
//  ios_native_qms_test
//
//  Created by Wei Han Ng on 30/03/2026.
//

import UIKit

public final class PresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    let onDismiss: () -> Void

    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss()
    }
}
