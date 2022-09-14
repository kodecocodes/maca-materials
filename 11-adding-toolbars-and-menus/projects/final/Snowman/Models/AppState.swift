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

import SwiftUI

class AppState: ObservableObject {
  @Published var games: [Game]
  @Published var currentGame: Game
  @Published var selectedID: Int?
  @Published var bossMode = false

  @AppStorage("maxWordLength") var maxWordLength = 10
  @AppStorage("minWordLength") var minWordLength = 4
  @AppStorage("useProperNouns") var useProperNouns = false

  init() {
    games = []
    currentGame = Game(id: 1)
    currentGame.word = getRandomWord()
    selectedID = 1
    games.append(currentGame)
  }

  func startNewGame() {
    currentGame = Game(id: games.count + 1)
    currentGame.word = getRandomWord()
    selectedID = games.count + 1
    games.append(currentGame)
  }

  func updateGamesArray() {
    let index = games.firstIndex { game in
      game.id == currentGame.id
    }
    if let index {
      games[index] = currentGame
    }
  }

  func selectGame(id: Int) {
    updateGamesArray()

    let game = games.first { game in
      game.id == id
    }
    if let game {
      currentGame = game
    }
  }

  func changeWord() {
    currentGame.word = getRandomWord()
  }

  func getRandomWord() -> String {
    guard
      let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
      let wordsList = try? String(contentsOf: url) else {
      return "SNOWMAN"
    }

    var words = wordsList.components(separatedBy: .newlines)

    if !useProperNouns {
      words = words.filter { word in
        !word.isEmpty && !word[word.startIndex].isUppercase
      }
    }

    words = words.filter { word in
      word.count >= minWordLength && word.count <= maxWordLength
    }

    let previousWords = games.map { $0.word }
    words = words.filter { word in
      !previousWords.contains(word)
    }
    if words.isEmpty {
      return "SNOWMAN"
    }

    guard let theWord = words.randomElement() else {
      return "SNOWMAN"
    }

    print(theWord)
    return theWord.uppercased()
  }
}
