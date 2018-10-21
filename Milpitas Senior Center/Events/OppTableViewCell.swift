//
//  OppTableViewCell.swift
//  highSchoolVolunteer
//
//  Created by Sahil Jain on 6/15/17.
//  Copyright © 2017 Sahil Jain. All rights reserved.
//

import UIKit
import EventKit
protocol OppTableViewCellDelegate {
    
    func appliedTapped(cell: OppTableViewCell)
}
class OppTableViewCell: UITableViewCell {

    @IBOutlet weak var volunteerOpportunity: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var applyButton: UIButton!
    
    var delegate:OppTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        applyButton.layer.cornerRadius = 5
        applyButton.layer.borderWidth = 1

    }

    @IBAction func appliedTapped(_ sender: Any) {
        delegate?.appliedTapped(cell: self)
        print("Hello World")
        
        let alert = UIAlertController(title: "Do you want to register for \(volunteerOpportunity.text!)?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, definitely.", style: .default, handler: { action in
            
            self.addEventToCalendar(title: self.volunteerOpportunity.text!, description: "No description", startDate: NSDate() as Date, endDate: NSDate() as Date)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No, not at this time", style: .cancel, handler: { action in
            print("Cancelled.!")
        }))

        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        


        
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Successful")
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // Set the width of the cell
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - 40, self.bounds.size.height)
        super.layoutSubviews()
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }


}
