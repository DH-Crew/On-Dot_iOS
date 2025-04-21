//
//  AddressWebView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/22/25.
//

import SwiftUI
import WebKit

struct AddressWebView: UIViewRepresentable {
    @Binding var isPresented: Bool
    @Binding var address: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "addressSelected")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        if let url = URL(string: "https://dh-crew.github.io/kakao-address-search/") {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: AddressWebView

        init(_ parent: AddressWebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let jsonString = message.body as? String {
                if let data = jsonString.data(using: .utf8),
                   let addressDict = try? JSONDecoder().decode(KaKaoAddressData.self, from: data) {
                    parent.address = addressDict.roadAddress
                    parent.isPresented = false
                }
            }
        }
    }
}

