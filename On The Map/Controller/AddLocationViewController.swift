//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    
    var studentLocation: StudentLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let annotation = Annotation()
        annotation.title = studentLocation.mapString
        annotation.coordinate = studentLocation.coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(.init(center: studentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        
        mapView.selectAnnotation(annotation, animated: true)
    }
    

    @IBAction func finishPressed(_ sender: Any) {
        setAdding(true)
        
        if UdacityService.Auth.objectId == "" {
            UdacityService.addStudentLocation(studentLocation: studentLocation, completion: handleAddResponse(success:error:))
        } else {
            UdacityService.updateStudentLocation(studentLocation: studentLocation, completion: handleAddResponse(success:error:))
        }
    }
    
    func handleAddResponse(success: Bool, error: Error?) {
        setAdding(false)
        if success {
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: error!.localizedDescription)
        }
    }
    
    func setAdding(_ adding: Bool) {
        addButton.isEnabled = !adding
        addButton.showLoading(adding)
    }

}

extension AddLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Annotation else {
            return nil
        }
        
        let identifier = "marker"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
}
