//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit
import WebKit

class BookDetailViewController: UIViewController {
    
    private let inputBoundary: BookDetailInputBoundary
    @IBOutlet var webkitView: WKWebView?
    @IBOutlet var toolbar: UIToolbar?
    @IBOutlet var progressView: UIProgressView?
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    private var estimatedProgressObservationToken: NSKeyValueObservation?
    private var canGoBackObservationToken: NSKeyValueObservation?
    private var canGoForwardObservationToken: NSKeyValueObservation?
    
    init(inputBoundary: BookDetailInputBoundary) {
        self.inputBoundary = inputBoundary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBoundary.viewIsReady()
        setupViews()
        addObservers()
    }
    
    @IBAction func didTapBarButton(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            inputBoundary.didSelectHome()
        case 2:
            inputBoundary.didSelectBack()
        case 3:
            inputBoundary.didSelectForward()
        case 4:
            inputBoundary.didSelectShare()
        case 5:
            inputBoundary.didSelectSafari()
        default:
            print(#function)
        }
    }
    
    @objc
    func didTapCloseButton(_ sender: Any) {
        inputBoundary.didSelectClose()
    }
    
    @objc
    func didTapReloadButton(_ sender: Any) {
        inputBoundary.didSelectReload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

//MARK: - setup Views

extension BookDetailViewController {
    
    fileprivate func setupViews() {
        setupWebkitView()
        setupNavigationBar()
        setupToolBar()
        setupProgressView()
    }
    
    private func setupWebkitView() {
        webkitView?.navigationDelegate = self
        webkitView?.uiDelegate = self
        webkitView?.backgroundColor = AppColor.Background.white
    }
    
    private func setupToolBar() {
        toolbar?.tintColor = AppColor.darkNavy
        toolbar?.barTintColor = AppColor.Background.white
        toolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar?.clipsToBounds = false
        toolbar?.layer.setShadows(color: AppColor.Background.darkNavyShadow ?? UIColor.black, y: -2, blur: 4)
        backButton?.isEnabled = false
        forwardButton?.isEnabled = false
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = AppColor.Background.white
        navigationController?.navigationBar.layer.setShadows(color: AppColor.Background.darkNavyShadow ?? UIColor.black, y: 2, blur: 4)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let image = UIImage(named: "menu_book") {
            navigationItem.titleView = UIImageView(image: image)
            navigationItem.titleView?.tintColor = AppColor.darkNavy
            navigationItem.titleView?.bounds.size = CGSize(width: 20, height: 18)
        }
        if let image = UIImage(named: "close") {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapCloseButton(_:)))
            navigationItem.leftBarButtonItem?.tintColor = AppColor.darkNavy
        }
        if let image = UIImage(named: "refresh") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapReloadButton(_:)))
            navigationItem.rightBarButtonItem?.tintColor = AppColor.darkNavy
        }
    }
    
    private func setupProgressView() {
        progressView?.tintColor = AppColor.Background.purple
    }
}

//MARK: - BookDetailViewControllable

extension BookDetailViewController: BookDetailViewControllable {
    
    func loadWebPage(_ url: URL) {
        progressView?.alpha = 1
        progressView?.setProgress(Float(0.05), animated: true)
        let request = URLRequest(url: url)
        webkitView?.load(request)
    }
    
    func goBackToPrevWebPage() {
        webkitView?.goBack()
    }
    
    func goForwardToNextWebPage() {
        webkitView?.goForward()
    }
    
    func reloadWebPage() {
        webkitView?.reload()
    }
    
    func showShareActivity(with url: URL) {
        let activityVC = UIActivityViewController(activityItems: [ url.absoluteString ], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
    func exit() {
        webkitView?.stopLoading()
        dismiss(animated: true)
    }
}

//MARK: - UIAdaptivePresentationControllerDelegate

extension BookDetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        webkitView?.stopLoading()
    }
}


//MARK: - observers

extension BookDetailViewController {
    
    fileprivate func addObservers() {
        
        estimatedProgressObservationToken = webkitView?.observe(\.estimatedProgress, options: [.old,.new]) { [weak self](observed, change) in

            self?.progressView?.setProgress(Float(observed.estimatedProgress), animated: true)
            self?.progressView?.alpha = 1
            
            if let old = change.oldValue, let new = change.newValue, new == 1.0 {
                let duration: TimeInterval = 0.3
                let delay: TimeInterval = new - old
                UIView.animate(withDuration: duration, delay: delay, animations: {
                    self?.progressView?.alpha = 0
                }) { _ in
                    self?.progressView?.progress = 0
                }
            }
        }
        
        canGoBackObservationToken = webkitView?.observe(\.canGoBack, options: [.new]) {[weak self](object, change) in
            guard let newValue = change.newValue else { return }
            self?.backButton.isEnabled = newValue
        }

        canGoForwardObservationToken = webkitView?.observe(\.canGoForward, options: [.new]) {[weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            self?.forwardButton.isEnabled = newValue
        }
    }
}

//MARK: - WKUIDelegate

extension BookDetailViewController: WKUIDelegate {

   func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    
       let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
           completionHandler()
       })
       present(alert, animated: true, completion: nil)
   }
   
   
   func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    
       let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
           completionHandler(true)
       })
       alert.addAction(UIAlertAction(title: "취소", style: .default){ _ in
           completionHandler(false)
       })
       present(alert, animated: true, completion: nil)
   }
   
   func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    
       let alert = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
       alert.addTextField { $0.text = defaultText }
       alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
           if let text = alert.textFields?.first?.text {
               completionHandler(text)
           } else {
               completionHandler(defaultText)
           }
       })
       alert.addAction(UIAlertAction(title: "취소", style: .default){ (action) in
           completionHandler(nil)
       })
       present(alert, animated: true, completion: nil)
   }
}

//MARK: - WKNavigationDelegate

extension BookDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            inputBoundary.webpageWasChanged(url)
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}


