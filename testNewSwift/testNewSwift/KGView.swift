//
//  KGView.swift
//  testNewSwift
//
//  Created by kangxg on 2017/10/28.
//  Copyright © 2017年 zy. All rights reserved.
//

import UIKit

class KGView: UIView {
    var model:KGModelInterface = KGModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.red;
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
   /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
