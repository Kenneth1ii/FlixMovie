//
//  movieViewController.swift
//  FlixMovie
//
//  Created by Kenneth Li on 2/21/19.
//  Copyright © 2019 Kenneth Li. All rights reserved.
//

import UIKit
import AlamofireImage

class movieViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self   // self as movieView controller class.
        
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as!  [[String:Any]] // casting
                
                self.tableView.reloadData()
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // as! casting,
                                                                        // ! for unwrapping
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel!.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading")
        // Find Movie Selected
        let cell = sender as! UITableViewCell       // Cast sender as UItabelViewcell. b/c that is the cell
                                                    //  sender is from the UITablecell in this case.
        
        let indexPath = tableView.indexPath(for: cell)! // ! Unwrapping UitableCell to an Int.
        let movie = movies[indexPath.row]   //access Array which is current movie cell of dictionaries.
        
        
        
        // pass the move to the movie down to the *moviesdetail view controller*
        // so it can handle the task from there.
        // 1 controller = 1 UiViewNavigation
        
        let detailsViewController = segue.destination as! MoviesDetailsViewController
        detailsViewController.movie = movie // The = movie is our movie from this Array. Previous step.
                                    // movie property from MoviesDetailControll which we just made.
        
        
        tableView.deselectRow(at: indexPath, animated: true)    // deselect highlighted tablecell
                                                                // done by default
    }
}
