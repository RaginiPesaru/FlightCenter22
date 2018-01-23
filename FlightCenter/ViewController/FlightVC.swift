//
//  ViewController.swift
//  FlightCenter
//
//  Created by Ragini pasaru on 17/01/18.
// vvvv

import UIKit

class FlightHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var lblLeftTitle: UILabel!
    @IBOutlet weak var lblRightTitle: UILabel!
    @IBOutlet weak var mainView : UIView!
}

class FlightDetailsCell: UITableViewCell {
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblDepTime: UILabel!
    
    @IBOutlet weak var lblArrivalCity: UILabel!
    @IBOutlet weak var lblDepCity: UILabel!
    @IBOutlet weak var lblDepDuration: UILabel!
    @IBOutlet weak var lblFlightDetails: UILabel!
}

class FlightVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var arrayFlightDetails : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callWebServiceForFlightDetails()
        self.tableView.register(UINib(nibName: "FlightHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FlightHeaderView")
        
        self.tableView!.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrayFlightDetails.count > 0 {
            return arrayFlightDetails.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return 1 //arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "FlightHeaderView")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: FlightHeaderView = view as! FlightHeaderView
        let flightData = self.arrayFlightDetails[section] as! NSDictionary
        
        let flightDate = flightData["arrival_date"] as? String
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = format.date(from: flightDate!)
        format.dateFormat = "d MMM"
        let dateString = format.string(from: date!)
        header.lblRightTitle.text = dateString
        
        let arrivalAirport = flightData["arrival_airport"] as? String
        let departureAirport = flightData["departure_airport"] as? String
        
        header.lblLeftTitle.text = "\(arrivalAirport!) - \(departureAirport!)"
        
        header.tag = section
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(FlightVC.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FlightDetailsCell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsCell", for: indexPath) as! FlightDetailsCell
        let flightData = self.arrayFlightDetails[indexPath.section] as! NSDictionary
        
        let arrivalCity = flightData["arrival_city"] as? String
        cell.lblArrivalCity.text = arrivalCity!
        
        let departureCity = flightData["departure_city"] as? String
        cell.lblDepCity.text = departureCity!
        
        let arrivalDate = flightData["arrival_date"] as? String
        let departureDate = flightData["departure_date"] as? String
        
        let airlineCode = flightData["airline_code"] as? String
        let flightNumber = flightData["flight_number"] as? String
        
        cell.lblFlightDetails.text = "Flight # \(airlineCode!) \(flightNumber!)"
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let aDate = format.date(from: arrivalDate!)
        let dDate = format.date(from: departureDate!)
        format.dateFormat = "h:mm a"
        
        let difference = aDate?.timeIntervalSince(dDate!)
        let hours = Int(difference!) / 3600
        let minutes = (Int(difference!) / 60) % 60
        
        cell.lblDepDuration.text = "Trip duration: \(hours)h \(minutes)min"
        
        let arrivalTimeString = format.string(from: aDate!)
        let departureTimeString = format.string(from: dDate!)
        
        cell.lblArrivalTime.text = arrivalTimeString
        cell.lblDepTime.text = departureTimeString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section)
            } else {
                tableViewCollapeSection(self.expandedSectionHeaderNumber)
                tableViewExpandSection(section)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int) {
        self.expandedSectionHeaderNumber = -1;
        var indexesPath = [IndexPath]()
        let index = IndexPath(row: 0, section: section)
        indexesPath.append(index)
        self.tableView!.beginUpdates()
        self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.none)
        self.tableView!.endUpdates()
    }
    
    func tableViewExpandSection(_ section: Int) {
        var indexesPath = [IndexPath]()
        let index = IndexPath(row: 0, section: section)
        indexesPath.append(index)
        self.expandedSectionHeaderNumber = section
        self.tableView!.beginUpdates()
        self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.tableView!.endUpdates()
    }
    
}

extension FlightVC {
    func callWebServiceForFlightDetails() {
        WebServiceCalls.callWebservice(apiPath: "", method: .get, header: [:], params: [:]) { (error, response) in            
            if let responseArray = response as? NSArray {
                self.arrayFlightDetails = responseArray as! [Any]
                self.tableView.reloadData()
            }
        }
    }
}

