//
//  BookIndexRouter.swift
//  BookFinder
//
//  Created by mine on 2020/03/21.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit

class BookIndexRouter: BookIndexRouterLogic {
    
    var sourceViewController: UIViewController!
    var detailVCFactory: ((String, URL?) -> UIViewController)!
    
    func showBookDetail(_ id: String, _ url: URL?) {
        let viewController = detailVCFactory(id, url)
        sourceViewController.present(viewController, animated: true)
    }
}
