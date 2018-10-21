//
//  HomeViewController.swift
//  Milpitas Senior Center
//
//  Created by Sahil Jain on 10/9/18.
//  Copyright © 2018 Sahil Jain. All rights reserved.
//


import UIKit
import MapKit




class HomeViewController: UIViewController {
    
    
    @IBOutlet var snrimg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topBar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        collectionView!.collectionViewLayout = layout
        
        
        let lightgreen = UIColor(red: 0.88, green:0.93, blue: 0.867, alpha: 1.0)
        topBar.backgroundColor = UIColor(red:0.05, green:0.60, blue:0.73, alpha:1.0)
        
        let lightgray = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        
        snrimg.layer.cornerRadius = 5;
        snrimg.layer.masksToBounds = true;
        
        collectionView.backgroundColor = lightgreen
        self.view.backgroundColor = lightgreen
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width/2.1, height: 170)
        }
        
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as!
        HomeCollectionViewCell
        
        let lightgray = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        
        cell.backgroundColor = lightgray
        
        let arr = ["phone", "address_book", "about", "medical_ID"]
        let arr2 = ["Phone", "Email", "Directions", "Information"]
        
        let xvar = arr[indexPath.item]
        cell.photo.image = UIImage(named: "\(xvar).png")
        cell.title.text = arr2[indexPath.item]
        
        cell.layer.cornerRadius = 15;
        cell.layer.masksToBounds = true;
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
        
        let arr2 = ["Phone", "Email", "Directions", "Information"]
        
        if (arr2[indexPath.item] == "Phone") {
            print("Was Here")
            let number = "4085863400"
            
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
        }
        else if (arr2[indexPath.item] == "Email") {
            let email = "aasis@ci.milpitas.ca.gov"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                            }

        }
        else if (arr2[indexPath.item] == "Directions") {
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
        else if (arr2[indexPath.item] == "Information") {
            if let url = URL(string: "http://www.ci.milpitas.ca.gov/milpitas/departments/recreation-services/our-facilities/senior-center/") {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
        
    }
}

