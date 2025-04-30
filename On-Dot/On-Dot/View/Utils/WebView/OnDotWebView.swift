//
//  OnDotWebView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

import SwiftUI
import WebKit

struct OnDotWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebViewScreen: View {
    let url: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            OnDotWebView(url: url)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("닫기") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
    }
}
