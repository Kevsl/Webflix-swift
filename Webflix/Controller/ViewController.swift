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
let collectionIdentifier = "displayCollection"



class ViewController: UIViewController {

    var searchValue = ""
    
    @IBOutlet weak var searchInputField: UITextField!
    
    var movieDatas:MovieDatas?
    let moviesListResults:[Movies]? = []
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == collectionIdentifier){
            if let collectionViewController = segue.destination as? MovieCollectionViewController{
                collectionViewController.moviesList = moviesListResults!
            }
        }
        
        
    }
    
    func getMovies() {
        let urlString = "https://www.omdbapi.com/?s=\(searchInputField.text ?? "")&apikey=c6c2a5e9"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let moviesData = data {
                    do {
                        let moviesList = try JSONDecoder().decode(MovieDatas.self, from: moviesData)
                        self.movieDatas = moviesList
                        
                        DispatchQueue.main.async {
                            
                            
                            self.performSegue(withIdentifier: collectionIdentifier, sender: nil)


                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

func truc(){
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
