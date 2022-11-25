/// Copyright (c) 2023 Kodeco LLC
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
import Charts

struct GameStats: View {
  var games: [Game]

  var body: some View {
    Chart(gameStatsPoints) { point in
      BarMark(
        // Challenge 1: vertical bars
        x: .value("Name", point.name),
        y: .value("Count", point.value)
      )
      .foregroundStyle(by: .value("Name", point.name))
      .annotation(
        position: .overlay,
        // Challenge 1: move annotation
        alignment: .bottom,
        spacing: 20) {
          Text("\(point.name): \(point.value)")
            .font(.title2)
      }
    }
    .chartForegroundStyleScale([
      "Wins": Color.green.gradient,
      "Losses": Color.orange.gradient
    ])
    .frame(minWidth: 250, minHeight: 300)
    .padding()
    .shadow(radius: 5, x: 5, y: 5)
    .chartLegend(.hidden)
  }

  var gameReport: String {
    let wonGames = games.filter {
      $0.gameStatus == .won
    }
    let lostGames = games.filter {
      $0.gameStatus == .lost
    }

    return """
    Games won: \(wonGames.count)
    Games lost: \(lostGames.count)
    """
  }

  var gameStatsPoints: [ChartPoint] {
    let wonGames = games.filter {
      $0.gameStatus == .won
    }
    let lostGames = games.filter {
      $0.gameStatus == .lost
    }

    let chartPoints = [
      ChartPoint(name: "Wins", value: wonGames.count),
      ChartPoint(name: "Losses", value: lostGames.count)
    ]

    return chartPoints
  }
}

struct GameStats_Previews: PreviewProvider {
  static var previews: some View {
    GameStats(games: Game.sampleGames)
  }
}
