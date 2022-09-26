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

// Use the jump bar above the edit pane
// to navigate to different sections of this code.

print("Hello, Swift")
print()

// MARK: - if

print("=== IF ===")

if true {
  print("This is true")
}

print("=== IF ELSE ===")

var userIsLoggedIn = true
if userIsLoggedIn {
  print("Welcome")
} else {
  print("Please log in")
}

var name = "Bob"
if name.count < 4 {
  print("\(name) is a very short name")
} else {
  print("Good name.")
}

print("=== IF ELSE IF ===")

var score = 70
if score >= 100 {
  print("You've won")
} else if score > 80 {
  print("Nearly there...")
} else {
  print("Keep going")
}

print()

// MARK: - switch

print("=== SWITCH ===")

var grade = "B"
switch grade {
case "A":
  print("Top of the class!")
case "B":
  print("Excellent work.")
case "C":
  print("Solid effort.")
case "D":
  print("Try harder next time.")
default:
  print("More effort needed.")
}

print()

// MARK: - loops

print("=== FOR ===")

for number in 1 ... 5 {
  print(number)
}

print("=== WHILE ===")

var counter = 0
while counter < 5 {
  print("Counter: \(counter)")
  counter += 1
}

print("=== REPEAT WHILE ===")

counter = 0
repeat {
  print("Counter: \(counter)")
  counter += 1
} while counter < 5

let toys = ["Andy", "Bo-peep", "Buzz", "Jessie", "Rex"]
for toy in toys {
  print(toy)
}

print()

// MARK: - functions

print("=== FUNCTION ===")

func showVersion() {
  print("swifty - version 1.0")
}
showVersion()

print("=== FUNCTION WITH INPUT ===")

func showVersion(versionNumber: Double) {
  print("swifty - version \(versionNumber)")
}
showVersion(versionNumber: 1.2)

print("=== FUNCTION WITH OUTPUT ===")

func getVersion() -> Double {
  return 1.3
}
let versionNumber = getVersion()
print("Version \(versionNumber)")

print("=== FUNCTION WITH INPUT & OUTPUT ===")

func areaOfCircle(radius: Double) -> Double {
  let area = Double.pi * radius * radius
  return area
}
let area = areaOfCircle(radius: 6)
print(area)

print()

// MARK: - optionals

print("=== UNWRAPPING OPTIONAL ===")

var mightBeNumber: Int? = 3
if let mightBeNumber {
  print(mightBeNumber)
} else {
  print("mightBeNumber is nil")
}

print("=== FORCE UNWRAPPING OPTIONAL ===")

var forcedString: String? = "This really is a string."
print(forcedString!)

print("=== GUARD LET ===")

func handlingOptionals(name: String?, age: Int?) {
  guard let name, let age else {
    print("One of the arguments is not valid")
    return
  }
  print("All input data is valid: \(name) & \(age)")
}

handlingOptionals(name: nil, age: nil)
handlingOptionals(name: "Swift", age: nil)
handlingOptionals(name: nil, age: 8)
handlingOptionals(name: "Swift", age: 8)
