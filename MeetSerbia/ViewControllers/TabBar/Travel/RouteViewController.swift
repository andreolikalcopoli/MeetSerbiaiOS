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

class RouteViewController: UIViewController, AnnotationInteractionDelegate {
    var navigationMapView: NavigationMapView!
    var routeOptions: NavigationRouteOptions?
    var routeResponse: RouteResponse?
    var destionation:CLLocationCoordinate2D?
    var currentLocation: CLLocationCoordinate2D?
    var beginAnnotation: PointAnnotation?
    var cName :String?
    var locname:String?
    let textFieldCurrent = UITextField()
    let textFieldSelected = UITextField()
    let responseLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMapView = NavigationMapView(frame: view.bounds)
        view.addSubview(navigationMapView)
        view.addSubview(textFieldCurrent)
        view.addSubview(textFieldSelected)
        view.bringSubviewToFront(textFieldCurrent)
        // Set the annotation manager's delegate
        navigationMapView.mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            self.navigationMapView.pointAnnotationManager?.delegate = self
        }
        
        // Configure how map displays the user's location
        navigationMapView.userLocationStyle = .puck2D()
        // Switch viewport datasource to track `raw` location updates instead of `passive` mode.
        navigationMapView.navigationCamera.viewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        
        
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        navigationMapView.addGestureRecognizer(longPress)
       calculateRoute(from: currentLocation!, to: destionation!)
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: navigationMapView)
        
        let coordinate = navigationMapView.mapView.mapboxMap.coordinate(for: point)
        
        if let origin = navigationMapView.mapView.location.latestLocation?.coordinate {
            // Calculate the route from the user's location to the set destination
            calculateRoute(from: origin, to: coordinate)
       
        } else {
            print("Failed to get user location, make sure to allow location access for this application.")
        }
    }
    
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        // Coordinate accuracy is how close the route must come to the waypoint in order to be considered viable. It is measured in meters. A negative value indicates that the route is viable regardless of how far the route is from the waypoint.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Започни")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Заврши")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
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
                
                // Draw the route on the map after creating it
                strongSelf.drawRoute(route: route)
                
                if var annotation = strongSelf.navigationMapView.pointAnnotationManager?.annotations.first {
                    // Display callout view on destination annotation
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
    
    func drawRoute(route: Route) {
        
        navigationMapView.show([route])
        navigationMapView.showRouteDurations(along: [route])
        
        // Show destination waypoint on the map
        navigationMapView.showWaypoints(on: route)
    }
    
    // Present the navigation view controller when the annotation is selected
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard annotations.first?.id == beginAnnotation?.id,
              let routeResponse = routeResponse, let routeOptions = routeOptions else {
            return
        }
        let navigationViewController = NavigationViewController(for: routeResponse, routeIndex: 0, routeOptions: routeOptions)
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true, completion: nil)
    }
    func getLoc(coordinate:CLLocationCoordinate2D){
        
        let start = Waypoint(coordinate: currentLocation!, coordinateAccuracy: -1, name: "Mapbox")
        let end = Waypoint(coordinate: destionation!, coordinateAccuracy: -1, name: locname!)
        let routeOptions = NavigationRouteOptions(waypoints: [start, end])
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                // Pass the generated route response to the the NavigationViewController
                let viewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: routeOptions)
                viewController.modalPresentationStyle = .fullScreen
                strongSelf.present(viewController, animated: true, completion: nil)
            }
        }

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textFieldCurrent.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50*2, height: 50)
        textFieldCurrent.backgroundColor = .blue
        textFieldCurrent.textAlignment = .center
        textFieldCurrent.layer.cornerRadius = 10
        textFieldCurrent.isUserInteractionEnabled = false
        textFieldCurrent.textColor = .white
        textFieldCurrent.text  = cName
        textFieldSelected.frame = CGRect(x: 50, y: 170, width: view.bounds.width - 50*2, height: 50)
        textFieldSelected.backgroundColor = .white
        textFieldSelected.textAlignment = .center
        textFieldSelected.layer.cornerRadius = 10
        textFieldSelected.isUserInteractionEnabled = false
        textFieldSelected.textColor = .blue
        textFieldSelected.text = locname!
        responseLabel.frame = CGRect(x: 50, y: textFieldCurrent.frame.maxY + 16, width: view.bounds.width - 50*2, height: 32)
    }
}

