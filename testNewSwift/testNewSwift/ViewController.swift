//
//  ViewController.swift
//  testNewSwift
//
//  Created by kangxg on 2017/10/28.
//  Copyright © 2017年 zy. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {
    var lastView:KGView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lastView = KGView.init(frame: CGRect(x:100,y:100,width:100,height:100))
        self.view.addSubview(self.lastView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

