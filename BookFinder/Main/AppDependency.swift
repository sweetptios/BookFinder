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
        
        var rootViewController: ProductIndexViewController!
        rootViewController = ProductIndexViewController(csg: ProductIndexCSG(), productDetailVCFactory: {_,_ in
            return UIViewController()
        })
       
        let presenter = ProductIndexPresenter(view: rootViewController)
        let interactor = ProductIndexInteractor(outputBoundary: presenter, repository: ProductSummaryRepository(networking: NetworkingService()))
        presenter.setInteractor(interactor)
        rootViewController.setPresenter(presenter)
        window.rootViewController = rootViewController
        return AppDependency(
            window: window
        )
    }
}
