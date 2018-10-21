//
//  OppViewController.swift
//  highSchoolVolunteer
//
//  Created by Sahil Jain on 6/15/17.
//  Copyright © 2017 Sahil Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import EventKit

class OppViewController: UITableViewController, UINavigationBarDelegate,  OppTableViewCellDelegate{
    
    
    let sectionTitle = ["Events", "Presentations", "Information Tables"]

    var items: [Array<VolunteerOpp>] = [[], [], []]
    var items2: [Array<VolunteerOpp>] = [[], [], []]

    var array: [VolunteerOpp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReference()
        var refreshControl: UIRefreshControl? = {
            let refresControl = UIRefreshControl()
            refresControl.addTarget(self, action: #selector(OppViewController.refreshOptions(sender:)), for: .valueChanged)
            
            refresControl.tintColor = UIColor.gray
            refresControl.attributedTitle = NSAttributedString(string: "Updating the Events Now!")
            return refresControl
        }()
        
        tableView.refreshControl = refreshControl


    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        array = []
        getReference()
    }

    func getReference() {
        
        print("Was here")
        
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://milpitas-senior-center.firebaseio.com/")
        
        
        ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            print(value)

            self.items[0].removeAll()

            var indexNow = 0;
            var counter: Int = 1;
            for item in value! {
                
                
                var date = "";
                var time = "";
                var eventOrganizer = "";
                let oppName = item.key
//                var itemValues = ((item.value as! NSDictionary).allValues)
//                var keys = ((item.value as! NSDictionary).allKeys)
                
                let dic = item.value as! Dictionary<String, Any>
                
                for item in dic {
                    if item.key.lowercased().range(of:"time") != nil {
                        print(item.value)
                        time = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"event organizer") != nil {
                        print(item.value)

                        eventOrganizer = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"date") != nil {
                        print(item.value)

                        date = item.value as! String
                    }

                }
                
//                print(dic)


                let volunteerOppItem = VolunteerOpp(date: date, volunteerOpportunity: oppName as! String, location: eventOrganizer, whoWeAre: time)
                
                self.array.append(volunteerOppItem)
                print(indexNow)
                self.items[indexNow].append(volunteerOppItem)
//                indexNow = indexNow + 1;
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if (counter == value?.count) {
//                        self.refreshControl?.endRefreshing()
                    }
                    else {
                        counter = counter + 1;
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("Presentations").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            print(value)
            
            self.items[1].removeAll()
            
            var indexNow = 1;
            var counter: Int = 1;
            for item in value! {
                
                
                var date = "";
                var time = "";
                var eventOrganizer = "";
                let oppName = item.key
                //                var itemValues = ((item.value as! NSDictionary).allValues)
                //                var keys = ((item.value as! NSDictionary).allKeys)
                
                let dic = item.value as! Dictionary<String, Any>
                
                for item in dic {
                    if item.key.lowercased().range(of:"time") != nil {
                        print(item.value)
                        time = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"event organizer") != nil {
                        print(item.value)
                        
                        eventOrganizer = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"date") != nil {
                        print(item.value)
                        
                        date = item.value as! String
                    }
                    
                }
                
                //                print(dic)
                
                
                let volunteerOppItem = VolunteerOpp(date: date, volunteerOpportunity: oppName as! String, location: eventOrganizer, whoWeAre: time)
                
                self.array.append(volunteerOppItem)
                print(indexNow)
                self.items[indexNow].append(volunteerOppItem)
                //                indexNow = indexNow + 1;
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if (counter == value?.count) {
                        //                        self.refreshControl?.endRefreshing()
                    }
                    else {
                        counter = counter + 1;
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        
        ref.child("Information Tables").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            print(value)
            
            self.items[1].removeAll()
            
            var indexNow = 1;
            var counter: Int = 1;
            for item in value! {
                
                
                var date = "";
                var time = "";
                var eventOrganizer = "";
                let oppName = item.key
                //                var itemValues = ((item.value as! NSDictionary).allValues)
                //                var keys = ((item.value as! NSDictionary).allKeys)
                
                let dic = item.value as! Dictionary<String, Any>
                
                for item in dic {
                    if item.key.lowercased().range(of:"time") != nil {
                        print(item.value)
                        time = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"event organizer") != nil {
                        print(item.value)
                        
                        eventOrganizer = item.value as! String
                    }
                    else if item.key.lowercased().range(of:"date") != nil {
                        print(item.value)
                        
                        date = item.value as! String
                    }
                    
                }
                
                //                print(dic)
                
                
                let volunteerOppItem = VolunteerOpp(date: date, volunteerOpportunity: oppName as! String, location: eventOrganizer, whoWeAre: time)
                
                self.array.append(volunteerOppItem)
                print(indexNow)
                self.items[indexNow].append(volunteerOppItem)
                //                indexNow = indexNow + 1;
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if (counter == value?.count) {
                        //                        self.refreshControl?.endRefreshing()
                    }
                    else {
                        counter = counter + 1;
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }

    
    
}
    
    var x = 0
    
    func appliedTapped(cell: OppTableViewCell) {
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitle[section]

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OppTableViewCell", for: indexPath) as! OppTableViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.volunteerOpportunity.text = items[indexPath.section][indexPath.row].volunteerOpportunity
        
        cell.date.text = items[indexPath.section][indexPath.row].date
        
        cell.location.text = items[indexPath.section][indexPath.row].location
        
        if (indexPath.row == items[indexPath.section].count-1) {
            
//            print(items)
            self.refreshControl?.endRefreshing()
        }
        
        return cell
    }
}



