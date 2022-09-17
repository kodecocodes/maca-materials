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

import AppKit

extension ViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    visibleMovies.count
  }

  func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
    if let sortedMovies = (visibleMovies as NSArray).sortedArray(using: moviesTableView.sortDescriptors) as? [Movie] {
      visibleMovies = sortedMovies
    }
    moviesTableView.reloadData()
  }
}

extension ViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let columnID = tableColumn?.identifier else {
      return nil
    }

    let movie = visibleMovies[row]
    var cellID = ""
    var cellText = ""

    switch columnID.rawValue {
    case "TitleColumn":
      cellID = "TitleCell"
      cellText = movie.title
    case "YearColumn":
      cellID = "YearCell"
      cellText = movie.year
    case "RatingColumn":
      cellID = "RatingCell"
      cellText = "\(movie.rating)"
    default:
      return nil
    }

    let cellIdentifier = NSUserInterfaceItemIdentifier(cellID)
    if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = cellText
      return cell
    }

    return nil
  }

  func addSortDescriptors() {
    let titleSortDesc = NSSortDescriptor(
      key: "title",
      ascending: true,
      selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
    let yearSortDesc = NSSortDescriptor(key: "year", ascending: true)
    let ratingSortDesc = NSSortDescriptor(key: "rating", ascending: true)

    let sortDescs = [titleSortDesc, yearSortDesc, ratingSortDesc]

    for index in 0 ..< moviesTableView.numberOfColumns {
      moviesTableView.tableColumns[index].sortDescriptorPrototype = sortDescs[index]
    }
  }

  // MARK: - Selection

  func tableViewSelectionDidChange(_ notification: Notification) {
    let row = moviesTableView.selectedRow
    if row < 0 || row >= visibleMovies.count {
      clearSelectedMovie()
      return
    }

    selectedMovie = visibleMovies[row]
    showSelectedMovie(visibleMovies[row])
  }


  func clearSelectedMovie() {
    titleLabel.stringValue = ""
    runtimeLabel.stringValue = ""
    genresLabel.stringValue = ""
    principalsLabel.stringValue = ""
    favImage.image = nil
  }

  func showSelectedMovie(_ movie: Movie) {
    titleLabel.stringValue = movie.title
    runtimeLabel.stringValue = "\(movie.runTime) minutes"
    genresLabel.stringValue = movie.genres
    principalsLabel.stringValue = movie.principalsDisplay

    let imageName = movie.isFav ? "heart.fill" : "heart"
    let color = movie.isFav ? NSColor.red : NSColor.gray

    let image = NSImage(systemSymbolName: imageName, accessibilityDescription: imageName)
    let config = NSImage.SymbolConfiguration(paletteColors: [color])

    favImage.image = image?.withSymbolConfiguration(config)
  }
}
