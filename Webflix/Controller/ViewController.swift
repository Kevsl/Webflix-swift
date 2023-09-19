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
    
    @IBOutlet weak var searchInputField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieDatas: MovieDatas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self

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
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
    @IBAction func sitfa(_ sender: UITextField) {
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getMovies()
        return true
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDatas?.Search.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else {
            fatalError("Cell is not of type CollectionViewCell")
        }
        
        if let movieDatas = movieDatas{
            let movie = movieDatas.Search[indexPath.item]
            cell.setup(movie)
            
        }
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 2 - 8
        return CGSize(width: width, height: 200)
    }
}
