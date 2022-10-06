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

class StockItem {
  let name: String
  var numberInStock: Int

  init(name: String, numberInStock: Int) {
    self.name = name
    self.numberInStock = numberInStock
  }

  func buy(number: Int) {
    numberInStock += number
  }

  func sell(number: Int) {
    if number > numberInStock {
      numberInStock = 0
    } else {
      numberInStock -= number
    }
  }
}

var bananas = StockItem(name: "banana", numberInStock: 12)

bananas.name
bananas.numberInStock += 1
bananas

bananas.buy(number: 4)
bananas.numberInStock

bananas.sell(number: 2)
bananas.numberInStock

bananas.sell(number: 1000)
bananas.numberInStock

let apples = StockItem(name: "apple", numberInStock: 0)
let oranges = StockItem(name: "orange", numberInStock: 24)

apples.buy(number: 16)
oranges.sell(number: 3)

class SoftDrinkItem: StockItem {
  var isFizzy: Bool

  init(name: String, numberInStock: Int, isFizzy: Bool) {
    self.isFizzy = isFizzy
    super.init(name: name, numberInStock: numberInStock)
  }

  override func buy(number: Int) {
    numberInStock += number * 12
  }
}

let mineralWater = SoftDrinkItem(
  name: "Mineral water",
  numberInStock: 12,
  isFizzy: false)

mineralWater.sell(number: 3)

// mineralWater is SoftDrinkItem
// mineralWater is StockItem

var stocks = [bananas, apples, mineralWater]

mineralWater.numberInStock
mineralWater.buy(number: 2)
mineralWater.numberInStock
