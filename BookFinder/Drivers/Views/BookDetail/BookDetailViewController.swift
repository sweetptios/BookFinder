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
    
    init(inputBoundary: BookDetailInputBoundary) {
        self.inputBoundary = inputBoundary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBoundary.viewDidLoad()
    }
}

extension BookDetailViewController: BookDetailViewControllable {
    
    func showBookDetail(_ url: URL?) {
        if let url = url {
            let request = URLRequest(url: url)
            webkitView?.load(request)
        }
    }
}

