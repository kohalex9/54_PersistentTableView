//
//  ViewController.swift
//  54_TableViewPersistent
//
//  Created by Alex Koh on 25/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var footBallTeams: [FootballTeam] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //update the array of footBallTeams in order to prevent duplicate copy of footballTeams
        loadData()
        
        //Attempts to read data from plist and store them in core data
        if let itemsFromPlist = readItemsFromPlist(fileName: "football_teams") {
            writeDataToCoreDatafrom(arrayOf: itemsFromPlist, when: checkIfCoreDataIsEmpty())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Displays the data on the tableView
        loadData()
    }
    
    
    @IBAction func editBtnTapped(_ sender: Any) {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Filter", message: "Filter by Founded Year before 1900", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Filter Now!", style: .default) { (action) in
            let request = NSFetchRequest<FootballTeam>(entityName: "FootballTeam")
            let predicate = NSPredicate(format: "(yearFounded < 1900)")
            request.predicate = predicate
            do {
                let data = try DataController.moc.fetch(request)
                self.footBallTeams = data
                self.tableView.reloadData()
            } catch {}
        }
        
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func addBtnTapped(_ sender: Any) {
        
        //Create a new coreData object
        guard let desc = NSEntityDescription.entity(forEntityName: "FootballTeam", in: DataController.moc) else {
            print("eRROr")
            return}
        let newTeam = FootballTeam(entity: desc, insertInto: DataController.moc)
        
        //go to AddNewDetailVC
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "AddNewDetailsViewController") as? AddNewDetailsViewController else {return}
        
        destination.isCurrentTeamTapped = false
        destination.footBall = newTeam
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func loadData() {
        let request = NSFetchRequest<FootballTeam>(entityName: "FootballTeam")
        
        //Sort by teamName from A-Z
        let teamAlphabetSort = NSSortDescriptor(key: "team", ascending: true)
        request.sortDescriptors = [teamAlphabetSort]
        
        do {
            let data = try DataController.moc.fetch(request)
            
            footBallTeams = data
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func readItemsFromPlist(fileName: String) -> [[String:String]]? {
        guard let filePath = Bundle.main.path(forResource: "\(fileName)", ofType: "plist") else {
            print("File not found")
            return nil
        }
        
        guard let itemsFromPlist = NSArray(contentsOfFile: filePath) else {
            print("Error when reading an array of items from the file")
            return nil
        }
        
        guard let itemsFromPlistInStringStringFormat = itemsFromPlist as? [[String:String]] else {
            print("cannot cast to the [[String:Stirng]] format")
            return nil
        }
        return itemsFromPlistInStringStringFormat
    }

    func writeDataToCoreDatafrom(arrayOf items: [[String:String]], when CoreDataIsEmpty: Bool) {
        if CoreDataIsEmpty {
            for item in items {
                guard let desc = NSEntityDescription.entity(forEntityName: "FootballTeam", in: DataController.moc) else {
                    print("eRROr")
                    return}
                let newTeam = FootballTeam(entity: desc, insertInto: DataController.moc)
                newTeam.team = item["team"]
                newTeam.manager = item["manager"]
                newTeam.logoImageName = item["logoImage"]
            }

        } else {
            //Do nothing
        }
    }
    
    func checkIfCoreDataIsEmpty() -> Bool {
        
        if footBallTeams.count == 0 {
            return true
        } else {
            return false
        }
        
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return footBallTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FootballTeamTableViewCell else {
            return UITableViewCell()
        }
        
        //Show the current info on the labels in VC
       let selectedTeam = footBallTeams[indexPath.row]
        //The following methods produce unknown bugs - no data updated after return from AddNewDetailsVC, but only updated after the app is restarted.
//        guard let team = selectedTeam.team else {return UITableViewCell()}
//        cell.teamLabel.text = "Team:" + team
//        guard let manager = selectedTeam.manager else {return UITableViewCell()}
//        cell.managerLabel.text = "Manager: " + manager
//        guard let homeStadium = selectedTeam.homeStadium else {return UITableViewCell()}
//        cell.homeStadiumLabel.text = "Home: " + homeStadium
//        cell.yearFoundedLabel.text = "Year: \(selectedTeam.yearFounded)"
//        guard let goalKeeper = selectedTeam.goalKeeper else {return UITableViewCell()}
//        cell.goalKeeperLabel.text = "GoalKeeper: \(goalKeeper)"
//        guard let league = selectedTeam.primaryLeague else {return UITableViewCell()}
//        cell.leagueLabel.text = "League: \(league)"
        
        //This methods works to put values on each respective labels
        if let team = selectedTeam.team {
            cell.teamLabel.text = "Team: \(team)"
        }
        if let manager = selectedTeam.manager {
            cell.managerLabel.text = "Manager: \(manager)"
        }
        if let home = selectedTeam.homeStadium {
            cell.homeStadiumLabel.text = "Home: \(home)"
        }
        cell.yearFoundedLabel.text = "Year: \(selectedTeam.yearFounded)"
        if let goalKeeper = selectedTeam.goalKeeper {
            cell.goalKeeperLabel.text = "GoalKeeper: \(goalKeeper)"
        }
        if let league = selectedTeam.primaryLeague {
            cell.leagueLabel.text = "League: \(league)"
        }
        if let logoImage = selectedTeam.logoImageName {
            cell.teamLogo.image = UIImage(named: "\(logoImage)")
        } else {
            cell.teamLogo.image = UIImage(named: "football")
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTeam = footBallTeams[indexPath.row]
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "AddNewDetailsViewController") as? AddNewDetailsViewController else {return}
        navigationController?.pushViewController(destination, animated: true)
        
        destination.footBall = selectedTeam //pass currently selected football object to AddNewDetailsVC
        destination.isCurrentTeamTapped = true
    }
    
     // The following two functions enable us to delete the footballteam by swiping right
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedFootballTeam = footBallTeams[indexPath.row]
            
            footBallTeams.remove(at: indexPath.row)
            DataController.moc.delete(selectedFootballTeam)
            
            DataController.saveContext()
            tableView.reloadData()
        }
    }
}





















