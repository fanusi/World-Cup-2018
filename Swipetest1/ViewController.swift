//
//  ViewController.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit

public var dummy = Int()

public var PronosA = [Pronostiek]()
public var PronosB = [[Pronostiek]]()
// PronosA contains real scores

class ViewController: UIViewController {
    
    //var PronosB = [[Pronostiek]]()
    // PronosB contains guesses of all players
    
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
        
        let sview = UIScrollView()
        sview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        sview.frame = CGRect(x: 0, y: view.frame.height * 0.08, width: view.frame.width, height: view.frame.height * 0.84)
        sview.showsVerticalScrollIndicator = false
        
        self.view.addSubview(sview)
        sview.edgeTo(view: view)
        scoreView(view1: sview)
        
    }
    
    func fixtureParsing () {
                
                //Populate PronosA from FootballAPI
            
                let headers = [
                    "x-rapidapi-key": "a08ffc63acmshbed8df93dae1449p15e553jsnb3532d9d0c9b",
                    "x-rapidapi-host": "api-football-v1.p.rapidapi.com"
                ]

                let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v2/fixtures/league/403?timezone=Europe%2FLondon")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
            
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    
                if error == nil && data != nil {
                    
                        
                let decoder = JSONDecoder()
                        
                do {
                            
                    
                        let g = 297
                        let niveau1 = try decoder.decode(api1.self, from: data!)
                        //print(niveau1)
                        
                        for n in 0...g {

                            //print(niveau1.api.fixtures[n].fixture_id)
                            let newFixture = Pronostiek(context: self.context)
                            newFixture.fixture_ID = Int32(niveau1.api.fixtures[n].fixture_id)
                            newFixture.round = niveau1.api.fixtures[n].round
                            newFixture.home_Goals = Int16(niveau1.api.fixtures[n].goalsHomeTeam)
                            newFixture.away_Goals = Int16(niveau1.api.fixtures[n].goalsAwayTeam)
                            newFixture.home_Team = niveau1.api.fixtures[n].homeTeam.team_name
                            newFixture.away_Team = niveau1.api.fixtures[n].awayTeam.team_name
                            
                            
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

            testpronos()
            routine()
            createlabels(view1: view1)
            view1.contentSize = CGSize(width: view.frame.width, height: view.frame.height * CGFloat(Double(PronosB.count + 3) * 0.05))
            
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
        
        let t:Int = 20
        // Create t+1 test pronos
        
        let g:Int = 20
        // Number of games
        
        let br = view1.bounds.width
        let ho = view1.bounds.height
        
        let label1 = UILabel(frame: CGRect(x: br * 0.15, y: ho * 0.05, width: br * 0.40, height: ho * 0.05))
        
        let label2 = UILabel(frame: CGRect(x: br * 0.65, y: ho * 0.05, width: br * 0.20, height: ho * 0.05))
        
        label1.textAlignment = NSTextAlignment.left
        label1.text = "Player"
        label1.font.withSize(12)
        //label.backgroundColor = .red
        label1.textColor = .black
        view1.addSubview(label1)
                            
        label2.textAlignment = NSTextAlignment.center
        label2.text = "Points"
        label2.font.withSize(12)
        //label.backgroundColor = .red
        label2.textColor = .black
        view1.addSubview(label2)
        
        
        for i in 0...t {
            
            let label1 = UILabel(frame: CGRect(x: br * 0.15, y: ho * 0.10 + ho * 0.05 * CGFloat(i), width: br * 0.40, height: ho * 0.05))
            
            let label2 = UILabel(frame: CGRect(x: br * 0.65, y: ho * 0.10 + ho * 0.05 * CGFloat(i), width: br * 0.20, height: ho * 0.05))
            
            //Test 2
            
            label1.textAlignment = NSTextAlignment.left
            label1.text = PronosB[i][0].user
            label1.font.withSize(12)
            //label.backgroundColor = .red
            label1.textColor = .black
            view1.addSubview(label1)
                                
            label2.textAlignment = NSTextAlignment.center
            label2.text = String(puntenSommatie(z: g, speler: PronosB[i]))
            label2.font.withSize(12)
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
    
    func calculator (speler: [Pronostiek]) {
        
        let g:Int = 20
        // Number of games
        
        var punten:Int = 0
        
        for j in 0...g {
            
            //reset punten voor elke match
            punten = 0
            
            if PronosA[j].home_Goals > PronosA[j].away_Goals && speler[j].home_Goals > speler[j].away_Goals {
                
                punten = punten + 1
                
                if PronosA[j].home_Goals == speler[j].home_Goals {
                    
                    punten = punten + 1
                    
                }
                
                if PronosA[j].away_Goals == speler[j].away_Goals {
                    
                    punten = punten + 1
                    
                }
                
            }

            if PronosA[j].home_Goals < PronosA[j].away_Goals && speler[j].home_Goals < speler[j].away_Goals {
                
                punten = punten + 1
                
                if PronosA[j].home_Goals == speler[j].home_Goals {
                    
                    punten = punten + 1
                    
                }
                
                if PronosA[j].away_Goals == speler[j].away_Goals {
                    
                    punten = punten + 1
                    
                }
                     
            }

            if PronosA[j].home_Goals == PronosA[j].away_Goals && speler[j].home_Goals == speler[j].away_Goals {
                
                punten = punten + 1
                
                if PronosA[j].home_Goals == speler[j].home_Goals {
                    
                    punten = punten + 2
                    
                }
                     
            }
            
            //toewijzen van punten
            let stat = Statistiek(context: context)
            stat.punten = Int16(punten)
            stat.user = speler[j].user
            
            speler[j].statistiek = stat
            
        }
        
    }
    
    func routine () {
        
        let t:Int = 20
        // Create t+1 test pronos
        
        for i in 0...t {
            
            calculator(speler: PronosB[i])
            
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
    
}
