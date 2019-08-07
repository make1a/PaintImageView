//
//  ViewController.swift
//  PaintImageView
//
//  Created by ios on 2018/7/31.
//  Copyright © 2018年 ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var paintImageView: PaintImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  

}

extension CGFloat {
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static func ptHeight(h: CGFloat) -> CGFloat {
        return h/512.0*CGFloat.screenHeight()
    }
    
    static func ptWidth(w: CGFloat) -> CGFloat {
        return w / 683.0 * CGFloat.screenWidth()
    }
}

//extension ViewController : UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return paintImageView
//    }
//}


