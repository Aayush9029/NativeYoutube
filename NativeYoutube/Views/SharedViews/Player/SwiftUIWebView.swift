//
//  SwiftUIWebView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-30.
//

import SwiftUI
import WebKit

struct SafariWebView: View {
    @ObservedObject var model: WebViewModel

    init(mesgURL: String) {
        //Assign the url to the model and initialise the model
        self.model = WebViewModel(link: mesgURL)
    }
    
    var body: some View {
        //Create the WebView with the model
        SwiftUIWebView(viewModel: model)
    }
}
struct SwiftUIWebView: NSViewRepresentable {
    
    public typealias NSViewType = WKWebView
    @ObservedObject var viewModel: WebViewModel


    public func makeNSView(context: NSViewRepresentableContext<SwiftUIWebView>) -> WKWebView {
        var webView: WKWebView = WKWebView()

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator as? WKUIDelegate
        webView.load(URLRequest(url: URL(string: viewModel.link)!))
        guard let path = Bundle.main.path(forResource: "style", ofType: "css"),
          let cssString = try? String(contentsOfFile: path).components(separatedBy: .newlines).joined()
        else {
            return webView
        }
        print(cssString)
        let source = """
             var style = document.createElement('style');
             style.innerHTML = '\(cssString)';
             document.head.appendChild(style);
          """
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        let configuration = WKWebViewConfiguration()
         configuration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: configuration)

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator as? WKUIDelegate
        webView.load(URLRequest(url: URL(string: viewModel.link)!))
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<SwiftUIWebView>) { }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
           //Initialise the WebViewModel
           self.viewModel = viewModel
        }
        
        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) { }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) { }

        //After the webpage is loaded, assign the data in WebViewModel class
        public func webView(_ web: WKWebView, didFinish: WKNavigation!) {
            self.viewModel.pageTitle = web.title!
            self.viewModel.link = web.url?.absoluteString as! String
            self.viewModel.didFinishLoading = true
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

    }

}
