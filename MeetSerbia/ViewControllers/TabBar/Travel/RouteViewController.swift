//
//  RouteViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 28.3.23..
//

import Foundation
import UIKit
import MapboxMaps
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import Firebase
import MapboxDirections
import FirebaseDatabase
import MapboxSearch
import MapboxSearchUI

class RouteViewController: UIViewController, AnnotationInteractionDelegate {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var holderImageView: UIImageView!
    @IBOutlet weak var holderLabel: UILabel!
    private var panelController : MapboxPanelController?
    private var isCurrentSearch  = true
    private var heighConstraint = 80
    @IBOutlet weak var testButtonjff: UIButton!
    let textFieldCurrent = UITextField()
    let textFieldSelected = UITextField()
    let responseLabel = UILabel()
    var navigationMapView: NavigationMapView!
    
    var routeOptions: NavigationRouteOptions?
    var routeResponse: RouteResponse?
    var destionation:CLLocationCoordinate2D?
    var currentLocation: CLLocationCoordinate2D?
    var beginAnnotation: PointAnnotation?
    var selectedAnnotation: PointAnnotation?
    var currentLocationName :String?
    var destinationName:String?
    private let refrence = Database.database().reference()
    let padding = 0.020000
    var annotationsRig = [PointAnnotation]()
    var waypointsArray = [Waypoint]()
    var addedWaypointsArray = [Waypoint]()
    var waypointsNamesAndImagesarray = [String:UIImage]()
    private let storageRef = Storage.storage().reference().child("/images/locations")
    private let searchEngine = SearchEngine()
    let searchController = MapboxSearchController()
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        displayViews()
        searchControllerSetup()
        getAnotationsInBounds()
        getAnotationsInBounds()
        navigationSetup()
        searchController.delegate = self

    }
    
    // Search Controller Setup
    
    private func searchControllerSetup(){
        var searchOptions = SearchOptions()
        searchOptions.countries = ["rs"]
        searchOptions.boundingBox = BoundingBox(Constants().serbiaSouthWest, Constants().serbiaNorthEast)
        searchController.searchOptions = searchOptions
        searchController.searchBarPlaceholder = "унесите жељену локацију"
        searchController.categorySearchOptions?.limit = 0
        searchController.categorySearchOptions?.countries = ["rs"]
        searchController.configuration.hideCategorySlots = true
        textFieldCurrent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentDestinationTextFieldTapped)))
        textFieldSelected.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedDestinationTextFieldTapped)))
    }
    //Tap Gesture Recognizers
    
    @objc func selectedDestinationTextFieldTapped(){
        panelController?.view.isHidden = false
        textFieldSelected.isHidden = true
        isCurrentSearch = false
        let panelViewConstraints = [
            panelController!.view.heightAnchor.constraint(equalToConstant: 50),
            panelController!.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController!.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController!.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController!.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: CGFloat(80))
             ]
        NSLayoutConstraint.activate(panelViewConstraints)
        
       
     
    }
    @objc func currentDestinationTextFieldTapped(){
        // plavi tekst fild
        isCurrentSearch = true
        panelController?.view.isHidden = false
        textFieldSelected.isHidden = true
        textFieldCurrent.isHidden = true
        let panelViewConstraints = [
            panelController!.view.heightAnchor.constraint(equalToConstant: 50),
            panelController!.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController!.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController!.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController!.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: CGFloat(20))
             ]
        NSLayoutConstraint.activate(panelViewConstraints)
        
    }
    
    // Display Views
    
    private func displayViews(){
        navigationMapView = NavigationMapView(frame: view.bounds)
        panelController = MapboxPanelController(rootViewController: searchController)
        view.addSubview(navigationMapView)
        view.addSubview(textFieldCurrent)
        view.addSubview(textFieldSelected)
        view.bringSubviewToFront(textFieldCurrent)
        view.bringSubviewToFront(holderView)
        view.bringSubviewToFront(testButtonjff)
        addChild(panelController!)
        panelController?.view.alpha = 0.9
        panelController?.view.isHidden = true
        holderView.isHidden = true
      
     
        
       
    
    }
    private func navigationSetup(){
        navigationMapView.mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            self.navigationMapView.pointAnnotationManager?.delegate = self
        }
 
        navigationMapView.userLocationStyle = .puck2D()
        navigationMapView.navigationCamera.viewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .active)
        
    }
    
    func calculateNewRoute(pointes:[Waypoint]) {
        
        let routeOptions = NavigationRouteOptions(waypoints: pointes, profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                
                strongSelf.routeResponse = response
                strongSelf.routeOptions = routeOptions
                strongSelf.drawRoute(route: route)
            
                if var annotation = strongSelf.navigationMapView.pointAnnotationManager?.annotations.first {
                    annotation.textField = "Почни са Навигацијом"
                    annotation.textColor = .init(UIColor.white)
                    annotation.textHaloColor = .init(UIColor.systemBlue)
                    annotation.textHaloWidth = 2
                    annotation.textAnchor = .top
                    annotation.textRadialOffset = 1.0
                    strongSelf.beginAnnotation = annotation
                    strongSelf.navigationMapView.pointAnnotationManager?.annotations = [annotation]
                    
                }
            }
        }
    }
    
    func getAnotationsInBounds(){
        annotationsRig.removeAll()
        refrence.child("locations").getData { [self] er, snap in
            if er != nil {return}
            else {
                guard let locations = snap?.value as? [String:Any] else {return}
                for i in locations{
                    let one = i.value as! [String:Any]
                    let long = one["lon"] as! Double
                    let lat = one["lat"] as! Double
                    let name = one["nameEng"] as! String
                    let id = one["id"] as! String
                    let namelat = one["nameLat"] as! String
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    if getProximityAnnotations(start:Point(currentLocation!), end: Point(destionation!),coordinate: coordinate){
                        
                        var pointAnnotation = PointAnnotation(coordinate: coordinate)
                        pointAnnotation.image = .init(image: UIImage(named: "pin")!, name: "location")
                        pointAnnotation.iconAnchor = .bottom
                        pointAnnotation.textField = namelat
                        annotationsRig.append(pointAnnotation)
                        let pointAnnotationManager = navigationMapView.mapView.annotations.makePointAnnotationManager()
                        pointAnnotationManager.delegate = self
                        
                        storageRef.child(id).child("0.jpg").getData(maxSize: 10 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Handle error
                                print("Error downloading image: \(error.localizedDescription)")
                            } else {
                                // Load image into UIImageView or other UI element
                                if let imageData = data, let image = UIImage(data: imageData) {
                                    self.waypointsNamesAndImagesarray.updateValue(image, forKey: namelat)
                                    print(image)
                                } else {
                                    print("Error loading image data")
                                }
                            }
                        }
                        pointAnnotationManager.annotations = annotationsRig
                    } else {
                        print("no annotations")
                        
                    }
                }
                
            }
        }
    }
    func getProximityAnnotations(start:Point,end:Point,coordinate:CLLocationCoordinate2D) -> Bool{
        let west = min(start.coordinates.longitude, end.coordinates.longitude) - padding
        let east = max(start.coordinates.longitude, end.coordinates.longitude) + padding
        let south = min(start.coordinates.latitude, end.coordinates.latitude) - padding
        let north = max(start.coordinates.latitude, end.coordinates.latitude) + padding
        
        if (coordinate.longitude > west && coordinate.longitude < east && coordinate.latitude > south && coordinate.latitude < north){
            return true
        } else {
            return false
        }
    }
    
    
    func drawRoute(route:MapboxDirections.Route) {
        
        navigationMapView.show([route])
        navigationMapView.showRouteDurations(along: [route])
        
        navigationMapView.showWaypoints(on: route)
    }
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        
        if let anot = annotations.first as? PointAnnotation{
            if anot.image?.name == "default_marker"{
                holderView.isHidden = true
                guard annotations.first?.id == beginAnnotation?.id,
                      let routeResponse = routeResponse, let routeOptions = routeOptions else {
                    return
                }
                let navigationViewController = NavigationViewController(for: routeResponse, routeIndex: 0, routeOptions: routeOptions)
               
                navigationViewController.modalPresentationStyle = .fullScreen
               

                self.present(navigationViewController, animated: true, completion: nil)
            }
            if anot.isSelected {
                selectedAnnotation = anot
                updateHolderView(name: anot.textField!)
            } else {
                holderView.isHidden = true
            }
        }
    }
    private func updateHolderView(name:String){
        holderLabel.text = name
        holderImageView.image = waypointsNamesAndImagesarray[name]
        holderView.isHidden = false
        
    }

    @IBAction func addToRout(_ sender: Any) {
        
        addedWaypointsArray.append(Waypoint(coordinate: (selectedAnnotation?.point.coordinates)!))
        holderView.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldCurrent.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50*2, height: 50)
        textFieldCurrent.backgroundColor = .blue
        textFieldCurrent.textAlignment = .center
        textFieldCurrent.layer.cornerRadius = 10
        textFieldCurrent.textColor = .white
        textFieldCurrent.text  = currentLocationName
        textFieldSelected.frame = CGRect(x: 50, y: 170, width: view.bounds.width - 50*2, height: 50)
        textFieldSelected.backgroundColor = .white
        textFieldSelected.textAlignment = .center
        textFieldSelected.layer.cornerRadius = 10
        textFieldSelected.textColor = .blue
        textFieldSelected.text = destinationName!
        responseLabel.frame = CGRect(x: 50, y: textFieldCurrent.frame.maxY + 16, width: view.bounds.width - 50*2, height: 32)
        let panelViewConstraints = [
            panelController!.view.heightAnchor.constraint(equalToConstant: 50),
            panelController!.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 25),
            panelController!.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant:  -25),
            panelController!.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
            panelController!.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: CGFloat(heighConstraint))
             ]
        NSLayoutConstraint.activate(panelViewConstraints)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func testtapped(_ sender: Any) {
        waypointsArray.removeAll()
        waypointsArray.append(Waypoint(coordinate:currentLocation!))
        waypointsArray.append(contentsOf: addedWaypointsArray)
        waypointsArray.append(Waypoint(coordinate: destionation!))
        calculateNewRoute(pointes: waypointsArray)
        
    }
    
}

extension RouteViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        print("cSearch Recived")

    }
    func searchResultSelected(_ searchResult: SearchResult) {
        if (isCurrentSearch == true){
            currentLocation = searchResult.coordinate
            currentLocationName = searchResult.name
            panelController?.view.isHidden = true
            textFieldSelected.isHidden = false
            textFieldCurrent.isHidden = false
        } else {
            destionation = searchResult.coordinate
            destinationName = searchResult.name
            panelController?.view.isHidden = true
            textFieldSelected.isHidden = false
            textFieldCurrent.isHidden = false

        }

        
        
    }
    func categorySearchResultsReceived(results: [SearchResult]) {
        print("results recived")

        
    }
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        print("favourite recorded")
        
    }
    @objc
    func textFieldTextDidChanged() {
        searchEngine.query = textFieldSelected.text!
    }
    
}
