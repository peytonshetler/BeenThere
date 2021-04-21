//
//  MapViewCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/3/21.
//

import UIKit
import MapKit


class MapViewCell: UICollectionViewCell {

    static var identifier = "MapCell"
    let mapView = MKMapView()
    
    var place: BTPlace!
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(place: BTPlace) {
        self.place = place
        
        setMapView()
    }
    
    
    func configure() {
        contentView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.isUserInteractionEnabled = false
        mapView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    func setMapView() {
        let annotation = MKPointAnnotation()
        
        let longitude = place.location != nil ? place.location!.longitude : 0.0
        let latitude = place.location != nil ? place.location!.latitude : 0.0
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        annotation.title = place.name

        let city = place.location != nil ? place.location!.locality : ""
        let state = place.location != nil ? place.location!.administrativeArea : ""
        annotation.subtitle = "\(city) \(state)"

        mapView.addAnnotation(annotation)


        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)

        mapView.setRegion(region, animated: true)
    }
}
