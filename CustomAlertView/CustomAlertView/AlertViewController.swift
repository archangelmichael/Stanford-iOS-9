//
//  AlertViewController.swift
//  CustomAlertView
//
//  Created by Radi on 3/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

enum AlertType : Int {
    case Default = 0, Image, Loading, AllCount
    
    static func getType(value: Int) -> AlertType {
        var type = value
        if type < 0 || type > AlertType.AllCount.rawValue {
            type = 0
        }
        
        return AlertType.init(rawValue: type)!
    }
}


protocol AlertViewDelegate {
    // Execute action completion event
    func didSelectAlertOption(index: Int) -> Void
}

class AlertViewController: UIViewController {
    
    @IBOutlet weak var vBlur: UIVisualEffectView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var cstrTVWidth: NSLayoutConstraint!
    @IBOutlet weak var cstrTVHeight: NSLayoutConstraint!
    
    fileprivate var rowViews : [UIView] = []
    fileprivate var delegate : AlertViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvContent.separatorStyle = .none
        self.tvContent.dataSource = self
        self.tvContent.delegate = self
        
        self.tvContent.layer.cornerRadius = 8
        self.tvContent.clipsToBounds = true
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    func setupWith(title: String?,
                   message: String?,
                   image: UIImage?,
                   loading: Bool,
                   buttons: [UIButton],
                   delegate: AlertViewDelegate?) -> Void {
        
        self.delegate = delegate
        
        self.getLabelForString(input: title)
        self.getLabelForString(input: message)
        
        if loading {
            self.addActivityIndicator()
        }
        
        self.getImageFor(image: image)
        
        for button in buttons {
            self.getButtonFor(button: button)
        }
        
        self.view.alpha = 0.0
        
        self.tvContent?.dataSource = self
        self.tvContent?.delegate = self
        
        self.tvContent?.rowHeight = UITableViewAutomaticDimension
        self.tvContent?.estimatedRowHeight = 20.0
    }
    
    func getLabelForString(input: String?) -> Void {
        if input != nil {
            let trimmedTitle = input!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedTitle != "" {
                let lbl = UILabel()
                lbl.font = UIFont.systemFont(ofSize: 18.0)
                lbl.text = trimmedTitle
                lbl.sizeToFit()
                lbl.textAlignment = .center
                lbl.numberOfLines = 0
                self.rowViews.append(lbl)
            }
        }
    }
    
    func addActivityIndicator() -> Void {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.color = UIColor.red
        activity.startAnimating()
        self.rowViews.append(activity)
    }
    
    func getImageFor(image: UIImage?) -> Void {
        if image != nil {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            self.rowViews.append(imageView)
        }
    }
    
    func getButtonFor(button: UIButton) -> Void {
        button.sizeToFit()
        button.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
        self.rowViews.append(button)
    }
    
    
    func dismiss(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
        
        if let delegator = self.delegate {
            delegator.didSelectAlertOption(index: sender.tag)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.view.alpha = 1.0
        })
    }
    
    
    fileprivate func getViewForRow(row: Int) -> UIView {
        if row < 0 || row >= self.rowViews.count {
            return UIView()
        }
        else {
            return self.rowViews[row]
        }
    }
    
}

extension AlertViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        
        let view = self.getViewForRow(row: indexPath.row)
        cell.addSubview(view)
        view.bindFrameToSuperviewBounds()
        
        
        return cell
    }
}

extension AlertViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
