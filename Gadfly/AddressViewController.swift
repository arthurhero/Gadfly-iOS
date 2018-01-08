//
//  AddressViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddressViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap {

    @IBOutlet weak var mapContainer: UIView!
    
    var googleMapsView : GMSMapView!
    var searchResultController : SearchResultsController!
    var resultsArray = [String]()
    
    var selectedAddress : String = ""
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ConfirmButtonTapped(_ sender: Any) {
        if selectedAddress != "" {
            UserDefaults.standard.set(selectedAddress, forKey: "address")
            GFUser.cacheAddress(selectedAddress)
            performSegue(withIdentifier: "unwindToHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.googleMapsView = GMSMapView(frame: self.mapContainer.frame)
        self.view.addSubview(self.googleMapsView)
        
        self.searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }

    @IBAction func searchWithAddress(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.sync {
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = nil
            marker.map = self.googleMapsView
        }
        
        selectedAddress = title
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "US"

        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error) in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }

            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
