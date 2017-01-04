//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Venkat Kurapati on 04/01/2017.
//  Copyright © 2017 Kurapati. All rights reserved.
//

import Foundation
class FlickerClient{
    
    var session = URLSession.shared
    //Search Photos and get the photo URLs of all the photos in the search result.
    func searchPhotosFromFlickr(latitude: Double, longitude: Double, completionHandlerForSearchPhotos: @escaping (_ photoURLS: [String]?, _ error: NSError?) -> Void)
    {
        //Set the URL parameters as per the Flickr specifications
        let methodParameters : [String: AnyObject] = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.Method as AnyObject,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey as AnyObject,
            Constants.FlickrParameterKeys.BoundingBox: self.makeBoundaryBoxString(lat: latitude, long: longitude) as AnyObject,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL as AnyObject,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat as AnyObject,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback as AnyObject,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PhotosPerPage as AnyObject,
            Constants.FlickrParameterKeys.Page: "\(arc4random_uniform(15))" as AnyObject
        ]
        let requestURL = URLRequest(url: flickrURLFromParameters(methodParameters));
        print(requestURL)
        makeDataTaskAPICall(req: requestURL){ (data, error) in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForSearchPhotos(nil, NSError(domain: "searchPhotosFromFlickr", code: 1, userInfo: userInfo))
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            //Success - No error in response
            //Check the reponse for OK (stat).
            guard let stat = data[Constants.FlickrResponseKeys.Status] as? String, stat == "ok" else
            {
                print("Flickr API returned an error. See error code and message in \(data)")
                completionHandlerForSearchPhotos(nil, NSError(domain: Constants.Error.Domain.SearchMethod, code: 5001, userInfo: [NSLocalizedDescriptionKey:Constants.Error.Message.Error_Occurred]))
                return
            }
            
            //Parse through the response that contains elements photos/photo.
            if let photosDictionary = data[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject],
                let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]]
            {
                var photoURLS = [String]()
                
                for photo in photosArray
                {
                    //Get the URLs of the photos.
                    if let photoURL = photo[Constants.FlickrResponseKeys.MediumURL] as? String
                    {
                        photoURLS.append(photoURL)
                    }
                }
                completionHandlerForSearchPhotos(photoURLS, nil)
            }
            else
            {
                completionHandlerForSearchPhotos(nil, NSError(domain: Constants.Error.Domain.SearchMethod, code: 5002, userInfo: [NSLocalizedDescriptionKey: Constants.Error.Message.Invalid_Response]))
            }
            
        }
    }

    // MARK : Function to initiate the API call via. Task.
    func makeDataTaskAPICall (req request:URLRequest , completionHandlerForTaskCall : @escaping (_ result : AnyObject? , _ error: NSError?) -> Void)
    {
        let session = URLSession.shared
        
        //Create Task
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //Check for error
            if error == nil
            {
                //Success
                // Convert the JSON to AnyObject so that it can be mapped to the completionHandler here.
                FlickrUtil.parseJSONToAnyObject(response: data! as NSData, completionHandler: completionHandlerForTaskCall)
            }
            else
            {
                //Failure
                completionHandlerForTaskCall(nil,error! as NSError?)
            }
        }
        task.resume()
    }
    
    //MARK:- Download photos based on the provided photo URL.
    func downloadPhotos(photoURL:String, completionHandlerForDownloadPhotos: @escaping (_ image: NSData?, _ error: NSError?) -> Void)
    {
        let url = NSURL(string: photoURL)
        let request = URLRequest(url: url! as URL)
        
        let task = session.dataTask(with: request){ data, response, error in
            
            guard let data = data else
            {
                completionHandlerForDownloadPhotos(nil, NSError(domain: Constants.Error.Domain.DownloadMethod, code: 6001, userInfo: [NSLocalizedDescriptionKey: Constants.Error.Message.Download_Not_Possible]))
                return
            }
            completionHandlerForDownloadPhotos(data as NSData, nil)
        }
        task.resume()
    }

    //MARK:- Boundary for search
    private func makeBoundaryBoxString(lat latitude: Double,  long longitude: Double) -> String
    {
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FlickerClient {
        struct Singleton {
            static var sharedInstance = FlickerClient()
        }
        return Singleton.sharedInstance
    }
    
}
