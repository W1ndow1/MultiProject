//
//  Navigation+Extension.swift
//  MultiProject
//
//  Created by window1 on 7/28/24.
//

///  NavigationTitlebar 스크롤시 숨기기

import SwiftUI

extension UIView {
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
}


extension View {
    @ViewBuilder
    func hideNaviBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavigationModifier(isHidden: isHidden))
    }
}

private struct NavigationModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNaviBarHidden: Bool?
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, initial: true, { ov, nv in
                isNaviBarHidden = nv
            })
            .onDisappear() {
                isNaviBarHidden = nil
            }
            .background(NavigationControllerExtractor(isHidden: isNaviBarHidden))
    }
}

private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let hostView = uiView.superview?.superview,
                let parentController = hostView.parentController {
                if let isHidden {
                    parentController.navigationController?.hidesBarsOnSwipe = isHidden
                }
            }
        }
    }
}


