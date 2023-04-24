/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Cocoa

class ViewController: NSViewController {
  @IBOutlet weak var moviesTableView: NSTableView!

  @IBOutlet weak var titleLabel: NSTextField!
  @IBOutlet weak var runtimeLabel: NSTextField!
  @IBOutlet weak var genresLabel: NSTextField!
  @IBOutlet weak var principalsLabel: NSTextField!

  @IBOutlet weak var favButton: NSButton!
  @IBOutlet weak var statusLabel: NSTextField!

  var dataStore = DataStore()

  var movies: [Movie] = []
  var visibleMovies: [Movie] = []

  var selectedMovie: Movie?

  var searchText = "" {
    didSet {
      searchMovies()
    }
  }

  var viewMode = ViewMode.allMovies {
    didSet {
      searchMovies()
    }
  }
  var highRatingLimit = 9.0

  override func viewDidLoad() {
    super.viewDidLoad()
    movies = dataStore.readStoredData()

    let defaultViewModeSetting = UserDefaults.standard
      .integer(forKey: "defaultViewMode")
    if let defaultViewMode = ViewMode(rawValue: defaultViewModeSetting) {
      viewMode = defaultViewMode
    }

    addSortDescriptors()
    searchMovies()
    showMovieCount()

    UserDefaults.standard.register(defaults: ["highRatingLimit": 9.0])

    NotificationCenter.default.addObserver(
      forName: UserDefaults.didChangeNotification,
      object: nil,
      queue: .main) { _ in
        self.userDefaultsChanged()
    }
  }

  func userDefaultsChanged() {
    let newLimit = UserDefaults.standard.double(forKey: "highRatingLimit")
    let roundedLimit = round(newLimit * 10) / 10
    highRatingLimit = roundedLimit

    if viewMode == .highRating {
      searchMovies()
    }
  }

  @IBAction func favButtonClicked(_ sender: Any) {
    if let selectedMovie {
      selectedMovie.isFav.toggle()
      showSelectedMovie(selectedMovie)
      dataStore.saveData(movies: movies)
    }
  }

  func searchMovies() {
    var moviesToShow = movies
    if viewMode == .favsOnly {
      moviesToShow = movies.filter { movie in
        movie.isFav
      }
    } else if viewMode == .highRating {
      moviesToShow = movies.filter { movie in
        movie.rating >= highRatingLimit
      }
    }

    if searchText.isEmpty {
      visibleMovies = moviesToShow
    } else {
      visibleMovies = moviesToShow.filter { movie in
        movie.title.localizedCaseInsensitiveContains(searchText)
      }
    }
    if let sortedMovies = (visibleMovies as NSArray)
      .sortedArray(using: moviesTableView.sortDescriptors) as? [Movie] {
      visibleMovies = sortedMovies
    }

    moviesTableView.reloadData()
    showMovieCount()
  }

  func showMovieCount() {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current

    let numberString = formatter.string(for: visibleMovies.count)
    ?? "\(visibleMovies.count)"

    statusLabel.stringValue = "\(numberString) movies."
  }

  // MARK: - Menu Actions

  @IBAction func showAllMovies(_ sender: Any) {
    viewMode = .allMovies
  }

  @IBAction func showFavs(_ sender: Any) {
    viewMode = .favsOnly
  }

  @IBAction func showHighRated(_ sender: Any) {
    viewMode = .highRating
  }

  // MARK: - Contextual Menu Actions

  func clickedMovie() -> Movie? {
    let row = moviesTableView.clickedRow
    if row > -1 {
      return visibleMovies[row]
    }
    return nil
  }

  @IBAction func editMovie(_ sender: Any) {
    guard let movie = clickedMovie() else {
      return
    }
    performSegue(withIdentifier: "showEditWindow", sender: movie)
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showEditWindow" else {
      return
    }

    guard
      let movie = sender as? Movie,
      let movieData = try? JSONEncoder().encode(movie)
    else {
      return
    }

    if
      let windowController = segue.destinationController as? NSWindowController,
      let editViewController = windowController
        .contentViewController as? EditViewController {
      editViewController.originalMovieData = movieData
      editViewController.parentVC = self
    }
  }

  func saveEdits(for movie: Movie) {
    let index = movies.firstIndex {
      $0.id == movie.id
    }

    if let index {
      movies[index] = movie
    } else {
      movies.append(movie)
    }

    searchMovies()
    if selectedMovie?.id == movie.id {
      showSelectedMovie(movie)
    }

    dataStore.saveData(movies: movies)
  }

  @IBAction func showInBrowser(_ sender: Any) {
    guard let movie = clickedMovie() else {
      return
    }

    let address = "https://www.imdb.com/title/\(movie.id)/"
    guard let url = URL(string: address) else {
      return
    }
    NSWorkspace.shared.open(url)
  }

  @IBAction func deleteMovie(_ sender: Any) {
    guard let movie = clickedMovie() else {
      return
    }

    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "Really delete '\(movie.title)'?"

    alert.addButton(withTitle: "Delete")
    alert.addButton(withTitle: "Cancel")

    let response = alert.runModal()

    if response == .alertFirstButtonReturn {
      movies.removeAll {
        $0.id == movie.id
      }

      clearSelectedMovie()
      searchMovies()
      dataStore.saveData(movies: movies)
    }
  }
}
