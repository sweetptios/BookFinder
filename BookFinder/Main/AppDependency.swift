//
//  AppDependency.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

extension AppDependency {
    static func resolve() -> AppDependency {
        
        let window = UIWindow()
        
        let presenter = BookIndexPresenter()
        let interactor = BookIndexInteractor(outputBoundary: presenter, repository: BookSummaryRepository(networking: NetworkingService()))
        var rootViewController: BookIndexViewController!
        rootViewController = BookIndexViewController(inputBoundary: interactor, csg: BookIndexCSG(), productDetailVCFactory: {
            let presenter = BookDetailPresenter()
            let interactor = BookDetailInteractor(outputBoundary: presenter, itemId: $0, detailInfoUrl: $1, otherAppService: OtherAppService())
            let viewController = BookDetailViewController(inputBoundary: interactor)
            presenter.setView(viewController)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.transitioningDelegate = rootViewController
            navigationController.presentationController?.delegate = viewController
            return navigationController
        })
        presenter.setView(rootViewController)
        window.rootViewController = rootViewController
        
        return AppDependency(
            window: window
        )
    }
}
