//
//  ViewController.swift
//  Maps
//
//  Created by Radi on 3/14/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let mapDots : [Dot] = Dot.getRandomDots(count: 50)
    fileprivate let dotReuseIdentifier : String = "dotPin"

    @IBOutlet weak var map: MKMapView! {
        didSet {
            self.map.delegate = self
            self.map.mapType = MKMapType.standard
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.addAnnotations(self.mapDots)
        self.map.showAnnotations(self.mapDots, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.dotReuseIdentifier) as? DotAnnotation
        if annotationView == nil {
            annotationView = DotAnnotation(annotation: annotation,
                                           reuseIdentifier: self.dotReuseIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        if let dotAnnotation = annotation as? Dot {
            annotationView?.setSize(size: dotAnnotation.gender == Gender.Female ?
                CGSize(width: 20.0, height: 20.0) :
                CGSize(width: 30.0, height: 30.0))
        }
        
        return annotationView
    }
}

