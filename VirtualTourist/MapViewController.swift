//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Venkat Kurapati on 04/01/2017.
//  Copyright © 2017 Kurapati. All rights reserved.
//

import UIKit
import MapKit
//MARK:- showAlbum
class MapViewController: UIViewController,MKMapViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    //MARK:- Variables
    let stack = CoreDataStack.sharedInstance()
    var centerCoordinate: CLLocationCoordinate2D?
    var centerCoordinateLongitude: CLLocationDegrees?
    var centerCoordinateLatitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestureRecognizer(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.addPinAnnotationToMap(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5   // half-second hold for  pin creation
        lpgr.delegate = self
        self.mapview.addGestureRecognizer(lpgr)
    }
    func addPinAnnotationToMap(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began
        {
            let point = gestureRecognizer.location(in: mapview)
            
            // Get the coordinates from the touch point.
            let coordinate = mapview.convert(point, toCoordinateFrom: mapview)
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            print ("Coordinates of the Pin [LAT LONG] : \(latitude) \(longitude)")
            
            //Initialize Pin.
            let pin = Pin(context: stack.persistentContainer.viewContext)
            pin.latitude = latitude
            pin.longitude = longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapview.addAnnotation(annotation)
            stack.saveContext()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
