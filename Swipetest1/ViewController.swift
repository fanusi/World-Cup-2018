//
//  ViewController.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit
import CoreXLSX

public var dummy = Int()

public var PronosA = [Pronostiek]()
public var PronosB = [[Pronostiek]]()
// PronosA contains real scores

public let b1:CGFloat = 0.15
// Height of upper bar

public let ga:Int = 64
//Number of matches

var scores = [Scores]()
// Users and their scores

class ViewController: UIViewController {
    
    //var PronosB = [[Pronostiek]]()
    // PronosB contains guesses of all players
    
    let pr:Int = 43
    //Number of players
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        print(dummy)
        
        if dummy == 0 {
            
            //Only parse on app loading
            fixtureParsing()

            dummy = 1
            
        }
        
        let bar1 = UIView()
        bar1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * b1)
        bar1.backgroundColor = .systemRed
        //bar1.backgroundColor = UIColor.init(red: 0, green: 209/255, blue: 255/255, alpha: 0.75)
        view.addSubview(bar1)
        
        let chevronLeft = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .heavy))
        let chevronRight = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .heavy))
        
        let title = UILabel(frame: CGRect(x: bar1.frame.width * 0.3, y: bar1.frame.height * 0.5, width: bar1.frame.width * 0.4, height: bar1.frame.height * 0.30))
        
        title.text = "Ranking"
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont.boldSystemFont(ofSize: 25.0)
        title.textColor = .white
        
        let cleft = UIButton(type: .custom)
        cleft.frame = CGRect(x: bar1.frame.width * 0.0, y: bar1.frame.height * 0.5, width: bar1.frame.width * 0.15, height: bar1.frame.height * 0.30)
        let cright = UIButton(type: .custom)
        cright.frame = CGRect(x: bar1.frame.width * 0.85, y: bar1.frame.height * 0.5, width: bar1.frame.width * 0.15, height: bar1.frame.height * 0.30)
        
        cleft.setImage(chevronLeft, for: UIControl.State.normal)
        cright.setImage(chevronRight, for: UIControl.State.normal)
        
        cleft.tintColor = .white
        cright.tintColor = .white
        
        cleft.addTarget(self, action: #selector(arrowleft), for: .touchUpInside)
        cright.addTarget(self, action: #selector(arrowright), for: .touchUpInside)
        
        bar1.addSubview(title)
        bar1.addSubview(cleft)
        bar1.addSubview(cright)
        
        let mainview = UIView()
        mainview.frame = CGRect(x: 0, y: view.frame.height * b1, width: view.frame.width, height: view.frame.height * (1-b1))
        view.addSubview(mainview)
        
        let sview = UIScrollView()
        sview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        sview.showsVerticalScrollIndicator = false
        
        mainview.addSubview(sview)
        sview.edgeTo(view: mainview)
        scoreView(view1: sview)
        
    }
    
    func fixtureParsing () {
                
                //Populate PronosA from FootballAPI
            
                let headers = [
                    "x-rapidapi-key": "a08ffc63acmshbed8df93dae1449p15e553jsnb3532d9d0c9b",
                    "x-rapidapi-host": "api-football-v1.p.rapidapi.com"
                ]

                //403
                let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v2/fixtures/league/1?timezone=Europe%2FLondon")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
            
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    
                if error == nil && data != nil {
                    
                        
                let decoder = JSONDecoder()
                        
                do {
                            
                        let start = 0
                        let end = 63

                        let niveau1 = try decoder.decode(api1.self, from: data!)
                        //print(niveau1)
                        
                        for n in start...end {

                            //print(niveau1.api.fixtures[n].fixture_id)
                            let newFixture = Pronostiek(context: self.context)
                            newFixture.fixture_ID = Int32(niveau1.api.fixtures[n].fixture_id)
                            newFixture.round = niveau1.api.fixtures[n].round
                            newFixture.home_Goals = Int16(niveau1.api.fixtures[n].goalsHomeTeam)
                            newFixture.away_Goals = Int16(niveau1.api.fixtures[n].goalsAwayTeam)
                            newFixture.home_Team = niveau1.api.fixtures[n].homeTeam.team_name
                            newFixture.away_Team = niveau1.api.fixtures[n].awayTeam.team_name
                            newFixture.fulltime = niveau1.api.fixtures[n].score.fulltime
                            newFixture.status = niveau1.api.fixtures[n].status
                            
                            print(newFixture.fulltime!)
                            print(newFixture.status!)
                            print(newFixture.home_Goals)
                            print(newFixture.away_Goals)
                            
                            
                            PronosA.append(newFixture)
                            //try self.context.savePronos2()

                        }
                    
                            
                    } catch {
                        
                        debugPrint(error)
                    }
                        
                }
                                
                })
                    
                dataTask.resume()

        }
    
    func scoreView (view1: UIScrollView) {
        
        if PronosA.count > 0 {

            //testpronos()
            realpronos()
            routine()
            createlabels(view1: view1)
            view1.contentSize = CGSize(width: view1.frame.width, height: view1.frame.height * CGFloat(Double(PronosB.count + 3) * 0.05))
            
        } else {
            
            let br = view1.bounds.width
            let ho = view1.bounds.height
            let label1 = UILabel(frame: CGRect(x: br * 0.40, y: ho * 0.35, width: br * 0.40, height: ho * 0.25))
            label1.textAlignment = NSTextAlignment.left
            label1.font.withSize(18)
            label1.text = "Fetching..."
            label1.textColor = .black
            view1.addSubview(label1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
                view1.subviews.forEach { (item) in
                item.removeFromSuperview()
                }
                self.scoreView(view1: view1)
            
            }
            
        }
        
    }
    
    
    func createlabels(view1: UIScrollView) {
    
        
        let br = view1.bounds.width
        let ho = view1.bounds.height
        
        let label0 = UILabel(frame: CGRect(x: br * 0.05, y: ho * 0, width: br * 0.10, height: ho * 0.05))
        let label1 = UILabel(frame: CGRect(x: br * 0.20, y: ho * 0, width: br * 0.40, height: ho * 0.05))
        let label2 = UILabel(frame: CGRect(x: br * 0.65, y: ho * 0, width: br * 0.20, height: ho * 0.05))
  
        label0.textAlignment = NSTextAlignment.center
        label0.text = "Rank"
        label0.font = UIFont.boldSystemFont(ofSize: 15.0)
        //label.backgroundColor = .red
        label0.textColor = .black
        view1.addSubview(label0)
        
        label1.textAlignment = NSTextAlignment.left
        label1.text = "Player"
        label1.font = UIFont.boldSystemFont(ofSize: 15.0)
        //label.backgroundColor = .red
        label1.textColor = .black
        view1.addSubview(label1)
                            
        label2.textAlignment = NSTextAlignment.center
        label2.text = "Points"
        label2.font = UIFont.boldSystemFont(ofSize: 15.0)
        //label.backgroundColor = .red
        label2.textColor = .black
        view1.addSubview(label2)
        
        
        for i in 0...pr-1 {
            
            let label0 = UILabel(frame: CGRect(x: br * 0.05, y: ho * 0.05 + ho * 0.05 * CGFloat(i), width: br * 0.10, height: ho * 0.05))
            
            let label1 = UILabel(frame: CGRect(x: br * 0.20, y: ho * 0.05 + ho * 0.05 * CGFloat(i), width: br * 0.40, height: ho * 0.05))
            
            let label2 = UILabel(frame: CGRect(x: br * 0.65, y: ho * 0.05 + ho * 0.05 * CGFloat(i), width: br * 0.20, height: ho * 0.05))
            
            
            label0.textAlignment = NSTextAlignment.center
            //label1.text = PronosB[i][0].user
            label0.text = String(i + 1)
            label0.font = UIFont.systemFont(ofSize: 15.0)
            //label.backgroundColor = .red
            label0.textColor = .black
            view1.addSubview(label0)
  
            label1.textAlignment = NSTextAlignment.left
            //label1.text = PronosB[i][0].user
            label1.text = scores[i].user
            label1.font = UIFont.systemFont(ofSize: 15.0)
            //label.backgroundColor = .red
            label1.textColor = .black
            view1.addSubview(label1)
                                
            label2.textAlignment = NSTextAlignment.center
            label2.text = String(scores[i].punten)
            label2.font = UIFont.systemFont(ofSize: 15.0)
            //label.backgroundColor = .red
            label2.textColor = .black
            view1.addSubview(label2)
            
        }
        
    }
    
    func puntenSommatie (z: Int, speler: [Pronostiek]) -> Int {
        
        var som:Int = 0
        
        for l in 0...z {
            
            som = som + Int(speler[l].statistiek?.punten ?? 0)
            
        }
        
        return som
        
    }
    
    func calc_simple (hg_p: Int, ag_p: Int, hg_r: Int, ag_r: Int) -> Int {
        
        var punten: Int = 0
        
        if hg_r >= 0 {
        
            if hg_r > ag_r && hg_p > ag_p {
                
                punten = punten + 1
                
                if hg_r == hg_p {
                    
                    punten = punten + 1
                    
                }
                
                if ag_r == ag_p {
                    
                    punten = punten + 1
                    
                }
                
            }

            if hg_r < ag_r && hg_p < ag_p {
                
                punten = punten + 1
                
                if hg_r == hg_p {
                    
                    punten = punten + 1
                    
                }
                
                if ag_r == ag_p {
                    
                    punten = punten + 1
                    
                }
                     
            }

            if hg_r == ag_r && hg_p == ag_p {
                
                punten = punten + 1
                
                if hg_r == hg_p {
                    
                    punten = punten + 2
                    
                }
                     
            }
        
        }
        
        return punten
        
        
    }
    
    func calculator (speler: [Pronostiek]) {
        
    
        for j in 0...ga-1 {
            
            //reset punten voor elke match
            var punten:Int = 0
            
            let homegoals_real: Int = Int(PronosA[j].home_Goals)
            let awaygoals_real: Int = Int(PronosA[j].away_Goals)
            let homegoals_prono: Int = Int(speler[j].home_Goals)
            let awaygoals_prono: Int = Int(speler[j].away_Goals)
    
            punten = punten + calc_simple(hg_p: homegoals_prono, ag_p: awaygoals_prono, hg_r: homegoals_real, ag_r: awaygoals_real)
    
            
            //toewijzen van punten
            let stat = Statistiek(context: context)
            stat.punten = Int16(punten)
            stat.user = speler[j].user
            
            speler[j].statistiek = stat
            
        }
        
    }
    
    func routine () {
               
        scores.removeAll()
        
        for i in 0...pr-1 {
            
            calculator(speler: PronosB[i])
            
            let newscore = Scores(user: (PronosB[i].first?.user)! , punten: puntenSommatie(z: ga-1, speler: PronosB[i]), index: i)

            scores.append(newscore)
            
        }
        
        scores = scores.sorted(by: { ($0.punten) > ($1.punten) })
        //PronosB = PronosB.sorted(by: { ($0.last?.statistiek!.punten)! > ($1.last?.statistiek!.punten)! })
        
        for i in 0...pr-1 {
            
            scores[i].ranking = i
            print(scores[i].ranking)
            print(scores[i].index)
            
        }
        
        
    }
    
    func realpronos () {
        
        var gebruikers: [String] = []
        var homeTeams: [String] = []
        var awayTeams: [String] = []
        
        guard let filepath = Bundle.main.path(forResource: "WK 18", ofType: "xlsx") else {

            fatalError("Error n1")
        }

        guard let file = XLSXFile(filepath: filepath) else {
          fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }

        for wbk in try! file.parseWorkbooks() {
            for (name, path) in try! file.parseWorksheetPathsAndNames(workbook: wbk) {
            if let worksheetName = name {
              print("This worksheet has a name: \(worksheetName)")
            }

            let worksheet = try! file.parseWorksheet(at: path)
                
            if let sharedStrings = try! file.parseSharedStrings() {
              let columnAStrings = worksheet.cells(atColumns: [ColumnReference("A")!])
                .compactMap { $0.stringValue(sharedStrings) }
            
                gebruikers = columnAStrings
    
            }
                
            if let sharedStrings = try! file.parseSharedStrings() {
              let columnCStrings = worksheet.cells(atColumns: [ColumnReference("C")!])
                .compactMap { $0.stringValue(sharedStrings) }
            
                homeTeams = columnCStrings
    
            }
            
            if let sharedStrings = try! file.parseSharedStrings() {
              let columnDStrings = worksheet.cells(atColumns: [ColumnReference("D")!])
                .compactMap { $0.stringValue(sharedStrings) }
            
                awayTeams = columnDStrings
    
            }
            
            print(gebruikers[0])
            print(gebruikers[1])
            
            PronosB.removeAll()
                    
            for i in 0...pr-1 {
                
                // Loop players
                
                let newArrayFixtures = [Pronostiek(context: self.context)]
                PronosB.append(newArrayFixtures)
                
                PronosB[i][0].user = gebruikers[1 + ga*i]
                PronosB[i][0].fixture_ID = PronosA[0].fixture_ID
                PronosB[i][0].round = PronosA[0].round
                PronosB[i][0].home_Goals = Int16((worksheet.data?.rows[1 + ga*i].cells[4].value)!)!
                PronosB[i][0].away_Goals = Int16((worksheet.data?.rows[1 + ga*i].cells[5].value)!)!
                PronosB[i][0].home_Team = homeTeams[1 + ga*i]
                PronosB[i][0].away_Team = awayTeams[1 + ga*i]
                
                for n in 1...ga-1 {
                    
                    // Loop games
                    let newFixture = Pronostiek(context: self.context)
                    newFixture.user = gebruikers[(n+1) + ga*i]
                    newFixture.fixture_ID = PronosA[n].fixture_ID
                    newFixture.round = PronosA[n].round
                    newFixture.home_Goals = Int16((worksheet.data?.rows[(n+1) + ga*i].cells[4].value)!)!
                    newFixture.away_Goals = Int16((worksheet.data?.rows[(n+1) + ga*i].cells[5].value)!)!
                    newFixture.home_Team = homeTeams[(n+1) + ga*i]
                    newFixture.away_Team = awayTeams[(n+1) + ga*i]
                    PronosB[i].append(newFixture)
                    
                }
                
            }
            
          }
        }
    }
    
    func testpronos () {
        
        //Populate PronosB with random data
            
        PronosB.removeAll()
        
            let t:Int = 20
            // Create t+1 test pronos
        
            let g:Int = 20
            // Number of games
            
            for i in 0...t {
                
                // Loop players
                
                let newArrayFixtures = [Pronostiek(context: self.context)]
                PronosB.append(newArrayFixtures)
                
                PronosB[i][0].user = "User " + String(i+1)
                PronosB[i][0].fixture_ID = PronosA[0].fixture_ID
                PronosB[i][0].round = PronosA[0].round
                PronosB[i][0].home_Goals = Int16.random(in: 0..<4)
                PronosB[i][0].away_Goals = Int16.random(in: 0..<4)
                PronosB[i][0].home_Team = PronosA[0].home_Team
                PronosB[i][0].away_Team = PronosA[0].away_Team
                
                for n in 1...g {
                    
                    // Loop games
                    let newFixture = Pronostiek(context: self.context)
                    newFixture.user = "User " + String(i+1)
                    newFixture.fixture_ID = PronosA[n].fixture_ID
                    newFixture.round = PronosA[n].round
                    newFixture.home_Goals = Int16.random(in: 0..<4)
                    newFixture.away_Goals = Int16.random(in: 0..<4)
                    newFixture.home_Team = PronosA[n].home_Team
                    newFixture.away_Team = PronosA[n].away_Team
                    PronosB[i].append(newFixture)
                    
                }
                
            }
        
    }


}

extension UIViewController {
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
        default:
            break
        }
        
    }
 
    @objc func arrowleft() {
    
            performSegue(withIdentifier: "goLeft", sender: self)

    }
    
    @objc func arrowright() {
    
            performSegue(withIdentifier: "goRight", sender: self)

    }
    
}
