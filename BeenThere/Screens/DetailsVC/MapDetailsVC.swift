//
//  MapDetailsVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/3/21.
//

import UIKit
import MapKit

class MapDetailsVC: UIViewController {
    
    var place: BTPlace!
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureMapView()
        centerMapOnPlace()
    }
    
    
    init(with place: BTPlace) {
        super.init(nibName: nil, bundle: nil)
        
        self.place = place
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func centerMapOnPlace() {
        let annotation = MKPointAnnotation()
        
        let city = place.location != nil ? place.location!.locality : ""
        let state = place.location != nil ? place.location!.administrativeArea : ""
        let latitude = place.location != nil ? place.location!.latitude : 0.0
        let longitude = place.location != nil ? place.location!.longitude : 0.0
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        annotation.title = place.name

        annotation.subtitle = "\(city) \(state)"

        mapView.addAnnotation(annotation)


        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapView.setRegion(region, animated: true)
    }
    
    func configureNavBar() {
        title = place.name
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
