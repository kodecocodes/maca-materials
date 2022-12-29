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

  var dataStore = DataStore()

  var movies: [Movie] = []
  var visibleMovies: [Movie] = []

  var selectedMovie: Movie?

  var searchText = "" {
    didSet {
      searchMovies()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    movies = dataStore.readStoredData()
    print(movies.count)
    visibleMovies = movies
    addSortDescriptors()
  }

  @IBAction func favButtonClicked(_ sender: Any) {
    if let selectedMovie {
      selectedMovie.isFav.toggle()
      showSelectedMovie(selectedMovie)
      dataStore.saveData(movies: movies)
    }
  }

  func searchMovies() {
    if searchText.isEmpty {
      visibleMovies = movies
    } else {
      visibleMovies = movies.filter { movie in
        movie.title.localizedCaseInsensitiveContains(searchText)
      }
    }
    if let sortedMovies = (visibleMovies as NSArray)
      .sortedArray(using: moviesTableView.sortDescriptors) as? [Movie] {
      visibleMovies = sortedMovies
    }

    moviesTableView.reloadData()
  }
}
