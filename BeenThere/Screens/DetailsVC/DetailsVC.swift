//
//  DetailsVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 11/29/20.
//

import UIKit
import MapKit
import CoreData

class DetailsVC: BTPrimaryViewController {
    
    // MARK: - Properties
    var offset: CGFloat = 280
    
    let persistence = PersistenceService.shared
    
    var place: BTPlace!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<DetailSection, DetailItem>!
    
    
    init(place: BTPlace) {
        super.init()
        self.place = place
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureHierarchy()
        configureDataSource()
        updateSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardEvents()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardEvents()
    }

    
    func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        collectionView.contentOffset.y = keyboardFrame.height - offset
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        self.collectionView.contentOffset.y =  -93
    }
    

    func configureNavBar() {
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        title = place.name
        
        if let roundedTitleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded)?
            .withSymbolicTraits(.traitBold) {
            navigationController?.navigationBar
                .largeTitleTextAttributes = [
                    .font: UIFont(descriptor: roundedTitleDescriptor, size: 24)
                ]
        }
    }
    
    
    // MARK: - Collection View
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MapViewCell.self, forCellWithReuseIdentifier: MapViewCell.identifier)
        collectionView.register(ActionButtonCell.self, forCellWithReuseIdentifier: ActionButtonCell.identifier)
        collectionView.register(DetailTagCell.self, forCellWithReuseIdentifier: DetailTagCell.identifier)
        collectionView.register(DetailNoteCell.self, forCellWithReuseIdentifier: DetailNoteCell.identifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    
    // MARK: - List View Cells    
    func createMapCellRegistration() -> UICollectionView.CellRegistration<MapViewCell, DetailItem> {
        return UICollectionView.CellRegistration<MapViewCell, DetailItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            
            cell.set(place: self.place)
        }
    }
    
    func createTagCellRegistration() -> UICollectionView.CellRegistration<DetailTagCell, DetailItem> {
        return UICollectionView.CellRegistration<DetailTagCell, DetailItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            
            cell.set(item: item, tag: self.place.tag)
        }
    }
    
    func createFavoriteCellRegistration() -> UICollectionView.CellRegistration<DetailFavoriteCell, DetailItem> {
        return UICollectionView.CellRegistration<DetailFavoriteCell, DetailItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }

            cell.set(itemType: item, place: self.place, delegate: self)
        }
    }
    
    func createNoteCellRegistration() -> UICollectionView.CellRegistration<DetailNoteCell, DetailItem> {
        return UICollectionView.CellRegistration<DetailNoteCell, DetailItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }

            cell.set(note: self.place.note, delegate: self)
        }
    }
    
    func createActionButtonCellRegistration() -> UICollectionView.CellRegistration<ActionButtonCell, DetailItem> {
        return UICollectionView.CellRegistration<ActionButtonCell, DetailItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            
            cell.set(item: item, place: self.place)
        }
    }
    
    
    // MARK: - Data Source
    func configureDataSource() {
        let mapViewCellRegistration = createMapCellRegistration()
        let actionButtonCellRegistration = createActionButtonCellRegistration()
        let tagCellRegistration = createTagCellRegistration()
        let favoriteCellRegistration = createFavoriteCellRegistration()
        let noteCellRegistration = createNoteCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<DetailSection, DetailItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let section = DetailSection(rawValue: indexPath.section) else {
                fatalError("Unknown section")
            }
            
            switch section {
            case .map:

                return collectionView.dequeueConfiguredReusableCell(using: mapViewCellRegistration, for: indexPath, item: item)
                
            case .actions:
                
                return collectionView.dequeueConfiguredReusableCell(using: actionButtonCellRegistration, for: indexPath, item: item)
                
            case .tag:
                
                return collectionView.dequeueConfiguredReusableCell(using: tagCellRegistration, for: indexPath, item: item)
                
            case .favorite:

                return collectionView.dequeueConfiguredReusableCell(using: favoriteCellRegistration, for: indexPath, item: item)
                
            case .note:

                return collectionView.dequeueConfiguredReusableCell(using: noteCellRegistration, for: indexPath, item: item)
            }
        }
    }
    

    // MARK: - Layout
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard let sectionKind = DetailSection(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .map:
                return self.createMapSection()
                
            case .actions:
                return self.createActionButtonSection()

            case .tag:
                return self.createTagSection()
                
            case .favorite:
                return self.createFavoriteSection()
                
            case .note:
                return self.createNoteSection()
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    
    // MARK: - Sections
    func createMapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        return section
    }
    
    func createActionButtonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.22), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
    
    func createTagSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    func createFavoriteSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20)

        return section
    }
    
    func createNoteSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    
    // MARK: - Snapshot
    func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailItem>()
        snapshot.appendSections(DetailSection.allCases)

        for section in DetailSection.allCases {
            snapshot.appendItems(section.items, toSection: section)
        }

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    func call(phoneNumber: String) {
        if !phoneNumber.isEmpty {
            if let encoded = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: "tel://\(encoded)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    func openInMaps(lat: Double, long: Double, name: String) {

        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func configureAddressMessage() -> String {
        if place.location != nil {
            return Helpers.Location.parseAddress(selectedItem: place.location!)
        } else {
            return ""
        }
    }
    
    func sharePlace(place: BTPlace) {
        
        let formatted = """
        \(place.name)

        \(configureAddressMessage())
        """
        
        let activityVC = UIActivityViewController(activityItems: [formatted], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}


extension DetailsVC: DetailFavoriteCellDelegate, DetailNoteCellDelegate {
    func updateFavoriteStatus(state: Bool) {
        self.place.isFavorite = state
        
        persistence.save { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success:
                return ()
            case .failure(let error):
                self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
            }
        }
    }
    
    func updatePlaceNote(note: String) {
        self.place.note = note
        
        debounceAndSave(interval: 1.0)
    }
    
    
    func debounceAndSave(interval: TimeInterval) {
        var searchTimer: Timer?
        
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { return }
            
            self.persistence.save { (result) in
                
                switch result {
                case .success:
                    return ()
                case .failure(let error):
                    self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
                }
            }
        })
    }
}


extension DetailsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        switch item {
        case .map:
            let mapVC = MapDetailsVC(with: place)
            navigationController?.pushViewController(mapVC, animated: true)
        case .phone:
            if let location = place.location {
                call(phoneNumber: location.phoneNumber)
            } else {
                presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            }
            
        case .safari:
            if let location = place.location {
                openSafari(url: location.url)
            } else {
                presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            }
           
        case .share:
            sharePlace(place: place)
        case .navigate:
            if let location = place.location {
                openInMaps(lat: location.latitude, long: location.longitude, name: place.name)
            } else {
                presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            }
            
        case .tag, .note, .favorite: return ()
        }
    }
}


enum DetailSection: Int, CaseIterable, CustomStringConvertible {
    case map
    case actions
    case tag
    case favorite
    case note

    var items: [DetailItem] {
        switch self {
        case .map: return [.map]
        case .actions: return [.phone, .safari, .share, .navigate]
        case .tag: return [.tag]
        case .favorite: return [.favorite]
        case .note: return [.note]
        }
    }
    
    var description: String {
        switch self {
        case .map: return "Map"
        case .actions: return "Actions"
        case .tag: return "Tag"
        case .favorite: return "Favorite"
        case .note: return "Note"
        }
    }
}

enum DetailItem: CaseIterable {
    case map
    case phone
    case safari
    case share
    case navigate
    case tag
    case favorite
    case note
}
