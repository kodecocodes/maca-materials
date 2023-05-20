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

import SwiftUI
import Charts

struct WordStats: View {
  var games: [Game]

  var body: some View {
    Chart {
      ForEach(wordStatsPoints) { point in
        // Challenge 2: Comment out the following line
        //    and un-comment a different mark type to test
        LineMark(
          //  AreaMark(
          //  PointMark(
          //  RectangleMark(
          x: .value("Game ID", point.name),
          y: .value("Word Count", point.value))
        .lineStyle(StrokeStyle(lineWidth: 4))
        .symbol(.diamond)
        .symbolSize(200)
        .foregroundStyle(lineChartColor)
        .accessibilityLabel("Game \(point.name)")
        .accessibilityValue("had \(point.value) letters in the word")
      }
      RuleMark(y: .value("Average", 7.5))
    }
    .chartYScale(domain: .automatic(includesZero: false))
    .frame(minWidth: 250, minHeight: 300)
    .padding()
  }

  var wordCountReport: String {
    let completedGames = games.filter {
      $0.gameStatus != .inProgress
    }

    let gameReports = completedGames.map { game in
      let statusText = game.gameStatus == .won ? "won" : "lost"
      return "\(game.id): \(game.word.count) letters - \(statusText)"
    }

    return gameReports.joined(separator: "\n")
  }

  var wordStatsPoints: [ChartPoint] {
    let completedGames = games.filter { game in
      game.gameStatus != .inProgress
    }

    let chartPoints = completedGames.map { game in
      ChartPoint(
        name: "#\(game.id)",
        value: game.word.count)
    }

    return chartPoints
  }

  var lineChartColor: Color {
    let wonGamesCount = games.filter {
      $0.gameStatus == .won
    }.count
    let lostGamesCount = games.filter {
      $0.gameStatus == .lost
    }.count

    if wonGamesCount > lostGamesCount {
      return .green
    } else if wonGamesCount < lostGamesCount {
      return .orange
    }

    return .blue
  }
}

struct WordStats_Previews: PreviewProvider {
  static var previews: some View {
    WordStats(games: Game.sampleGames)
  }
}
