/// Copyright (c) 2022 Razeware LLC
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
  // MARK: - UI Elements

  @IBOutlet weak var moviesTableView: NSTableView!
  @IBOutlet weak var titleLabel: NSTextField!
  @IBOutlet weak var runtimeLabel: NSTextField!
  @IBOutlet weak var genresLabel: NSTextField!
  @IBOutlet weak var principalsLabel: NSTextField!
  @IBOutlet weak var favImage: NSImageView!
  @IBOutlet weak var statusLabel: NSTextField!

  // MARK: - Properties

  var movies: [Movie] = []
  var visibleMovies: [Movie] = []
  var searchText = "" {
    didSet {
      showValidMovies()
    }
  }
  var selectedMovie: Movie?
  let dataStore = DataStore()
  var viewType = ViewType.allMovies
  var highRatingLimit = 9.0

  lazy var numFormatter: NumberFormatter = {
    var formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    return formatter
  }()

  // MARK: - View

  override func viewDidLoad() {
    super.viewDidLoad()

    movies = dataStore.readStoredData()
    addSortDescriptors()
    showValidMovies()
  }

  func showValidMovies() {
    var moviesToShow = movies
    if viewType == .favsOnly {
      moviesToShow = movies.filter { movie in
        movie.isFav
      }
    } else if viewType == .highRating {
      moviesToShow = movies.filter { movie in
        movie.rating > highRatingLimit
      }
    }

    if searchText.isEmpty {
      visibleMovies = moviesToShow
    } else {
      let lowercaseSearch = searchText.localizedLowercase
      visibleMovies = moviesToShow.filter { movie in
        movie.title.localizedLowercase.contains(lowercaseSearch)
      }
    }

    if let sortedMovies = (visibleMovies as NSArray)
      .sortedArray(using: moviesTableView.sortDescriptors) as? [Movie] {
      visibleMovies = sortedMovies
    }

    moviesTableView.reloadData()

    //  statusLabel.stringValue = "\(visibleMovies.count) movies."
    let numberString = numFormatter.string(for: visibleMovies.count)
    ?? "\(visibleMovies.count)"
    statusLabel.stringValue = "\(numberString) movies"
  }

  func saveInBackground() {
    DispatchQueue.global().async {
      self.dataStore.saveData(movies: self.movies)
    }
  }

  // MARK: - Menu Actions

  @IBAction func toggleFavorite(_ sender: Any) {
    if let selectedMovie {
      selectedMovie.isFav.toggle()
      showSelectedMovie(selectedMovie)
      saveInBackground()
    }
  }

  @IBAction func revertToDefaults(_ sender: Any) {
    statusLabel.stringValue = "Reverting to default movie data…"
    selectedMovie = nil
    viewType = .allMovies
    clearSelectedMovie()

    DispatchQueue.global().async {
      self.movies = self.dataStore.reloadDefaultMovies()
      DispatchQueue.main.async {
        self.showValidMovies()
      }
    }
  }

  @IBAction func showAllMovies(_ sender: Any) {
    viewType = .allMovies
    showValidMovies()
  }

  @IBAction func showFavs(_ sender: Any) {
    viewType = .favsOnly
    showValidMovies()
  }

  @IBAction func showHighRated(_ sender: Any) {
    viewType = .highRating
    showValidMovies()
  }

  // MARK: - Contextual Menu Actions

  @IBAction func showInBrowser(_ sender: Any) {
    guard let movieToShow = clickedMovie() else {
      return
    }

    let address = "https://www.imdb.com/title/\(movieToShow.id)/"
    guard let url = URL(string: address) else {
      return
    }
    NSWorkspace.shared.open(url)
  }

  @IBAction func deleteMovie(_ sender: Any) {
    guard let movie = clickedMovie() else {
      return
    }

    let index = movies.firstIndex {
      $0.id == movie.id
    }
    guard let index = index else {
      return
    }

    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "Really delete '\(movie.title)'?"
    alert.addButton(withTitle: "Delete")
    alert.addButton(withTitle: "Cancel")
    let response = alert.runModal()
    if response == .alertFirstButtonReturn {
      selectedMovie = nil
      clearSelectedMovie()

      movies.remove(at: index)
      showValidMovies()

      saveInBackground()
    }
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
      let movieData = try? JSONEncoder().encode(movie) else {
      return
    }

    if
      let windowController = segue.destinationController as? NSWindowController,
      let editViewController = windowController.contentViewController as? EditViewController {
      editViewController.originalMovieData = movieData
      editViewController.parentVC = self
    }
  }

  func saveMoveEdits(for movie: Movie) {
    let index = movies.firstIndex {
      $0.id == movie.id
    }

    if let index {
      movies[index] = movie
    } else {
      movies.append(movie)
    }

    showValidMovies()
    if selectedMovie?.id == movie.id {
      showSelectedMovie(movie)
    }

    saveInBackground()
  }

  func clickedMovie() -> Movie? {
    var movie = selectedMovie

    let row = moviesTableView.clickedRow
    if row >= 0 && row < visibleMovies.count {
      movie = visibleMovies[row]
    }

    return movie
  }
}
