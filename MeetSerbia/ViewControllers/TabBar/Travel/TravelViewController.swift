//
//  TravelViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import UIKit
import MapboxMaps
import MapboxCoreMaps
import CoreLocation
import Firebase
import MapboxCommon
import MapboxCoreNavigation
import MapboxSearch
import MapboxSearchUI


class TravelViewController: UIViewController, CLLocationManagerDelegate {

    
    internal var mapView: MapView!
    var locationManager = CLLocationManager()
    let searchController = MapboxSearchController()
    let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    let textFieldCurrent = UITextField()
    let textFieldSelected = UITextField()
    let responseLabel = UILabel()
    let searchEngine = SearchEngine()
    var flag = true

    var con:String?
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    var zz =  [CoordinateModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.top
        // set up location manager
        locationManager.delegate = self
//        addMarkersFromFirebase()
        // set up map view
        self.tabBarController!.selectedIndex = 2
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibWVldHNlcmJpYSIsImEiOiJjbGY4NHNqb3UxbzJsM3pudGV4eGxrdmw2In0.U7yh9XHMImXSU3CxkLRbDg")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        //        let cameraOptions = CameraOptions(bounds:bounds,padding: .zero)
        //        mapView.camera.ease(to: cameraOptions, duration: 1.0)
        searchController.delegate = self
        getCurrentLocationName()
        self.view.addSubview(mapView)
        view.addSubview(textFieldSelected)
        textFieldSelected.isHidden = false
        var searchOptions = SearchOptions()
        searchOptions.countries = ["rs"]
        
        
        searchOptions.boundingBox = BoundingBox(serbiaSouthWest, serbiaNorthEast)// Limit results to Serbia
        searchController.searchOptions = searchOptions
        view.addSubview(textFieldCurrent)
        searchController.favoritesProvider.deleteAll()

        textFieldSelected.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
       
        searchController.categorySearchOptions?.limit = 0
        searchController.categorySearchOptions?.countries = ["rs"]
        searchController.configuration.hideCategorySlots = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        searchController.searchBarPlaceholder = "унесите жељену локацију"
        textFieldSelected.addGestureRecognizer(tapGesture)
        let panelController = MapboxPanelController(rootViewController: searchController)

        panelController.view.alpha = 0.9
        panelController.view.isHidden = flag
        addChild(panelController)
        
        let panelViewConstraints = [
            panelController.view.heightAnchor.constraint(equalToConstant: 50),

            panelController.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80)
             ]
                NSLayoutConstraint.activate(panelViewConstraints)
    }
    @objc func tap (){
        textFieldSelected.isHidden = true
        flag = false
        let panelController = MapboxPanelController(rootViewController: searchController)

        panelController.view.alpha = 0.9
        panelController.view.isHidden = flag
        addChild(panelController)
        
        let panelViewConstraints = [
            panelController.view.heightAnchor.constraint(equalToConstant: 50),

            panelController.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80)
             ]
                NSLayoutConstraint.activate(panelViewConstraints)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        responseLabel.lineBreakMode = .byTruncatingMiddle
        responseLabel.frame = CGRect(x: 50, y: textFieldSelected.frame.maxY + 16, width: view.bounds.width - 50*2, height: 32)
        textFieldCurrent.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50*2, height: 50)
        textFieldCurrent.backgroundColor = .blue
        textFieldCurrent.textAlignment = .center
        textFieldCurrent.layer.cornerRadius = 10
        textFieldCurrent.isUserInteractionEnabled = false
        textFieldCurrent.textColor = .white
        textFieldCurrent.text  = con
        textFieldSelected.frame = CGRect(x: 50, y: 170, width: view.bounds.width - 50*2, height: 50)
        textFieldSelected.backgroundColor = .white
        textFieldSelected.textAlignment = .center
        textFieldSelected.layer.cornerRadius = 10
        textFieldSelected.textColor = .blue
        
        textFieldSelected.addTarget(self, action: #selector(textFieldTextDidChanged), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let panelController = MapboxPanelController(rootViewController: searchController)

        panelController.view.isHidden = flag
    }
    @objc func tapped(){
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // check location authorization status
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.mapView.mapboxMap.setCamera(to: CameraOptions(center: location.coordinate, zoom:14))
        }
        
        // store the current location
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        let yourCoordinate = CLLocationCoordinate2D(latitude: self.currentLatitude!, longitude: self.currentLongitude! )
        
        var pointAnnotation = PointAnnotation(coordinate: yourCoordinate)
        pointAnnotation.image = .init(image: UIImage(named: "point")!, name: "Ви")
        pointAnnotation.iconAnchor = .bottom
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.delegate = self
        pointAnnotationManager.annotations = [pointAnnotation]
        
        // stop updating location to conserve battery
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MapView, tapOnCalloutFor annotation: Annotation) {
        // handle the tap on the marker here
        if annotation is PointAnnotation {
            print("Tapped on marker with title: ")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Access Denied", message: "Please grant location access in the Settings app to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }

    func addMarkersFromFirebase() {
        
        let ref = Database.database().reference(withPath: "locations")
        ref.observeSingleEvent(of: .value) { [weak self] snapshot  in
            guard let locations = snapshot.value as? [String: Any] else { return }
            for (_, value) in locations {
                
                guard let location = value as? [String: Any],
                      let name = location["id"] as? String,
                      let latitude = location["lat"] as? Double,
                      let longitude = location["lon"] as? Double else { continue }
                
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                var pointAnnotation = PointAnnotation(coordinate: coordinate)
                pointAnnotation.image = .init(image: UIImage(named: "point")!, name: name)
                pointAnnotation.iconAnchor = .bottom
                let pointAnnotationManager = self?.mapView.annotations.makePointAnnotationManager()
                pointAnnotationManager!.delegate = self
                pointAnnotationManager!.annotations = [pointAnnotation]
                
            }
        }
    }
    
}

extension TravelViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        if let anot = annotations.first as? PointAnnotation{
            
            let DVC  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
            DVC?.id = anot.image?.name ?? ""
            self.navigationController?.pushViewController(DVC!, animated: true)
        }
        
    }
    func getCurrentLocationName() {
        locationManager.requestWhenInUseAuthorization() // request permission to access location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // set desired accuracy
        locationManager.startUpdatingLocation() // start updating location
        
        if let currentLocation = locationManager.location {
            // use reverse geocoding to get location name
            CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
                if let error = error {
                    print("Error getting location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let locationName = placemark.name ?? "Unknown Location"
                    let city = placemark.locality ?? ""
                    self.con = locationName + ", \(city)"
                }
            }
        } else {
            print("Location is nil")
        }
    }
    
}

extension TravelViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        print("1111111111111111gfklshdhsgdjkgdhskjh1klgnklsdlgnsldkgskndgsgkknl1111")
        
    }
    func searchResultSelected(_ searchResult: SearchResult) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Route") as? RouteViewController
        vc!.destionation = searchResult.coordinate
        vc!.currentLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
        vc!.locname = searchResult.name
        vc!.cName = con!
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    func categorySearchResultsReceived(results: [SearchResult]) {
        print("1111111111111111gfklshdhsgdjkgdhskjh1klgnklsdlgnsldkgskndgsgkknl1111")
        
    }
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        print("1111111111111111gfklshdhsgdjkgdhskjh1klgnklsdlgnsldkgskndgsgkknl1111")
        
    }
    
    
}

extension TravelViewController {
    
    @objc
    func textFieldTextDidChanged() {
        /// Update `SearchEngine.query` field as fast as you need. `SearchEngine` waits a short amount of time for the query string to optimize network usage.
        searchEngine.query = textFieldSelected.text!
    }
}
