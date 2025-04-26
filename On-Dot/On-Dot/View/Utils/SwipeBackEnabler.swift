//
//  SwipeBackEnabler.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/25/25.
//

import SwiftUI
import UIKit

struct SwipeBackEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            guard let navController = vc.navigationController, navController.viewControllers.count > 1 else {
                return
            }
            navController.interactivePopGestureRecognizer?.delegate = context.coordinator
            navController.interactivePopGestureRecognizer?.isEnabled = true
        }
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let navController = gestureRecognizer.view?.next as? UINavigationController {
                return navController.viewControllers.count > 1
            }
            return false
        }
    }
}

extension View {
  func enableSwipeBack() -> some View {
    background(SwipeBackEnabler())
  }
}
