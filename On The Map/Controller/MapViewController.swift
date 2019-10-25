//
//  MapViewController.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var locations: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
       getStudentsLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
        } else {
            mapView.addAnnotations(locations)
        }
        
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        getStudentsLocations()
    }
    
    func getStudentsLocations() {
        UdacityService.getUsers(completion: handleStudentLocationsResponse(locations:error:))
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StudentLocation else {
            return nil
        }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StudentLocation else {
            return
        }
        
        guard let url = URL(string: annotation.mediaURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }
        locationManager.stopUpdatingLocation()
        mapView.setRegion(.init(center: location.coordinate, latitudinalMeters: 30000, longitudinalMeters: 30000), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
