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

protocol StockItemProtocol {
  var name: String { get }
  var numberInStock: Int { get set }

  mutating func buy(number: Int)
  mutating func sell(number: Int)
}

struct StockItem: StockItemProtocol {
  var name: String
  var numberInStock: Int
}

var mangos = StockItem(name: "mango", numberInStock: 5)

mangos.buy(number: 3)
mangos.sell(number: 1)
mangos.numberInStock

struct SoftDrinkItem: StockItemProtocol {
  var name: String
  var numberInStock: Int
  var isFizzy: Bool

  mutating func buy(number: Int) {
    numberInStock += number * 12
  }
}

var lemonades = SoftDrinkItem(
  name: "lemonade",
  numberInStock: 24,
  isFizzy: true)

var stocks: [StockItemProtocol] = [mangos, lemonades]

extension StockItemProtocol {
  mutating func buy(number: Int) {
    numberInStock += number
  }

  mutating func sell(number: Int) {
    numberInStock -= number
  }
}

mangos.numberInStock = 0
mangos.buy(number: 2)
mangos.sell(number: 1)
mangos.numberInStock

lemonades.numberInStock = 0
lemonades.buy(number: 1)
lemonades.sell(number: 1)
lemonades.numberInStock
