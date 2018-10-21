//
//  ViewController.swift
//  Milpitas Senior Center
//
//  Created by Sahil Jain on 5/16/18.
//  Copyright © 2018 Sahil Jain. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    @IBOutlet weak var snrImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        snrImage.layer.masksToBounds=true
        snrImage.layer.borderWidth = 1
        snrImage.layer.borderColor = UIColor.white.cgColor

        addressLabel.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        addressLabel.numberOfLines = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction(sender:)))
        addressLabel.addGestureRecognizer(tap)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction2(sender:)))
        websiteLabel.addGestureRecognizer(tap2)
 snrImage.layer.cornerRadius=snrImage.bounds.width/5
        

    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        openMapForPlace()
        
        
    }
    @objc func tapFunction2(sender:UITapGestureRecognizer) {
        
        if let url = URL(string: "http://www.ci.milpitas.ca.gov/milpitas/departments/recreation-services/our-facilities/senior-center/") {
            UIApplication.shared.open(url, options: [:])
        }

        
    }


    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = 37.4337723
        let longitude: CLLocationDegrees = -121.89918990000001
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Barbara Lee Senior Center"
        mapItem.openInMaps(launchOptions: options)
    }


    @IBAction func callPlaced(_ sender: Any) {
        
        let number = "4085863400"

        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

