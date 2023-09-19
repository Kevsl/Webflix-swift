import UIKit

class MovieTableController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sitftv: UITextField!

    var movieDatas: MovieDatas?
    
    let cellID = "Cell"
    
    var moviesList: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sitftv.delegate = self
    }

    func getMovies() {
        guard let searchValue = sitftv.text else {
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
                            self.moviesList =
                            self.movieDatas?.Search ?? []
                            self.setUpTableView()
                            self.tableView.reloadData()

                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }

    @IBAction func sitAction(_ sender: UITextField) {
        getMovies()
              
    }
 
}

extension MovieTableController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MovieTableController: UITableViewDelegate, UITableViewDataSource {
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MovieTableViewCell

        cell.setup(moviesList[indexPath.row])
        return cell
    }
}
