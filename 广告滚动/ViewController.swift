//
//  ViewController.swift
//  广告滚动
//
//  Created by 张凯泽 on 16/11/9.
//  Copyright © 2016年 rytong_zkz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZKZCircleDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let circleView : ZKZCircle = ZKZCircle.init(frame: CGRect.init(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3))
       // circleView.backgroundColor = UIColor.red
        self.view.addSubview(circleView)
        //设置pagecontrol的位置
        circleView.posion = PageControlPositon.center
        circleView.CircleDelegate = self
        //设置图片数组
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            circleView.imageGroup = ["https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=af9259bf03082838770ddb148898a964/6159252dd42a2834bc76c4ab5fb5c9ea14cebfba.jpg","https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=269538a28344ebf87271633fe9f8d736/2e2eb9389b504fc29897b1a4e1dde71191ef6d42.jpg"]
            //,"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=269538a28344ebf87271633fe9f8d736/2e2eb9389b504fc29897b1a4e1dde71191ef6d42.jpg","https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=1e8feb8facd3fd1f2909a53a004f25ce/c995d143ad4bd113eff4cf935eafa40f4bfb0551.jpg","https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=7079be42532c11dfc1d1b82353266255/342ac65c10385343e952fe809713b07ecb8088f5.jpg"
        })
        circleView.timeSeconds = 3

        
    }
    
    func didClickBannerIndex(index: Int) {
        
        print(index)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

