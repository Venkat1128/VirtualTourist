//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Venkat Kurapati on 04/01/2017.
//  Copyright © 2017 Kurapati. All rights reserved.
//

import Foundation
// MARK: - Constants

struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
        static let PhotoLimit = 20
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let Method = "flickr.photos.getRecent"
        static let APIKey = "d65d1f18997d12dcbc9f6f615922eb9b"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let MediumURL = "url_m"
        static let PhotosPerPage = "20"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    //MARK:- Flockr Error messages
    struct Error
    {
        struct Domain
        {
            static let SearchMethod="VT.SEARCH_PHOTOS"
            static let DownloadMethod="VT.DOWNLOAD_PHOTOS"
        }
        
        struct Message
        {
            static let Error_Occurred = "Error occurrred in API response."
            static let Invalid_Response = "API response is not parsable for necessary information."
            static let Download_Not_Possible = "Unable to download pic."
        }
    }
}
