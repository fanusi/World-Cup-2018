//
//  ViewController3.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit
import CoreXLSX

class ViewController3: UIViewController {

    let size1:Int = 15
    // Size of each subview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let bar1 = UIView()
        bar1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * b1)
        bar1.backgroundColor = .systemGray5
        view.addSubview(bar1)
        
        let mainview = UIView()
        mainview.frame = CGRect(x: 0, y: view.frame.height * b1, width: view.frame.width, height: view.frame.height * (1-b1))
        view.addSubview(mainview)
        
        let sview = UIScrollView()
        sview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        sview.showsVerticalScrollIndicator = false
        sview.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(sview)
        sview.edgeTo(view: mainview)
        
        playedgames(uview: sview)

    }
    
    func playedgames(uview: UIScrollView) {
        
            if PronosA.count > 0 {
            
            
                let br: CGFloat = uview.bounds.width
                let ho: CGFloat = uview.bounds.height
                
                var array = [UIView]()
                array.removeAll()
                
                let n = PronosA.count
                
                for _ in 0 ..< n {
                    array.append(UIView())
                }
                
                for i in 0...n-1 {
                    
                    createviews(index1: i, actualview: array[i], superviewer: uview, numberviews: n)
                
                }
                
                uview.contentSize = CGSize(width: br, height: CGFloat(n + 10) * ho / CGFloat(size1))
            
            } else {
                
                let br = view.bounds.width
                let ho = view.bounds.height
                let label1 = UILabel(frame: CGRect(x: br * 0.40, y: ho * 0.35, width: br * 0.40, height: ho * 0.25))
                label1.textAlignment = NSTextAlignment.left
                label1.font.withSize(18)
                label1.text = "Fetching..."
                label1.textColor = .black
                view.addSubview(label1)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                    self.view.subviews.forEach { (item) in
                    item.removeFromSuperview()
                    }
                    self.playedgames(uview: uview)
                
                }
                
            }
        
        }
        
        func createviews (index1: Int, actualview: UIView, superviewer: UIScrollView, numberviews: Int) {
                
                superviewer.addSubview(actualview)
            actualview.frame = CGRect(x: 0, y: 0.05 + view.bounds.height / CGFloat(size1) * CGFloat(index1), width: superviewer.bounds.width, height: view.bounds.height / CGFloat(size1))
                actualview.backgroundColor = .white
                
                createlabels(type: 1, superviewer: actualview, teller: index1)
                createlabels(type: 2, superviewer: actualview, teller: index1)
                
            }

        
        func createlabels (type: Int, superviewer: UIView, teller: Int) {
            
            let x0 = superviewer.bounds.width
            let y0 = superviewer.bounds.height
            
            var x1:CGFloat = 0
            let y1 = y0 * 0
            let h1 = y0
            var w1:CGFloat = 0
            
            
            let temp1:String = PronosA[teller].home_Team! + " - " + PronosA[teller].away_Team!
            let temp2:String = PronosA[teller].fulltime!
            var temp3:String = ""
            
            
            if type == 1 {
            
                x1 = 0.05 * x0
                w1 = 0.75 * x0
                
                temp3 = temp1
                
            }
            
            if type == 2 {
            
                x1 = 0.85 * x0
                w1 = 0.10 * x0
                temp3 = temp2
                
            }
            
                
            let label = UILabel(frame: CGRect(x: x1, y: y1, width: w1, height: h1))
            label.textAlignment = NSTextAlignment.center
            label.text = temp3
            label.font.withSize(6)
            if type == 1 {
                label.textAlignment = NSTextAlignment.left}
            superviewer.addSubview(label)

            
        }
        
    
}
    

