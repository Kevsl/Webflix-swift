import UIKit

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}

struct MovieDatas: Codable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}

class ViewController: UIViewController {
    
    

    
    let collectionIdentifier = "displayCollection"
    
    @IBOutlet weak var searchInputField: UITextField!
    
    var movieDatas: MovieDatas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputField.delegate = self
    }
    
 
    
    @IBAction func sitf(_ sender: UITextField) {
        getMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == collectionIdentifier {
            if let collectionViewController = segue.destination as? MovieCollectionViewController {
                collectionViewController.moviesList = movieDatas?.Search
            }
        }
    }
    
    func getMovies() {
        guard let searchValue = searchInputField.text, !searchValue.isEmpty else {
            return
        }
        
        let urlString = "https://www.omdbapi.com/?s=\(searchValue)&apikey=c6c2a5e9"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                
                if let moviesData = data {
                    do {
                        let moviesList = try JSONDecoder().decode(MovieDatas.self, from: moviesData)
                        self.movieDatas = moviesList
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: self.collectionIdentifier, sender: nil)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
