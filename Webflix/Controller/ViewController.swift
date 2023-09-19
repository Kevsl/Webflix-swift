import UIKit

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}

struct MovieResponse: Codable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}

class ViewController: UIViewController {

    var searchValue = ""
    
    @IBOutlet weak var searchInputField: UITextField!
    
    var movieResponse: MovieResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputField.delegate = self
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        getMovies()
    }
    
    @IBAction func searchFieldAction(_ sender: UITextField) {
        searchValue = searchInputField.text ?? ""
        getMovies()
    }
    
    @IBAction func siField(_ sender: UITextField) {
        getMovies()
    }
    
    func getMovies() {
        let urlString = "https://www.omdbapi.com/?s=\(searchInputField.text ?? "")&apikey=c6c2a5e9"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let moviesData = data {
                    do {
                        let moviesList = try JSONDecoder().decode(MovieResponse.self, from: moviesData)
                        self.movieResponse = moviesList
                        
                        DispatchQueue.main.async {
                            
                            print(moviesList)
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
