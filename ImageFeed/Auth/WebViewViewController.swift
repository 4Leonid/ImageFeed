//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.03.2023.
//

import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
  //  MARK: - Private Properties
  private var estimatedProgressObservation: NSKeyValueObservation?
  
  //  MARK: - IB Outlets
  @IBOutlet private var webView: WKWebView!
  @IBOutlet private var progressView: UIProgressView!
  
  weak var delegate: WebViewViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.AccessKey),
      URLQueryItem(name: "redirect_uri", value: Constants.RedirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: Constants.AccessScope)
    ]
    let url = urlComponents.url!
    
    let request = URLRequest(url: url)
    webView.load(request)
    
    //New
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self = self else { return }
         self.updateProgress()
       })
    
    updateProgress()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    webView.addObserver(
      self,
      forKeyPath: #keyPath(WKWebView.estimatedProgress),
      options: .new, context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    webView.removeObserver(
      self,
      forKeyPath: #keyPath(WKWebView.estimatedProgress),
      context: nil
    )
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(WKWebView.estimatedProgress) {
      updateProgress()
    } else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
  
  private func updateProgress() {
    progressView.progress = Float(webView.estimatedProgress)
    progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
  }

  @IBAction private func didTapBackButton() {
    delegate?.webViewViewControllerDidCancel(self)
  }
}

extension WebViewViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let code = code(from: navigationAction) {
      delegate?.webViewViewController(self, didAuthenticateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
  
  private func code(from navigationAction: WKNavigationAction) -> String? {
    if let url = navigationAction.request.url,
       let urlComponents = URLComponents(string: url.absoluteString),
       urlComponents.path == "/oauth/authorize/native",
       let items = urlComponents.queryItems,
       let codeItem = items.first(where: { $0.name == "code" }) {
      return codeItem.value
    } else {
      return nil
    }
  }
}
