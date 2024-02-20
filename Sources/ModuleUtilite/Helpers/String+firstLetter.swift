import Foundation

extension String {
  func capitalizingFirstLetter() -> String {
    let first = String(self.prefix(1)).capitalized
    let other = String(self.dropFirst())
    return first + other
  }

  func loweringFirstLetter() -> String {
    let first = String(self.prefix(1)).lowercased()
    let other = String(self.dropFirst())
    return first + other
  }
}
