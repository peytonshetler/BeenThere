//
//  MapSearchVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/28/20.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(mapItem: MKMapItem)
}

extension MapSearchVC: addButtonDelegate {
    func addButtonTapped() {
        guard let mapItem = selectedMapItem else { return }

        let addPlaceVC = AddPlaceVC(with: mapItem)
        navigationController?.pushViewController(addPlaceVC, animated: true)
    }
}

class MapSearchVC: UIViewController {
    
    // MARK: - Properties
    var selectedMapItem: MKMapItem? {
        didSet {
            if selectedMapItem != nil {
                bottomSheetVC?.item = selectedMapItem!
            } else {
                bottomSheetVC?.item = nil
            }
        }
    }
    
    
    let searchPlaceholder = "Search locations by name"
   
    let mapView = MKMapView()
    
    var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var currentPlacemark: CLPlacemark?
    
    var searchController: UISearchController!
    var resultsTableView: BTMapSearchResultsTableView?
    var bottomSheetVC: BottomSheetVC?
    
    var cancelButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 5000
    var previousLocation: CLLocation?
    let geoCoder = CLGeocoder()
    
    var selectedPin: MKPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureNavBar()
        configureSearchController()
        checkLocationServices()
        configureMapView()
        addBottomSheetView()
    }
    
    
    func addBottomSheetView() {
        bottomSheetVC = BottomSheetVC(delegate: self)
        
        self.addChild(bottomSheetVC!)
        self.view.addSubview(bottomSheetVC!.view)
        bottomSheetVC!.didMove(toParent: self)

        bottomSheetVC!.addShadows()
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC!.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func configureNavBar() {
        title = "Explore"
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        navigationItem.leftBarButtonItem = cancelButton
    }
    
    
    // MARK: - Search Controller
    func configureSearchController() {

        resultsTableView = BTMapSearchResultsTableView(mapView: mapView, manager: locationManager)
        resultsTableView?.handleMapSearchDelegate = self

        searchController = UISearchController(searchResultsController: resultsTableView)
        searchController.searchResultsUpdater = resultsTableView

        searchController.searchBar.placeholder = searchPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.definesPresentationContext = true
        searchController.automaticallyShowsScopeBar = true

        navigationItem.searchController = searchController
    }

    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            presentBTErrorAlertOnMainThread(error: .locationError, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    // MARK: - Mapview
    func configureMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: -160),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.showsCompass = false
    }
    
    
    @objc func getDirections() {
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}


extension MapSearchVC : CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemark, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                return
            }
            
            self.currentPlacemark = placemark?.first
            self.boundingRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.resultsTableView!.updatePlacemark(self.currentPlacemark, boundingRegion: self.boundingRegion)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
    }
}


// MARK: - Handle Map Search Delegate
extension MapSearchVC: HandleMapSearch {

    func dropPinZoomIn(mapItem: MKMapItem) {

        selectedPin = mapItem.placemark

        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.placemark.name

        if let city = mapItem.placemark.locality, let state = mapItem.placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }

        mapView.addAnnotation(annotation)


        let region = MKCoordinateRegion.init(center: mapItem.placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapView.setRegion(region, animated: true)

        selectedMapItem = mapItem
    }
}

extension MapSearchVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = .orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: [])
        button.addTarget(self, action: #selector(MapSearchVC.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}
