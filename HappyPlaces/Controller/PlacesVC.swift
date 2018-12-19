//
//  PlacesVC.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlacesVC: UIViewController, UIGestureRecognizerDelegate {
    
    //OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    
    //VARIABLES
    private let locationManager = CLLocationManager()
    private var place: String = ""
    private var radius: Double = 0.0
    private var destinationPlacemark: MKPlacemark!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        checkLocationServices()
        dismissInfoView()
        
    }

    //UPDATE PLACE NAME AND DISATANCE FROM PREVIOUS SCREEN
    func updatePlaceParameters(place: PlaceModel){
        self.place = place.title
        self.radius = place.distance * 1000.0
    }

    //GO TO DIRECTIONS ACTION
    @IBAction func goDirectionsAction(_ sender: Any) {
        let destinationPlacemark = self.destinationPlacemark
        let send = DestinationPlacemarkModel.init(destinationPlacemark: destinationPlacemark)
        performSegue(withIdentifier: "directionsSegue", sender: send)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let directionsVC = segue.destination as? DirectionsVC {
            directionsVC.updateDestinationLocation(destination: sender as! DestinationPlacemarkModel)
        }
    }
    
}

//EXTENSIONS
//CORELOCATION DELEGATE
extension PlacesVC: CLLocationManagerDelegate {
    
    //CHECK LOCATION SERVICES ENABLED/NOT
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            checkAuth()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //CHECK APP PERMISSIONS
    private func checkAuth(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            showLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //SETUP LOCATION
    private func showLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        centerMap()
    }
    
    //CENTER MAP ON CURRENT LOCATION
    private func centerMap() {
        if let location = locationManager.location?.coordinate {
            let centerLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let centerRegion = MKCoordinateRegion(center: centerLocation, latitudinalMeters: radius, longitudinalMeters: radius)
            mapView.setRegion(centerRegion, animated: true)
            showPlaces()
        }
    }
    
    //SHOW SEARCHED PLACE
    private func showPlaces(){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = place
        searchRequest.region.center = mapView.region.center
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let places = response?.mapItems else {
                return
            }
            
            for place in places {
                let annotation = MKPointAnnotation()
                annotation.coordinate = place.placemark.coordinate
                annotation.title = place.placemark.name
                annotation.subtitle = "\(place.placemark.subThoroughfare ?? "") \(place.placemark.thoroughfare ?? "")"
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let centerRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(centerRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("ERROR")
    }
}

//MAPVIEW DELEGATE
extension PlacesVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let destinationLocation = view.annotation?.coordinate else {
            return
        }
        if view.annotation?.title == "My Location" {
            return
        }
        bottomLayout.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        placeLabel.text = view.annotation?.title!
        placeAddressLabel.text = view.annotation?.subtitle ?? "no address"
        let destinationCoordiante = CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordiante)
        self.destinationPlacemark = destinationPlacemark
    }
    
    
    //TAP GESTURE TO DISMISS BOTTOM VIEW
    private func dismissInfoView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
        
    }
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        bottomLayout.constant = -150
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        placeLabel.text = ""
        placeAddressLabel.text = ""
    }
}
