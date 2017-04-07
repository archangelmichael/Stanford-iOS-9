//
//  StackViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 4/7/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    @IBOutlet weak var vScroll: UIScrollView!
    let topOffset : CGFloat = 10.0
    var subviews : [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearScrollView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddBtn(_ sender: UIButton) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        btn.backgroundColor = UIColor.purple
        self.addSubview(view: btn)
    }
    
    @IBAction func onAddImg(_ sender: UIButton) {
        let image = UIImage(named: "onboarding1")
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        img.contentMode = .scaleAspectFit
        img.image = image
        self.addSubview(view: img)
    }
    
    @IBAction func onAddLbl(_ sender: UIButton) {
        let lbl = UILabel(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.vScroll.frame.size.width - 10,
                                        height: CGFloat.greatestFiniteMagnitude))
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = "asjhdkjhasd dsdsdsaga gsd asdggasd g dgghadgsd dsdgasjdg asdgahjsgd asgdkahs jhkasgd ahsgd ahjsgd ajshgd ahjsgd ajshgd agsd akgsd asgda sgdjagkegyqwkygeabds asjhkegqwg dasdqwyeg asbdahjkrgqwk gadbkgrwabdjgruweajsbdajkwe"
        lbl.sizeToFit()
        
        lbl.textColor = UIColor.red
        lbl.tintColor = UIColor.red
        self.addSubview(view: lbl)
    }
    
    func addSubview(view: UIView) {
        if self.subviews.count == 0 {
            let posY = self.topOffset
            self.setViewYPos(view: view, yPos: posY)
            self.vScroll.insertSubview(view, at: 0)
        }
        else {
            if let lastSubview = self.subviews.last {
                let posY =  lastSubview.frame.origin.y + lastSubview.frame.size.height + self.topOffset
                self.setViewYPos(view: view, yPos: posY)
                self.vScroll.insertSubview(view, belowSubview: lastSubview)
            }
            else {
                let posY = self.vScroll.contentSize.height
                self.setViewYPos(view: view, yPos: posY)
                self.vScroll.insertSubview(view, at: subviews.count)
            }
        }
        
        self.subviews.append(view)
        self.vScroll.contentSize = CGSize(width: self.vScroll.contentSize.width,
                                          height: self.vScroll.contentSize.height + view.frame.size.height + self.topOffset)
    }
    
    func setViewYPos(view: UIView, yPos: CGFloat) {
        view.frame = CGRect(x: view.frame.origin.x,
                            y: yPos,
                            width: view.frame.size.width,
                            height: view.frame.size.height)
    }
    
    @IBAction func onClear(_ sender: Any) {
        self.clearScrollView()
    }
    
    func clearScrollView() {
        for view in self.vScroll.subviews {
            view.removeFromSuperview()
        }
        
        self.subviews = []
        self.vScroll.contentSize = CGSize(width: self.vScroll.frame.size.width,
                                          height: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
