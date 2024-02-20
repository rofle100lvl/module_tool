import Foundation

enum Environment {
  static func getVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
  }
}
