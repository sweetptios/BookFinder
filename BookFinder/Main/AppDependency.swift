//
//  AppDependency.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/21.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

extension AppDependency {
    static func resolve() -> AppDependency {
        
        let window = UIWindow()
        
        let presenter = ProductIndexPresenter()
        let interactor = ProductIndexInteractor(outputBoundary: presenter, repository: ProductSummaryRepository(networking: NetworkingService()))
        var rootViewController: ProductIndexViewController!
        rootViewController = ProductIndexViewController(inputBoundary: interactor, csg: ProductIndexCSG(), productDetailVCFactory: {
            let presenter = BookDetailPresenter()
            let interactor = BookDetailInteractor(outputBoundary: presenter, itemId: $0, detailInfoUrl: $1)
            let viewController = BookDetailViewController(inputBoundary: interactor)
            viewController.transitioningDelegate = rootViewController
            presenter.setView(viewController)
            return viewController
        })
        presenter.setView(rootViewController)
        window.rootViewController = rootViewController
        
        return AppDependency(
            window: window
        )
    }
}
