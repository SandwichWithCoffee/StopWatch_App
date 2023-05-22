//
//  ViewController.swift
//  StopWatch_App
//
//  Created by 초코크림 on 2023/05/17.
//

import UIKit

class ViewController: UIViewController {
    var lapCell: LapCell?
    var stopWatch = Stopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "StopWatch"
        self.view.backgroundColor = .systemGray6
        
        lapTableView.delegate = self
        lapTableView.dataSource = self
        lapTableView.backgroundColor = .systemGray6
        
        rightButton.setTitle(stopWatch.possibleButtonTitle(), for: .normal)
        leftButton.setTitle(stopWatch.lapResetTitle(), for: .normal)
        
        stopWatch.showElapsedTime = { time in
            self.timeLabel.text = time
        }
        
        stopWatch.showElapsedMiddleTime = { time in
            if self.lapCell?.rememberRow == 0 {
                self.lapCell?.rightLabel.text = time
            }
        }
    }
    
    @IBAction func startStopResume(_ sender: Any) {
        stopWatch.runPossibleType()
        
        rightButton.setTitle(stopWatch.possibleButtonTitle(), for: .normal)
        leftButton.setTitle(stopWatch.lapResetTitle(), for: .normal)
    }
    
    @IBAction func lapOrReset(_ sender: Any) {
        if stopWatch.runPossibleLeftType() == .reset {
            timeLabel.text = "00:00.00"
        }
        
        lapTableView.reloadData()
        leftButton.setTitle(stopWatch.lapResetTitle(), for: .normal)
        rightButton.setTitle(stopWatch.possibleButtonTitle(), for: .normal)
    }
    
    let makeCircleButton: (UIButton) -> Void = { btn in
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 50
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!{
        didSet{
            makeCircleButton(leftButton)
        }
    }
    @IBOutlet weak var rightButton: UIButton!{
        didSet{
            makeCircleButton(rightButton)
        }
    }
    @IBOutlet weak var lapTableView: UITableView!
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return stopWatch.lapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell", for: indexPath) as! LapCell
        cell.rememberRow = indexPath.row
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.lapCell = cell
            }
            
            cell.leftLabel.text = "Lap " + (stopWatch.lapList.count + 1).description
            if stopWatch.lapList.count == 0 {
                cell.rightLabel.text = "00:00.00"
            }
        }
        else if indexPath.section == 1 {
            cell.leftLabel.text = "Lap " + (stopWatch.lapList.count - indexPath.row).description
            cell.rightLabel.text = stopWatch.lapList[indexPath.row]
        }
        
        return cell
    }
}
