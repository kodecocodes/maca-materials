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

struct Game: Identifiable, Equatable {
  var id: Int = 1
  var incorrectGuessCount = 0
  var statusText = "Enter a letter to guess the word."
  var status = GameStatus.inProgress
  var word = "SNOWMAN"
  var guesses: [String] = []

  var wordLetters: [WordLetter] {
    var letters: [WordLetter] = []
    let characters = Array(word).map { String($0) }

    for i in 0 ..< characters.count {
      if guesses.contains(characters[i]) {
        let letter = WordLetter(id: i, letter: characters[i])
        letters.append(letter)
      } else if status == .lost {
        let letter = WordLetter(id: i, letter: characters[i], color: .red)
        letters.append(letter)
      } else {
        let letter = WordLetter(id: i, letter: "")
        letters.append(letter)
      }
    }
    return letters
  }

  mutating func processGuess(_ letter: String) {
    if status != .inProgress {
      // game already finished
      return
    }

    guard
      let newGuess = letter.first?.uppercased(),
      newGuess >= "A" && newGuess <= "Z",
      !guesses.contains(newGuess) else {
      return
    }

    if !word.contains(newGuess) {
      incorrectGuessCount += 1
    }
    guesses.append(newGuess)

    checkForGameOver()
  }

  mutating func checkForGameOver() {
    let wordLetters = Array(word).map { String($0) }
    let unmatchedLetters = wordLetters.filter {
      !guesses.contains($0)
    }

    if unmatchedLetters.isEmpty {
      status = .won
      statusText = "HURRAY!!!! YOU WON!"
      return
    }

    if incorrectGuessCount == 7 {
      status = .lost
      statusText = "You lost. Better luck next time."
    }
  }

  var progressWord: String {
    if status == .inProgress {
      return "???"
    }
    return word
  }
}
