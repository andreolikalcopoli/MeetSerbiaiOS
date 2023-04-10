//
//  HomeNavigationViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.4.23..
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


class FilteredMapViewController:UIViewController,CLLocationManagerDelegate{
  
    
    var category = ""
    var subCategory = ""
    let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    var locationManager = CLLocationManager()
    private let refrence = Database.database().reference()
    internal var mapView: MapView!
    private var locationsList = [LocationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    private func initSetup(){
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibWVldHNlcmJpYSIsImEiOiJjbGY4NHNqb3UxbzJsM3pudGV4eGxrdmw2In0.U7yh9XHMImXSU3CxkLRbDg")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        self.view.addSubview(mapView)
        if subCategory == ""{
            getLocations(cat:category)
        } else {
            getLocationsSub(subCat: subCategory)

        }
    }
    func getLocations(cat:String) {
            
        let ref = Database.database().reference(withPath: "locations")
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            guard let locations = snapshot.value as? [String: Any] else { return }
           
            for (_, value) in locations {
                guard let location = value as? [String: Any],
                      let category = location["category"] as? String,
                      let desCir = location["descriptionCir"] as? String,
                      let desEng = location["descriptionEng"] as? String,
                      let desLat = location["descriptionLat"] as? String,
                      let id = location["id"] as? String,
                      let images = location["images"] as? [String],
                      let video = location["video"] as? String,
                      let latitude = location["lat"] as? Double,
                      let subcat = location["subcat"] as? String,
                      let nameCir = location["nameCir"] as? String,
                      let nameEng = location["nameEng"] as? String,
                      let nameLat = location["nameLat"] as? String,
                      let longitude = location["lon"] as? Double else { continue }
                        let item = LocationModel(category: category, descriptionCir: desCir, descriptionEng: desEng, descriptionLat: desLat, id: id, images: images, lat: latitude, lon: longitude, nameCir: nameCir, nameEng: nameEng, nameLat: nameLat, subcat: subcat, video: video)
                if item.category == cat {
                    let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                    var pointAnnotation = PointAnnotation(coordinate: coordinate)
                    pointAnnotation.image = .init(image: UIImage(named: "point")!, name: nameLat)
                    pointAnnotation.iconAnchor = .bottom
                    let pointAnnotationManager = self?.mapView.annotations.makePointAnnotationManager()
                    pointAnnotationManager!.delegate = self
                    pointAnnotationManager!.annotations = [pointAnnotation]
                }
               
            }

        }
    }
    func getLocationsSub(subCat:String) {
        let ref = Database.database().reference(withPath: "locations")
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            guard let locations = snapshot.value as? [String: Any] else { return }
            for (_, value) in locations {
                
                guard let location = value as? [String: Any],
                      let category = location["category"] as? String,
                      let desCir = location["descriptionCir"] as? String,
                      let desEng = location["descriptionEng"] as? String,
                      let desLat = location["descriptionLat"] as? String,
                      let id = location["id"] as? String,
                      let images = location["images"] as? [String],
                      let video = location["video"] as? String,
                      let latitude = location["lat"] as? Double,
                      let subcat = location["subcat"] as? String,
                      let nameCir = location["nameCir"] as? String,
                      let nameEng = location["nameEng"] as? String,
                      let nameLat = location["nameLat"] as? String,
                      let longitude = location["lon"] as? Double else { continue }
                        let item = LocationModel(category: category, descriptionCir: desCir, descriptionEng: desEng, descriptionLat: desLat, id: id, images: images, lat: latitude, lon: longitude, nameCir: nameCir, nameEng: nameEng, nameLat: nameLat, subcat: subcat, video: video)
                if item.subcat == subCat {
                    let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                    var pointAnnotation = PointAnnotation(coordinate: coordinate)
                    pointAnnotation.image = .init(image: UIImage(named: "point")!, name: nameLat)
                    pointAnnotation.iconAnchor = .bottom
                    let pointAnnotationManager = self?.mapView.annotations.makePointAnnotationManager()
                    pointAnnotationManager!.delegate = self
                    pointAnnotationManager!.annotations = [pointAnnotation]
                }
               
            }

        }
    }

}
extension FilteredMapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        if let anot = annotations.first as? PointAnnotation{
            
                        let DVC  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
                        DVC?.id = anot.image?.name ?? ""
                        self.navigationController?.pushViewController(DVC!, animated: true)
        }
        
    }
}
