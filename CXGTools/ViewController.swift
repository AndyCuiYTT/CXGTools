//
//  ViewController.swift
//  CXGTools
//
//  Created by CuiXg on 2021/8/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        let v = CXGRoundedCornersView(frame: CGRect(x: 40, y: 50, width: 300, height: 500))
        v.backgroundColor = .red.withAlphaComponent(0.5)
        v.cornersRadius = CXGRoundedCornersRadius(topLeft: 10, topRight: 60, bottomLeft: 50, bottomRight: 20)
        v.borderColors = [.blue, .red, .brown, .cyan, .brown]
        v.borderWidth = 5
        self.view.addSubview(v)
    }


}

