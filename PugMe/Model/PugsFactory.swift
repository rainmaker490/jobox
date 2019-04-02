//
//  Pugs.swift
//  PugMe
//
//  Created by Varun D Patel on 4/01/19.
//  Copyright © 2019 Varun D Patel. All rights reserved.
//

import Foundation

/*
 * The PugsFactory is a factory that fetches new "Pug"s.
 * Suppose in the future we needed to do other calculations on 'pugs'
 * it can happen here (i.e. filter out pugs that are .gifs?)
 */

protocol Pugsable: NSObjectProtocol {
    func newPugsAvailable()
}

class PugsFactory: NSObject {
    var pugs = [Pug]() {
        didSet {
            delegate?.newPugsAvailable()
        }
    }
    weak open var delegate: Pugsable?
    private(set) var pageNumber: Int!
    
    func getNextPage() {
        pageNumber = (pageNumber ?? 0) + 1
        makeRequest()
    }
}

//MARK: PugRequestable Protocol
extension PugsFactory: PugRequestable {
    var urlParameters: [String : String]? {
        return ["count":"50","page":"\(pageNumber ?? 0)"]
    }
    
    var successCompletionBlock: PugableResponseBlock? {
        get {
            let successCompletionBlock: ([String:AnyObject]?) -> Void = {
                let pugURLs = $0?["pugs"] as? [String]
                self.pugs = self.pugs + (pugURLs?
                    .map { (url) -> Pug in
                        return Pug(withUrl: url)
                    } ?? [])
            }
            return successCompletionBlock
        }
    }
    
    var failureCompletionBlock: PugableResponseBlock? {
        get {
            //TODO: Failure Case
            //Log to something like Crashlytics?
            return nil
        }
    }
}
