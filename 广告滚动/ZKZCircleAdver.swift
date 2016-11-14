//
//  ZKZCircleAdver.swift
//  广告滚动
//
//  Created by 张凯泽 on 16/11/9.
//  Copyright © 2016年 rytong_zkz. All rights reserved.
//
 protocol ZKZCircleDelegate :NSObjectProtocol
{
    func didClickBannerIndex(index: Int)
}
enum PageControlPositon
{
    case none,left,center,right
}
import Foundation
import UIKit

class ZKZCircle: UIView {
   weak var CircleDelegate : ZKZCircleDelegate?
    var placeHolderImage : UIImage?
    /// 定时器
    fileprivate var timer: Timer?
    /// 滚动时间间隔
    var timeSeconds: TimeInterval {
        set{
            print("设置时间")
            addTimer()
            
        }
        get{
            return 3
        }
    }
    
    //懒加载scrollview 
  fileprivate  lazy var scrollView : UIScrollView? = {
        let scrollview = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        //创建scrollview
        scrollview.delegate = self
        scrollview.decelerationRate = 0.5
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
    //设置contentsize
        scrollview.contentSize = CGSize.init(width: self.frame.size.width * (CGFloat)(3 + 0), height: self.frame.size.height)
        return scrollview
    }()
    //宽度
    fileprivate var Width : CGFloat = 0.0
    //高度
    fileprivate var Height : CGFloat = 0.0
    //懒加载pagecontrol
   fileprivate lazy var pageControl : UIPageControl? = {
     let pagecontrol = UIPageControl.init()
        pagecontrol.pageIndicatorTintColor = UIColor .blue
        pagecontrol.currentPageIndicatorTintColor = UIColor.red
        return pagecontrol
        
    }()
    
    var imageGroup : Array<String>?
    {
        didSet{
            SetScrollViewAndPageControl()
            if imageGroup == nil {
                scrollView!.removeFromSuperview()
                pageControl!.removeFromSuperview()
            }
            
        }
    }
    //创建存储所以UIImageView数组
   fileprivate var imageViews : Array<UIImageView> = [UIImageView]()
    //创建当前的index
   fileprivate var currentIndex : Int = 0
    //创建UIImageView 只存储3张
   fileprivate var currenArray : Array<UIImageView> = [UIImageView]()
    var posion : PageControlPositon = PageControlPositon.center
        {
        willSet{
            print(newValue)
            
        }
        didSet{
            print("设置pagecontrol")
            switch posion {
            case .none:
                pageControl!.removeFromSuperview()
                break
            case .left:
                pageControl!.frame = CGRect.init(x: 0, y: Height-40, width: 100, height: 40)
                break
            case .center:
                //什么也不做
                break
            default://右边
                pageControl!.frame = CGRect.init(x: Width-100, y: Height-40, width: 100, height: 40)
                break
            }
        }
    }
   
    fileprivate var imageView : UIImageView?
    {
        didSet{
            //设置iamgeview可以进行交户
            imageView?.isUserInteractionEnabled = true
            //增加点击方法
            let tapGes : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tap))
            imageView!.addGestureRecognizer(tapGes)
         }
    }
    @objc fileprivate func tap()
    {
        CircleDelegate?.didClickBannerIndex(index: pageControl!.currentPage)
        
//        print("点击事件----\(pageControl!.currentPage)")
    }
    //创建定时器
    override init(frame: CGRect) {
        super.init(frame: frame)
        Width = frame.size.width
        Height = frame.size.height
        
        self.addSubview(scrollView!)
        //根据枚举值判断 默认是在中心位置
        switch posion {
        case .none:
            //不创建pagecontrol
            break
            
        default:
            pageControl?.frame = CGRect.init(x: (Width-100)/2, y: Height-40, width: 100, height: 40)
            self.addSubview(pageControl!)
            break
        }
        //timeSeconds = 3
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ZKZCircle{
   fileprivate func SetScrollViewAndPageControl()
    {
        
        pageControl!.numberOfPages = imageGroup!.count
        let count = imageGroup!.count
        for  c in 0..<count  {
            imageView = UIImageView.init(frame: CGRect.init(x: CGFloat(0 + c) * (self.frame.size.width), y: 0.0, width: Width, height: Height))
            imageView?.kf.setImage(with: URL.init(string: imageGroup![c]), placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: nil)
            //images.append(imageView!.image!)
            imageViews.append(imageView!)
        }
        
        configureContentView()
        
    }
    fileprivate func configureContentView()
    {
        for view in scrollView!.subviews {
            view.removeFromSuperview()
        }
        let prepageindex : Int = getValidNextPageIndexWithPageIndex(currentpageindex: currentIndex - 1 )
        let rearpageindex : Int = getValidNextPageIndexWithPageIndex(currentpageindex: currentIndex + 1)
            currenArray.removeAll()
        if imageViews.count >= 3 {
            currenArray.append(imageViews[prepageindex])
            currenArray.append(imageViews[currentIndex])
            currenArray.append(imageViews[rearpageindex])
        }else{//图片小于3张
            //print("图片小于三张")
            getImageFromArray(imageViewUrl: imageGroup![prepageindex])
            getImageFromArray(imageViewUrl: imageGroup![currentIndex])
            getImageFromArray(imageViewUrl: imageGroup![rearpageindex])
            
        }
        for i in 0..<3 {
            currenArray[i].isUserInteractionEnabled = true
            var rect = scrollView!.frame
            rect.origin = CGPoint.init(x: (Int)(Width) * i, y: 0)
            currenArray[i].frame = rect
            scrollView!.addSubview(currenArray[i])
        }
        scrollView!.contentOffset = CGPoint.init(x: Width, y: 0)
        
    }
    
    fileprivate func getValidNextPageIndexWithPageIndex(currentpageindex : Int) ->Int
    {
        if currentpageindex == -1 {
            return imageViews.count - 1
        }else if currentpageindex == imageViews.count{
            return 0
        }else{
            return currentpageindex
        }
    }
    //解决图片3张图片的方法
    fileprivate func getImageFromArray(imageViewUrl : String)
    {
        //print(imageViewUrl)
        let tempImageView  = UIImageView.init(frame: self.frame)
        tempImageView.isUserInteractionEnabled = true
        let tapGes : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        tempImageView.addGestureRecognizer(tapGes)
        tempImageView.kf.setImage(with: URL.init(string: imageViewUrl))
        currenArray.append(tempImageView)
    }
    /// 定时器执行的方法
    @objc fileprivate func nextPage() {
        if self.superview == nil {
            removeTimer()
        } else {
            let point : CGPoint = CGPoint.init(x: scrollView!.contentOffset.x + Width, y: scrollView!.contentOffset.y)
            scrollView!.contentOffset = point
        }
    }
    /// 移除定时器
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    /// 添加定时器
    fileprivate func addTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: timeSeconds, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
}

extension ZKZCircle:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard imageGroup?.count != nil else {
            return
        }
        let contentOffSetX = scrollView.contentOffset.x
        if contentOffSetX >= 2 * Width {
          self.currentIndex = getValidNextPageIndexWithPageIndex(currentpageindex: currentIndex+1)
            pageControl?.currentPage = currentIndex
            configureContentView()
        }
        if contentOffSetX <= 0 {
            self.currentIndex = getValidNextPageIndexWithPageIndex(currentpageindex: currentIndex - 1)
            pageControl?.currentPage = currentIndex
            configureContentView()
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollView.setContentOffset(CGPoint.init(x: Width, y: 0), animated: true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

}



