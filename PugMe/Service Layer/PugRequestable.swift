//
//  PugRequestable.swift
//  PugMe
//
//  Created by Varun D Patel on 4/01/19.
//  Copyright © 2019 Varun D Patel. All rights reserved.
//

import Foundation

let PUG_SERVICE_TIMEOUT = 10.0
typealias PugableResponseBlock = ([String:AnyObject]?) -> Void

protocol PugRequestable {
    var baseURL: String? { get }
    var httpMethod: String { get }
    var urlParameters: [String : String]? { get }
    var successCompletionBlock: PugableResponseBlock? { get }
    var failureCompletionBlock: PugableResponseBlock? { get }
}

extension PugRequestable {
    var baseURL: String? {
        return "http://pugme.herokuapp.com/bomb"
    }
    var httpMethod: String {
        return "GET"
    }
    var urlParameters: [String : String]? { return nil }
    
    func makeRequest() {
        var requestURL = baseURL ?? ""
        
        //URL Parameters:
        var urlParametersToString = ""
        urlParameters?.forEach {
            urlParametersToString = "\(urlParametersToString)&\($0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        urlParametersToString.remove(at: urlParametersToString.startIndex)
        requestURL = "\(requestURL)\(urlParameters?.count ?? 0 > 0 ? "?" : "")\(urlParametersToString)"
        
        //Request URL:
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = httpMethod
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = PUG_SERVICE_TIMEOUT
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        //Data Task:
        DispatchQueue.global(qos: .userInitiated).async {
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let _ = error {
                    //TODO: Failure case
                    //Log to something like Crashlytics?
                } else {
                    let dirtyResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : AnyObject]
                    let errorCode = (response as! HTTPURLResponse).statusCode
                    if let responseDictionary = dirtyResponseDictionary, errorCode >= 200, errorCode < 300 {
                        DispatchQueue.main.async {
                            self.successCompletionBlock?(responseDictionary)
                        }
                    } else {
                        //TODO: Failure case
                        //Log to something like Crashlytics?
                        //Call Failure Completion Block here, or your may not even need a failure case if in this case
                        //all we're going to do is log to Crashlytics
                    }
                }
            }).resume()
        }
    }
}
