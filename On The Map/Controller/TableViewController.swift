//
//  TableViewController.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var locations: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStudentsLocations()
    }
    

    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
        } else {
            self.locations = locations
            tableView.reloadData()
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        getStudentsLocations()
    }
    
    func getStudentsLocations() {
        UdacityService.getUsers(completion: handleStudentLocationsResponse(locations:error:))
    }

}

extension TableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = location.firstName
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        guard let url = URL(string: location.mediaURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
