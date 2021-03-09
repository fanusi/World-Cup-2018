//
//  ViewController3.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit
import CoreXLSX

class ViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let filepath = "/Users/stephanetrouve/Desktop/Projects/Euro-2020-V2-main/Swipetest1/Test1.xlsx"
        
        
//        guard let filepath = Bundle.main.path(forResource: "Test1", ofType: "xlsx") else {
//
//            fatalError("Error")
//        }

        guard let file = XLSXFile(filepath: filepath) else {
          fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }

        for wbk in try! file.parseWorkbooks() {
            for (name, path) in try! file.parseWorksheetPathsAndNames(workbook: wbk) {
            if let worksheetName = name {
              print("This worksheet has a name: \(worksheetName)")
            }

            let worksheet = try! file.parseWorksheet(at: path)
            
            var r = 0
            var co = 0
            
            for row in worksheet.data?.rows ?? [] {
              
              co = 0
                
              for c in row.cells {
                print(c.value)
                let br = view.bounds.width
                let ho = view.bounds.height
                let label1 = UILabel(frame: CGRect(x: br * 0.15 + br * 0.20 * CGFloat(co), y: ho * 0.05 + ho * 0.07 * CGFloat(r), width: br * 0.40, height: ho * 0.05))
                label1.textAlignment = NSTextAlignment.left
                label1.font.withSize(10)
                label1.text = c.value
                label1.textColor = .black
                view.addSubview(label1)
                co = co + 1

              }
                
            r = r + 1
                
            }
          }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}