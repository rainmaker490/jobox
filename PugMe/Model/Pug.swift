//
//  Pug.swift
//  PugMe
//
//  Created by Varun D Patel on 4/01/19.
//  Copyright © 2019 Varun D Patel. All rights reserved.
//

import Foundation

/*
 *   http://30.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco1_500.jpg\"/><br/> <br/><img
 *   src=\"http://28.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco8_500.jpg\"/><br/> <br/><img
 *   src=\"http://24.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco3_500.jpg\"/><br/> <br/><img
 *   src=\"http://30.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco9_500.jpg\"/><br/> <br/><img
 *   src=\"http://25.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco6_500.jpg\"/><br/> <br/><img
 *   src=\"http://24.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco2_500.jpg\"/><br/> <br/><img
 *   src=\"http://27.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco4_500.jpg\"/><br/> <br/><img
 *   src=\"http://24.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco7_500.jpg\"/><br/> <br/><img
 *   src=\"http://24.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco10_500.jpg\"/><br/> <br/><img
 *   src=\"http://26.media.tumblr.com/tumblr_lsx4nsg5Hj1qa25vco5_500.jpg
 * Some url strings from the endpoint are in the above format.
 * The pugImageUrls computed property parses the above string
 * into an array of URLs.
 * As a result, the properties pugImageLiked and likeCount are
 * parallel arrays to the pugImageUrls array.
 */

class Pug {
    var pugImageUrls: [URL?]? {
        get {
            return _url?.components(separatedBy: "<br/> <br/>")
                .reduce ([URL?]()) {
                    var dirtyURL = $1
                    if dirtyURL.hasPrefix("<img src=\"") {
                        dirtyURL = String(dirtyURL.dropFirst("<img src=\"".count))
                    }
                    if dirtyURL.hasSuffix("\"/>") {
                        dirtyURL = String(dirtyURL.dropLast("\"/>".count))
                    }
                    return $0 + [URL(string: dirtyURL)]
                }
        }
    }
    var pugImageCache = [String:Data]()
    var pugImageLiked: [Bool]!
    private(set) var likeCount: [Int]!
    private var _url: String?
    
    init (withUrl url:String?) {
        _url = url
        likeCount = [Int](repeating: Int.random(in: 0...100), count: pugImageUrls?.count ?? 0)
        pugImageLiked = [Bool](repeating: false, count: pugImageUrls?.count ?? 0)
    }
}
