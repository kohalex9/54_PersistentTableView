//
//  AddNewDetailsViewController.swift
//  54_TableViewPersistent
//
//  Created by Alex Koh on 25/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit
import CoreData

class AddNewDetailsViewController: UIViewController {
    
    let request = NSFetchRequest<FootballTeam>(entityName: "FootballTeam")
    var index: Int?
    var footBall: FootballTeam?
    var isCurrentTeamTapped: Bool?
    
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var managerTextField: UITextField!
    @IBOutlet weak var goalKeeperTextField: UITextField!
    @IBOutlet weak var homeStadiumTextField: UITextField!
    @IBOutlet weak var primaryLeagueTextField: UITextField!
    @IBOutlet weak var yearFounderTextField: UITextField!
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        //Extract data from textField, provided textField is not empty
        guard let team = teamTextField.text, team != ""  else {return}
        guard let manager = managerTextField.text, manager != "" else {return}
        guard let goalKeeper = goalKeeperTextField.text, goalKeeper != "" else {return}
        guard let homeStadium = homeStadiumTextField.text, homeStadium != "" else {return}
        guard let primaryLeague = primaryLeagueTextField.text, primaryLeague != "" else {return}
        guard let yearFounder = yearFounderTextField.text, yearFounder != "" else {return}
        
        //To prevent user from entering alphabets which expects Integer value
        guard let yearInInt16 = Int16(yearFounder) else {return}
    
        guard let isCurrentTeamTapped = isCurrentTeamTapped else {return}
        
        footBall?.team = team
        footBall?.manager = manager
        footBall?.goalKeeper = goalKeeper
        footBall?.homeStadium = homeStadium
        footBall?.primaryLeague = primaryLeague
        footBall?.yearFounded = yearInInt16
        
        DataController.saveContext()
        goBackPreviousVC()
    }
    
    func goBackPreviousVC() {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        
        isCurrentTeamTapped = false
        navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        
        
        fillUpAllTextFieldWithPreviousData()
    }
    
    
    func fillUpAllTextFieldWithPreviousData() {
        
        teamTextField.text = footBall?.team
        managerTextField.text = footBall?.manager
        goalKeeperTextField.text = footBall?.goalKeeper
        homeStadiumTextField.text = footBall?.homeStadium
        primaryLeagueTextField.text = footBall?.primaryLeague
        if let year = footBall?.yearFounded {
            yearFounderTextField.text = "\(year)"
        }
        
    }
}






















