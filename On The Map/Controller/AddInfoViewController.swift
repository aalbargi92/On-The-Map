//
//  AddInfoViewController.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit
import CoreLocation

class AddInfoViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    let geocoder = CLGeocoder()
    
    var studentLocation = StudentLocation()
    
    @IBAction func findPressed(_ sender: Any) {
        setFinding(true)
        
        let locationString = locationTextField.text!
        let urlString = urlTextField.text!
        
        if locationString.isEmpty {
            showAlert(title: "Location is missing", message: "Please enter location")
            setFinding(false)
            return
        }
        
        if urlString.isEmpty {
            showAlert(title: "URL is missing", message: "Please enter url")
            setFinding(false)
            return
        }
        
        geocoder.geocodeAddressString(locationString, completionHandler: handleGeocodeString(placemarks:error:))
        
    }
    
    func handleGeocodeString(placemarks: [CLPlacemark]?, error: Error?) {
        
        guard let placemarks = placemarks else {
            self.setFinding(false)
            self.showAlert(title: "Error", message: "Place could not be found!")
            return
        }
        
        guard let placemark = placemarks.first else {
            return
        }
        
        studentLocation.uniqueKey = UdacityService.Auth.userId
        studentLocation.firstName = UdacityService.Auth.user!.firstName
        studentLocation.lastName = UdacityService.Auth.user!.lastName
        studentLocation.mapString = locationTextField.text!
        studentLocation.mediaURL = urlTextField.text!
        studentLocation.latitude = placemark.location!.coordinate.latitude
        studentLocation.longitude = placemark.location!.coordinate.longitude
        
        performSegue(withIdentifier: "showLocationScreen", sender: nil)
        setFinding(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationScreen" {
            let addLocationViewController = segue.destination as! AddLocationViewController
            addLocationViewController.studentLocation = studentLocation
        }
    }
    
    func setFinding(_ finding: Bool) {
        locationTextField.isEnabled = !finding
        urlTextField.isEnabled = !finding
        findButton.isEnabled = !finding
        
        findButton.showLoading(finding)
    }
}

extension AddInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
