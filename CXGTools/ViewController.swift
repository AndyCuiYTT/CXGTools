//
//  ViewController.swift
//  CXGTools
//
//  Created by CuiXg on 2021/8/24.
//

import UIKit

class ViewController: UIViewController {

    let vc = CXGFilePreviewViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        let v = CXGRoundedCornersView(frame: CGRect(x: 40, y: 50, width: 300, height: 533))
        v.backgroundColor = .red.withAlphaComponent(0.5)
        v.cornersRadius = CXGRoundedCornersRadius(topLeft: 10, topRight: 60, bottomLeft: 50, bottomRight: 20)
        v.borderColors = [.blue, .red, .brown, .cyan, .brown]
        v.borderWidth = 5
        v.paddingColor = UIColor.cyan.withAlphaComponent(0.8)
        v.paddingWidth = 10
        self.view.addSubview(v)





        


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.present(CXGFilePreviewViewController(), animated: true, completion: nil)
        let arr = [
            "https://img2.qiuwenxinli.com/1-2%20%E6%8B%B7%E8%B4%9D%202.png",
            "https://img2.qiuwenxinli.com/10.11.png",
            "https://img2.qiuwenxinli.com/10.15.png",
            "https://img2.qiuwenxinli.com/10.18.png",
            "https://img2.qiuwenxinli.com/06921d8a9ffdefd66be874264b19ed2.jpg",
            "https://img2.qiuwenxinli.com/1627024794154.png",
            "https://img2.qiuwenxinli.com/18-30nan-1.png"]
        vc.xfs_presentPreview(withFilesURL: arr, presentingViewController: self, animated: true)
//        self.navigationController?.pushViewController(, animated: true)
    }

    // 600 1067

}

