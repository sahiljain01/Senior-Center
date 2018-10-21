//
//  VolunteerOpp.swift
//  highSchoolVolunteer
//
//  Created by Sahil Jain on 6/15/17.
//  Copyright © 2017 Sahil Jain. All rights reserved.
//

import Foundation
import Firebase


class VolunteerOpp {
    
//    private var ref: FIRDatabase!
//    private var index: Int
    
     var volunteerOpportunity: String!
    
     var date: String!
    
     var location: String!
    
    var whoWeAre: String!
    

    init(date: String, volunteerOpportunity: String, location: String, whoWeAre:String) {

        self.date = date
        self.volunteerOpportunity = volunteerOpportunity
        self.location = location
        self.whoWeAre = whoWeAre
        
    }
    
    
    
    
    
    
}
