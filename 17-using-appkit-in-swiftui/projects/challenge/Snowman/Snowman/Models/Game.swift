/// Copyright (c) 2026 Kodeco Inc.
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

struct Game: Identifiable {
  let id: Int

  let maxGuesses = 7
  var incorrectGuessCount = 0
  var statusText = "Enter a letter to start the game."
  var word = "SNOWMAN"
  var guesses: [String] = []
  var gameStatus = GameStatus.inProgress
  var showHint = false

  @AppStorage("minWordLength") var minWordLength = 4
  @AppStorage("maxWordLength") var maxWordLength = 10
  @AppStorage("useProperNouns") var useProperNouns = false

  var letters: [Letter] {
    var lettersArray: [Letter] = []

    for (index, char) in word.enumerated() {
      let charString = String(char)
      if guesses.contains(charString) {
        let letter = Letter(id: index, char: charString)
        lettersArray.append(letter)
      } else if gameStatus == .lost {
        let letter = Letter(id: index, char: charString, color: .red)
        lettersArray.append(letter)
      } else {
        let letter = Letter(id: index, char: "")
        lettersArray.append(letter)
      }
    }
    return lettersArray
  }

  var sidebarWord: String {
    if gameStatus == .inProgress {
      return "???"
    }
    return word
  }

  var guessesLeft: Int {
    maxGuesses - incorrectGuessCount
  }

  var hint: String? {
    if gameStatus != .inProgress || !showHint {
      return nil
    }

    if guesses.count == 0 {
      return "Starting with a vowel is always a good idea."
    }
    let numberOfVowelsGuessed = guesses.count {
      "AEIOU".contains($0)
    }
    if numberOfVowelsGuessed == 0 {
      return "Try guessing a vowel."
    } else if numberOfVowelsGuessed < 3 {
      return "Try guessing another vowel."
    }

    let commonConsonants = ["T", "N", "S", "H", "R"]
    let unusedCommons = commonConsonants.filter {
      !guesses.contains($0)
    }
    if !unusedCommons.isEmpty {
      return "These are commonly used consonants that you haven't tried yet: "
      + unusedCommons
        .joined(separator: ", ")
    }

    return "It's generally best to avoid uncommon letters like Z, Q and X."
  }

  init(id: Int) {
    self.id = id
    word = getRandomWord()
  }

  mutating func processGuess(letter: String) {
    guard
      let newGuess = letter.first?.uppercased(),
      newGuess >= "A" && newGuess <= "Z",
      !guesses.contains(newGuess)
    else {
      return
    }

    if !word.contains(newGuess) && incorrectGuessCount < maxGuesses {
      incorrectGuessCount += 1
    }
    guesses.append(newGuess)

    showHint = false

    checkForGameOver()
  }

  mutating func checkForGameOver() {
    let unmatchedLetters = word.filter { letter in
      !guesses.contains(String(letter))
    }

    if unmatchedLetters.isEmpty {
      gameStatus = .won
      statusText = "HURRAY!!!! YOU WON!"
    } else if incorrectGuessCount == maxGuesses {
      gameStatus = .lost
      statusText = "You lost. Better luck next time."
    } else {
      statusText = "Enter another letter to guess the word."
    }
  }

  func getRandomWord() -> String {
    guard
      let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
      let wordsList = try? String(contentsOf: url, encoding: .utf8)
    else {
      return "SNOWMAN"
    }

    let storedMinWordLength = minWordLength
    let storedMaxWordLength = maxWordLength
    let storedUseProperNouns = useProperNouns

    let words =
    wordsList
      .components(separatedBy: .newlines)
      .filter { word in
        word.count >= storedMinWordLength && word.count <= storedMaxWordLength
      }
      .filter { word in
        if storedUseProperNouns {
          return true
        }
        let firstLetter = word[word.startIndex]
        return !firstLetter.isUppercase
      }

    let word = words.randomElement() ?? "SNOWMAN"

    print(word)
    return word.uppercased()
  }

  mutating func chooseNewWord() {
    word = getRandomWord()
  }
}

extension Game {
  static var sampleGames: [Game] {
    var game1 = Game(id: 1)
    game1.word = "SNOWMAN"
    game1.gameStatus = .lost

    var game2 = Game(id: 2)
    game2.word = "FROST"
    game2.gameStatus = .won

    var game3 = Game(id: 3)
    game3.word = "ANTARCTICA"
    game3.gameStatus = .lost

    return [game1, game2, game3]
  }
}
