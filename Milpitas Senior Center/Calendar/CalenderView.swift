//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import EventKit

struct schedule {
    static var Monday = [String: String]();
    static var Tuesday = [String: String]();
    static var Wednesday = [String: String]();
    static var Thursday = [String: String]();
    static var Friday = [String: String]();
    static var Saturday = [String: String]();
    static var Sunday = [String: String]();

    static var satisfied = false;
}
struct Colors {
    static var darkGray = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1.0)

    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
            }
        }
        return cell
    }
    
    func referenceFunction() {
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://milpitas-senior-center.firebaseio.com/")
        
        ref.child("Classes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String, Dictionary<String, Any>>
            
            for item in value! {
                //            print(item)
                let day = item.key
                let dic = item.value as! Dictionary<String, Any>
                
                for item2 in dic {
                    if (day == "Monday") {
                        schedule.Monday.updateValue(item2.key, forKey: item2.value as! String)
                    }
                    else if (day == "Tuesday") {
                        schedule.Tuesday.updateValue(item2.key, forKey: item2.value as! String)

                    }
                    else if (day == "Wednesday") {
                        schedule.Wednesday.updateValue(item2.key, forKey: item2.value as! String)

                    }
                    else if (day == "Thursday") {
                        schedule.Thursday.updateValue(item2.key, forKey: item2.value as! String)

                    }
                    else if (day == "Friday") {
                        schedule.Friday.updateValue(item2.key, forKey: item2.value as! String)
                    }
                }
                
                print("Was here")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        schedule.satisfied = true;
        
            schedule.Saturday.updateValue("Sorry we're closed!", forKey: "" as! String)
    
    
            schedule.Sunday.updateValue("Sorry we're closed!", forKey: "" as! String)
            
        

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
        var currDay = lbl.text
        
        let currDay2 = Int(currDay!)
        let dayofweek = (((currDay2! - firstWeekDayOfMonth) % 7) + firstWeekDayOfMonth) % 7
        print(dayofweek)
        
        var daysArr = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        let screenSize: CGRect = UIScreen.main.bounds

        print(screenSize.height)
        print(screenSize.width)
        print(screenSize.size)
        print(screenSize.maxX)
        print(screenSize.minX)
        
        if (schedule.Thursday.count > 0) {
            
        }
        else {
            referenceFunction()
        }
        
        
        let myView = UIView(frame: CGRect(x: 5, y: screenSize.height/2, width: screenSize.width - 30, height: screenSize.height/4))
        myView.layer.cornerRadius = 15;
        myView.layer.masksToBounds = true;
        

        print(myView.bounds)
        

        let label = UILabel(frame: CGRect(x: screenSize.width/2, y: screenSize.height/(1.5), width: 200, height: 250))
        label.center = CGPoint(x: (screenSize.width-30)/2, y: screenSize.height/32)
        label.textAlignment = .center
        label.text = "Classes for \(daysArr[dayofweek])"
        label.textColor = UIColor.white
        
        let day = daysArr[dayofweek]
        
        if (day == "Monday") {
            let num = schedule.Monday.count
            for d in 1...num {
                
                let screenSize2 = myView.bounds;

                let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                let j = Int(d)
                label2.center = CGPoint(x: screenSize2.width/2 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label2.textAlignment = .left
                label2.text = Array(schedule.Monday)[d-1].value
                label2.textColor = UIColor.white
                myView.addSubview(label2)
                
                let label3 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.75, height: screenSize.height))
                label3.center = CGPoint(x: screenSize2.width/1.75 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label3.textAlignment = .right
                label3.text = Array(schedule.Monday)[d-1].key
                label3.textColor = UIColor.white
                myView.addSubview(label3)


            }

        }
        else if (day == "Tuesday") {
            let num = schedule.Tuesday.count
            for d in 1...num {
                
                let screenSize2 = myView.bounds;
                
                let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                let j = Int(d)
                label2.center = CGPoint(x: screenSize2.width/2 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label2.textAlignment = .left
                label2.text = Array(schedule.Tuesday)[d-1].value
                label2.textColor = UIColor.white
                myView.addSubview(label2)
                
                let label3 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.75, height: screenSize.height))
                label3.center = CGPoint(x: screenSize2.width/1.75 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label3.textAlignment = .right
                label3.text = Array(schedule.Tuesday)[d-1].key
                label3.textColor = UIColor.white
                myView.addSubview(label3)
                
                
            }


        }
        else if (day == "Wednesday") {
            let num = schedule.Wednesday.count
            for d in 1...num {
                
                let screenSize2 = myView.bounds;
                
                let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                let j = Int(d)
                label2.center = CGPoint(x: screenSize2.width/2 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label2.textAlignment = .left
                label2.text = Array(schedule.Wednesday)[d-1].value
                label2.textColor = UIColor.white
                myView.addSubview(label2)
                
                let label3 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.75, height: screenSize.height))
                label3.center = CGPoint(x: screenSize2.width/1.75 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label3.textAlignment = .right
                label3.text = Array(schedule.Wednesday)[d-1].key
                label3.textColor = UIColor.white
                myView.addSubview(label3)
                
                
            }


        }
        else if (day == "Thursday") {
            let num = schedule.Thursday.count
            for d in 1...num {
                
                let screenSize2 = myView.bounds;
                
                let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                let j = Int(d)
                label2.center = CGPoint(x: screenSize2.width/2 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label2.textAlignment = .left
                label2.text = Array(schedule.Thursday)[d-1].value
                label2.textColor = UIColor.white
                myView.addSubview(label2)
                
                let label3 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.75, height: screenSize.height))
                label3.center = CGPoint(x: screenSize2.width/1.75 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label3.textAlignment = .right
                label3.text = Array(schedule.Thursday)[d-1].key
                label3.textColor = UIColor.white
                myView.addSubview(label3)
                
                
            }


        }
        else if (day == "Friday") {
            let num = schedule.Friday.count
            for d in 1...num {
                
                let screenSize2 = myView.bounds;
                
                let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                let j = Int(d)
                label2.center = CGPoint(x: screenSize2.width/2 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label2.textAlignment = .left
                label2.text = Array(schedule.Friday)[d-1].value
                label2.textColor = UIColor.white
                myView.addSubview(label2)
                
                let label3 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.75, height: screenSize.height))
                label3.center = CGPoint(x: screenSize2.width/1.75 + 5, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                label3.textAlignment = .right
                label3.text = Array(schedule.Friday)[d-1].key
                label3.textColor = UIColor.white
                myView.addSubview(label3)
                
                
            }
        }
            else if (day == "Saturday") {
                let num = schedule.Saturday.count
                for d in 1...num {
                    
                    let screenSize2 = myView.bounds;
                    
                    let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                    let j = Int(d)
                    label2.center = CGPoint(x: screenSize2.width/2, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                    label2.textAlignment = .center
                    label2.text = Array(schedule.Saturday)[d-1].value
                    label2.textColor = UIColor.white
                    myView.addSubview(label2)
                    
                    
            }
            }
            else if (day == "Sunday") {
                let num = schedule.Sunday.count
                for d in 1...num {
                    
                    let screenSize2 = myView.bounds;
                    
                    let label2 = UILabel(frame: CGRect(x: screenSize.width, y: screenSize.height, width: screenSize.width/1.25, height: screenSize.height))
                    let j = Int(d)
                    label2.center = CGPoint(x: screenSize2.width/2, y: CGFloat(d+1) * (screenSize2.height/(CGFloat(num+1) + 1.0)))
                    label2.textAlignment = .center
                    label2.text = Array(schedule.Sunday)[d-1].value
                    label2.textColor = UIColor.white
                    myView.addSubview(label2)
                    
                    

            }
            }

    
        

        

        
        myView.backgroundColor = UIColor.lightGray
        myView.addSubview(label)

        addSubview(myView)
        
        
        
        
//
//        let horizontalConstraint = NSLayoutConstraint(item: myView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//
//        myView.addConstraint(horizontalConstraint)
        print(daysArr[dayofweek])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    

    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        myCollectionView.reloadData()
        
        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    

    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}













