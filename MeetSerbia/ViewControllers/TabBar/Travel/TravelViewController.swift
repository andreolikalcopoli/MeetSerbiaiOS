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
    private var panelController : MapboxPanelController?
    let searchEngine = SearchEngine()

    let textFieldCurrent = UITextField()
    let textFieldSelected = UITextField()
    let responseLabel = UILabel()

    var locationName:String?
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        getCurrentLocationName()
        self.view.addSubview(mapView)
        self.view.addSubview(textFieldSelected)
        self.view.addSubview(textFieldCurrent)
        addChild(panelController!)
        
    }
    
    private  func initSetup(){
        
//        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.backgroundColor = .white
        // Map
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibWVldHNlcmJpYSIsImEiOiJjbGY4NHNqb3UxbzJsM3pudGV4eGxrdmw2In0.U7yh9XHMImXSU3CxkLRbDg")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        // Delegates
        locationManager.delegate = self
        searchController.delegate = self
        self.tabBarController!.selectedIndex = 2
        textFieldSelected.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        textFieldSelected.isHidden = false
        //Search Controller
        var searchOptions = SearchOptions()
        searchOptions.countries = ["rs"]
        searchOptions.boundingBox = BoundingBox(Constants().serbiaSouthWest, Constants().serbiaNorthEast)
        searchController.searchOptions = searchOptions
        searchController.favoritesProvider.deleteAll()
        searchController.categorySearchOptions?.limit = 0
        searchController.categorySearchOptions?.countries = ["rs"]
        searchController.configuration.hideCategorySlots = true
        searchController.searchBarPlaceholder = "унесите жељену локацију"
        //PanelController
        panelController = MapboxPanelController(rootViewController: searchController)
        panelController!.view.alpha = 0.9
        panelController?.view.isHidden = true
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapTaped)))
        
    }
    
    @objc func tap (){
        textFieldSelected.isHidden = true
        panelController!.view.isHidden = false
    }
    @objc func mapTaped (){
        textFieldSelected.isHidden = false
        panelController!.view.isHidden = true

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
        textFieldCurrent.text  = locationName
        textFieldSelected.frame = CGRect(x: 50, y: 170, width: view.bounds.width - 50*2, height: 50)
        textFieldSelected.backgroundColor = .white
        textFieldSelected.textAlignment = .center
        textFieldSelected.layer.cornerRadius = 10
        textFieldSelected.textColor = .blue
        textFieldSelected.addTarget(self, action: #selector(textFieldTextDidChanged), for: .editingChanged)
        let panelViewConstraints = [
            panelController!.view.heightAnchor.constraint(equalToConstant: 50),

            panelController!.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController!.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController!.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController!.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80)
             ]
                NSLayoutConstraint.activate(panelViewConstraints)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        let yourCoordinate = CLLocationCoordinate2D(latitude: self.currentLatitude!, longitude: self.currentLongitude! )
        
        var pointAnnotation = PointAnnotation(coordinate: yourCoordinate)
        pointAnnotation.image = .init(image: UIImage(named: "pin")!, name: "Ви")
        pointAnnotation.iconAnchor = .bottom
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.delegate = self
        pointAnnotationManager.annotations = [pointAnnotation]
        
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MapView, tapOnCalloutFor annotation: Annotation) {
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
}

extension TravelViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        if let anot = annotations.first as? PointAnnotation{
            print(anot)
            let DVC  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
            DVC?.id = anot.image?.name ?? ""
            self.navigationController?.pushViewController(DVC!, animated: true)
        }
        
    }
    func getCurrentLocationName() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let currentLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
                if let error = error {
                    print("Error getting location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let locationName = placemark.name ?? "Unknown Location"
                    let city = placemark.locality ?? ""
                    self.locationName = locationName + ", \(city)"
                }
            }
        } else {
            print("Location is nil")
        }
    }
    
}

extension TravelViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        print("categoty results recived")
        
    }
    func searchResultSelected(_ searchResult: SearchResult) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Route") as? RouteViewController
        vc!.destionation = searchResult.coordinate
        vc!.currentLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
        vc!.destinationName = searchResult.name
        vc!.currentLocationName = locationName!
        self.dismiss(animated: true)
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    func categorySearchResultsReceived(results: [SearchResult]) {
        print("results recived")
        
    }
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        print("favourite sekected Sucessfully")
        
    }
    @objc func textFieldTextDidChanged() {
        searchEngine.query = textFieldSelected.text!
    }
}


