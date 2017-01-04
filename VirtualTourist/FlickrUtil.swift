//
//  FlickrUtil.swift
//  VirtualTourist
//
//  Created by Venkat Kurapati on 04/01/2017.
//  Copyright © 2017 Kurapati. All rights reserved.
//

import Foundation
import MapKit
//MARK:- Flickr Util class
class FlickrUtil{
    //MARK : Convert a Dictionary to NSData.
    static func toNSData(requestBody : [String:AnyObject]? = nil) -> NSData
    {
        var jsonData:NSData! = nil
        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: requestBody!, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData!
            //print ("Request => \(jsonData)")
        }
        catch let error as NSError
        {
            print(error)
        }
        parseJSONToAnyObject(response: jsonData) { (result, error) in
        }
        return jsonData
    }
    
    //MARK : This method will convert the JSON response to a usable AnyObject.
    static func parseJSONToAnyObject(response: NSData, completionHandler: (_ result:AnyObject?, _ error:NSError?)-> Void)
    {
        var parsedResponse:Any! = nil
        do
        {
            parsedResponse = try JSONSerialization.jsonObject(with: response as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            //print("parseJSONToAnyObject :  " + parsedResponse.description)
            completionHandler(parsedResponse as AnyObject, nil)
        }
            
        catch let error as NSError
        {
            //Failure has occurred, don't return any results.
            completionHandler(nil, error)
        }
    }
    
    //Mark : This method will convert a Pin into MKPointAnnotation
    static func toMKAnnotation(_ pin: Pin) -> MKPointAnnotation
    {
        let toAnnotation = MKPointAnnotation()
        toAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(pin.latitude), CLLocationDegrees(pin.longitude))
        return toAnnotation
    }
    
    //Mark : This method will convert MKAnnotation into Pin
    static func toPin (_ annotation:MKAnnotation, _ pin:Pin) -> Pin
    {
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
        return pin
    }

}
