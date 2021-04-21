//
//  MapSearchResultsVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/28/20.
//

import UIKit
import MapKit

class BTMapSearchResultsTableView: UITableViewController {
    
    // MARK: - Properties
    weak var handleMapSearchDelegate: HandleMapSearch?
    
    let rowHeight: CGFloat = 60.0
    let sectionHeight: CGFloat = 60.0
    var itemsSet: Bool = false
    
    private var matchingItems: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            matchingItems = nil
            localSearch?.cancel()
        }
    }
    
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var currentPlacemark: CLPlacemark?
    
    var completerResults: [MKLocalSearchCompletion]?
    
    let regionInMeters: Double = 5000
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var emptyStateView: BTEmptyStateView?

    
    init(mapView: MKMapView, manager: CLLocationManager) {
        super.init(style: .plain)
        self.mapView = mapView
        self.locationManager = manager
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProvidingCompletions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProvidingCompletions()
    }
    
    private func startProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
    
    private func stopProvidingCompletions() {
        searchCompleter = nil
    }
    
    func updatePlacemark(_ placemark: CLPlacemark?, boundingRegion: MKCoordinateRegion) {
        currentPlacemark = placemark
        searchCompleter?.region = searchRegion
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        let title = UILabel()
       
        title.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(title)
        
        headerView.backgroundColor = tableView.backgroundColor

        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 14),
            title.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])

        if let city = currentPlacemark?.locality {
            title.text = "Results near: \(city)"
        }

        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapSearchResultsCell.identifier, for: indexPath) as! MapSearchResultsCell
        
        if let suggestion = completerResults?[indexPath.row] {
            cell.set(title: suggestion.title, subtitle: suggestion.subtitle)
        }

        return cell
    }
}


// MARK: - Search Controller
extension BTMapSearchResultsTableView : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        
        self.searchCompleter?.queryFragment = searchText
    }
}


// MARK: - TableView
extension BTMapSearchResultsTableView {
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        tableView.delegate = self
        tableView.register(MapSearchResultsCell.self, forCellReuseIdentifier: MapSearchResultsCell.identifier)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let suggestion = completerResults?[indexPath.row] {
            
            let searchRequest = MKLocalSearch.Request(completion: suggestion)
           
            search(using: searchRequest) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    
                    guard let mapItem = self.matchingItems?[0] else { return }
                    
                    self.handleMapSearchDelegate?.dropPinZoomIn(mapItem: mapItem)
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - Search func
    private func search(using searchRequest: MKLocalSearch.Request, completion: @escaping(Result<Bool, BTError>) -> Void) {
        
        searchRequest.region = boundingRegion
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            if error != nil {
                completion(.failure(.generalError))
            }
            
            self.matchingItems = response?.mapItems
            
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
            
            completion(.success(true))
        }
    }
    
    @objc func showEmptyStateView() {
        let emptyStateMessage = "No Results"
            
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        emptyStateView = BTEmptyStateView(message: emptyStateMessage, frame: size)

        tableView.backgroundView = emptyStateView
    }
    
    
    func hideEmptyStateView() {
        tableView.backgroundView = nil
    }
}

extension BTMapSearchResultsTableView: MKLocalSearchCompleterDelegate {
   
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if emptyStateView != nil {
            hideEmptyStateView()
        }
        
        completerResults = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        if (error as NSError?) != nil {
            showEmptyStateView()
            presentBTErrorAlertOnMainThread(error: .badInternetConnection, completion: nil)
        }
    }
}


// MARK: - UISearchBarDelegate
extension BTMapSearchResultsTableView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text

        search(using: searchRequest) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success: return ()
            case .failure(let error):
                self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
            }
        }
    }
}

