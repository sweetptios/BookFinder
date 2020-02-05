//
//  BookDetailMock.swift
//  BookFinderTests
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder

class BookDetailOutputBoundaryMock: BookDetailOutputBoundary {
    
    func goToWebPage(_ url: URL) {
        Stubber.invoke(goToWebPage, args: url)
    }
    
    func goBackToPrevWebPage() {
        Stubber.invoke(goBackToPrevWebPage, args: ())
    }
    
    func goForwardToNextWebPage() {
        Stubber.invoke(goForwardToNextWebPage, args: ())
    }
    
    func reloadWebPage() {
        Stubber.invoke(reloadWebPage, args: ())
    }
    
    func exit() {
        Stubber.invoke(exit, args: ())
    }
}

class BookDetailViewMock: BookDetailViewControllable {
    
    func goBackToPrevWebPage() {
        Stubber.invoke(goBackToPrevWebPage, args: ())
    }
    
    func goForwardToNextWebPage() {
        Stubber.invoke(goForwardToNextWebPage, args: ())
    }
    
    func reloadWebPage() {
        Stubber.invoke(reloadWebPage, args: ())
    }
    
    func loadWebPage(_ url: URL) {
        Stubber.invoke(loadWebPage, args: url)
    }
    
    func exit() {
        Stubber.invoke(exit, args: ())
    }
}
