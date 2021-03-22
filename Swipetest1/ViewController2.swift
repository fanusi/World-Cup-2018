//
//  ViewController2.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit

class ViewController2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        var fg:Int = 0
        
        if PronosA.count > 0 {
        
            for n in 0...PronosA.count-1 {
                
                var dummy:Int = 0
                    
                if PronosA[n].status == "Match Finished" && dummy == 0 {
                    fg = fg + 1
                } else if PronosA[n].status == "First Half" || PronosA[n].status == "Second Half" {
                    fg = n
                    dummy = 1
                }
                
            }
        } else {
            
            fg = -1
            
        }
        
        print("fg = " + String(fg))
        
        self.pickerView.selectRow(fg + 1, inComponent: 0, animated: false)
        self.pickerView(pickerView, didSelectRow: fg + 1, inComponent: 0)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                
        var teller:Int = 1
        
        if PronosB.count > 0 {
        
            teller = PronosB.count
        
        }
        
        return teller
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                
        var game: String = "No data"
        
        if PronosB.count > 0 {
            
            if row == 0 {
                
                game = "Select game"
                
            } else {
                
                game = PronosB[0][row-1].home_Team! + " - " + PronosB[0][row-1].away_Team!
                
            }
    
        }
        
        return game
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            
            View1.subviews.forEach { (item) in
                item.removeFromSuperview()
            }
            
            let sview = UIScrollView()
            sview.showsVerticalScrollIndicator = false
            sview.frame = CGRect(x: 0, y: 0, width: View1.frame.width, height: View1.frame.height)
            View1.addSubview(sview)
            sview.edgeTo(view: View1)
            
            let label1 = UILabel(frame: CGRect(x: View1.frame.width * 0.4, y: View1.frame.height * 0.4, width: View1.frame.width * 0.3, height: View1.frame.height * 0.2))
            
            label1.textAlignment = NSTextAlignment.left
            label1.text = "Select game"
            label1.font.withSize(12)
            //label.backgroundColor = .red
            label1.textColor = .black
            sview.addSubview(label1)
            
            
        } else {
            
            let sview = UIScrollView()
            sview.showsVerticalScrollIndicator = false
            sview.frame = CGRect(x: 0, y: 0, width: View1.frame.width, height: View1.frame.height)
            View1.addSubview(sview)
            sview.edgeTo(view: View1)
            
            visualizer(choice1: row-1, team1: PronosB[0][row-1].home_Team!, team2: PronosB[0][row-1].away_Team!, viewP: sview)
            
        }
        
    }
    
    func visualizer(choice1: Int, team1: String, team2: String, viewP: UIScrollView) {
            
            let exampleview = UIScrollView()
            
            exampleview.backgroundColor = .black
            exampleview.translatesAutoresizingMaskIntoConstraints = false
            viewP.addSubview(exampleview)
            
            
            let br: CGFloat = viewP.bounds.width
            let ho: CGFloat = viewP.bounds.height

            exampleview.frame = CGRect(x: 0, y: 0, width: br, height: ho)
            
            var array = [UIView]()
            array.removeAll()
            
            let n = PronosB.count
            
            for _ in 0 ..< n {
                array.append(UIView())
            }
            
            for i in 0...n-1 {
                
                createviews(index1: i, actualview: array[i], superviewer: exampleview, numberviews: n, choice1: choice1, team1: team1, team2: team2)
            
            }
            
            exampleview.contentSize = CGSize(width: br, height: CGFloat(n + 10) * ho / 8)
            
        }
        
        func createviews (index1: Int, actualview: UIView, superviewer: UIScrollView, numberviews: Int, choice1: Int, team1: String, team2: String) {
                
                superviewer.addSubview(actualview)
                actualview.frame = CGRect(x: 0, y: 0.05 + view.bounds.height / 8 * CGFloat(index1), width: superviewer.bounds.width, height: view.bounds.height / 8)
                actualview.backgroundColor = UIColor.init(red: CGFloat((7 + index1 * 0)) / 255, green: CGFloat((128 + index1 * 10)) / 255, blue: CGFloat((252 + index1 * 0)) / 255, alpha: 1)
                
                createlabels(type: 1, superviewer: actualview, teller: index1 + 1, choice1: choice1, team1: team1, team2: team2)
                createlabels(type: 2, superviewer: actualview, teller: index1 + 1, choice1: choice1, team1: team1, team2: team2)
                createlabels(type: 3, superviewer: actualview, teller: index1 + 1, choice1: choice1, team1: team1, team2: team2)
                createlabels(type: 4, superviewer: actualview, teller: index1 + 1, choice1: choice1, team1: team1, team2: team2)
                
            let label2 = UILabel(frame: CGRect(x: actualview.bounds.width * 0.05, y: 0, width: actualview.bounds.width * 0.5, height: actualview.bounds.height * 0.3))
                label2.text = PronosB[index1][0].user
                label2.font.withSize(11)
                actualview.addSubview(label2)
                
            }

        
        func createlabels (type: Int, superviewer: UIView, teller: Int, choice1: Int, team1: String, team2: String ) {
            
            let x0 = superviewer.bounds.width
            let y0 = superviewer.bounds.height
            
            var x1:CGFloat = 0
            let y1 = y0 * 0.5
            let h1 = y0 * 0.2
            var w1:CGFloat = 0
            
            
            let temp1:String = team1
            var temp2:String = ""
            var temp3:String = ""
            let temp4:String = team2
            var temp5:String = ""
            
            temp2 = String(PronosB[teller-1][choice1].home_Goals)
            temp3 = String(PronosB[teller-1][choice1].away_Goals)
            
            
            if type == 1 {
            
                x1 = 0.05 * x0
                w1 = 0.30 * x0
                
                temp5 = temp1
                
            }
            
            if type == 2 {
            
                x1 = 0.40 * x0
                w1 = 0.10 * x0
                temp5 = temp2
                
            }
            
            if type == 3 {
            
                x1 = 0.50 * x0
                w1 = 0.10 * x0
                temp5 = temp3
            }
            
            if type == 4 {
            
                x1 = 0.65 * x0
                w1 = 0.30 * x0
                temp5 = temp4
                
            }
                
            let label = UILabel(frame: CGRect(x: x1, y: y1, width: w1, height: h1))
            label.textAlignment = NSTextAlignment.center
            label.text = temp5
            label.font.withSize(11)
            superviewer.addSubview(label)

            
        }
        
    

}
