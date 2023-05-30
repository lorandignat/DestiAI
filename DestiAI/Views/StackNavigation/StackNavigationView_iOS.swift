//
//  SuggestionStackNavigationView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 29.05.2023.
//

import SwiftUI

#if !os(macOS)

struct SuggestionStackView: UIViewControllerRepresentable {

  @ObservedObject var navigationRouter: StackNavigationRouter

  typealias UIViewControllerType = UINavigationController

  func makeUIViewController(context: Context) -> UINavigationController {
    let controller = UIHostingController(rootView: AnyView(navigationRouter.makeBody()))
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.isNavigationBarHidden = true
    return navigationController
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    if navigationRouter.shouldPush {
      let controller = UIHostingController(rootView: AnyView(navigationRouter.makeBody()))
      uiViewController.pushViewController(controller, animated: true)
    } else if navigationRouter.shouldPop {
      uiViewController.popViewController(animated: true)
    }
  }
}

#endif
