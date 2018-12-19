//
//  DirectionsVC.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/2/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DirectionsVC: UIViewController {

    //OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
    //VARIABLES
    private let locationManager = CLLocationManager()
    private var destinationPlacemark: MKPlacemark!
    private var transportType = MKDirectionsTransportType.automobile
    private var distance: Double!
    private var minutes: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        checkLocationServices()
    }

    func updateDestinationLocation(destination: DestinationPlacemarkModel){
        self.destinationPlacemark = destination.destinationPlacemark!
    }

    @IBAction func transportChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transportType = MKDirectionsTransportType.automobile
            drawRoute(withTransportType: transportType)
            break
        case 1:
            transportType = MKDirectionsTransportType.walking
            drawRoute(withTransportType: transportType)
            break
        default:
            transportType = MKDirectionsTransportType.automobile
            drawRoute(withTransportType: transportType)
        }
    }
    
    
}

//EXTENSIONS
//CORELOCATION DELEGATE
extension DirectionsVC: CLLocationManagerDelegate {
    
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            checkAuth()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func checkAuth(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            showLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func showLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        putAnnotation()
    }
    
    private func updateViews(){
        nameLabel.text = destinationPlacemark.subThoroughfare
        kmLabel.text = "\(String(format: "%.0f", distance)) km"
        minLabel.text = "\(String(format: "%.0f", minutes)) min"        
    }
}

//MAPVIEW DELEGATE
extension DirectionsVC: MKMapViewDelegate {
    
    private func putAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationPlacemark.coordinate
        annotation.title = destinationPlacemark.name
        mapView.addAnnotation(annotation)
        drawRoute(withTransportType: transportType)
    }
    
    private func drawRoute(withTransportType transportType: MKDirectionsTransportType){
        guard let currentLocation = locationManager.location?.coordinate else {
            return
        }
        let directionRequest = MKDirections.Request()
        let sourceCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = transportType
        directionRequest.requestsAlternateRoutes = true
        let directionsLocate = MKDirections(request: directionRequest)
        directionsLocate.calculate { (response, error) in
            if error != nil {
                return
            } else {
                guard let routes = response?.routes else {
                    return
                }
                self.mapView.removeOverlays(self.mapView.overlays)
                for route in routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    self.distance = route.distance / 1000
                    self.minutes = route.expectedTravelTime / 60
                }
                self.updateViews()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        switch self.transportType {
        case .automobile:
            renderer.strokeColor = .red
            renderer.lineWidth = 5
        default:
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
        }
        return renderer
    }
}
