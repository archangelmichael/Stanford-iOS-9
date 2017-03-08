//
//  ViewController.swift
//  CustomAlertView
//
//  Created by Radi on 3/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tvAlerts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvAlerts.delegate = self
        self.tvAlerts.dataSource = self
        self.registerAlertCell()
    }
    
    private func registerAlertCell() -> Void {
        let alertNib = UINib(nibName: AlertTableViewCell.nibNam(),
                             bundle: nil)
        self.tvAlerts.register(alertNib,
                               forCellReuseIdentifier: AlertTableViewCell.reuseId())
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlertType.AllCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reuseId(),
                                                 for: indexPath) as! AlertTableViewCell
        let type = AlertType.getType(value: indexPath.row)
        cell.lblAlert.text = "\(type)"
        
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertType = AlertType.getType(value: indexPath.row)
        self.showModalAlert(type: alertType)
        return;
    }
    
    func showModalAlert(type : AlertType) {
        let modalViewController = AlertViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        
        modalViewController.setupWith(
            title: "Alert Title",
            message: "",
            image: nil,
            loading: true,
            buttons: [
                UIButton.getButtonWith(title: "ACTION 1",
                                       index: 0,
                                       normalTextColor: UIColor.blue,
                                       highlightedTextColor: UIColor.green),
                UIButton.getButtonWith(title: "ACTION 2",
                                       index: 1,
                                       normalTextColor: UIColor.red,
                                       highlightedTextColor: UIColor.yellow)
            ],
            delegate: self
        )
        
        self.present(modalViewController,
                     animated: true,
                     completion: nil)
    }
}

extension ViewController : AlertViewDelegate {
    func didSelectAlertOption(index: Int) {
        switch index {
        case 0:
            print("ACTION 1")
            break
        case 1:
            print("ACTION 2")
            break
        default:
            break
        }
    }
}

