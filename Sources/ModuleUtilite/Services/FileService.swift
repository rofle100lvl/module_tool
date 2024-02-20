import Foundation

protocol FileServiceProtocol {
  func findLine(line: String) -> Int?
  func insert(text: String, on line: Int) throws
}

final class FileService: FileServiceProtocol {
  private var content: String = ""
  private let fileUrl: String

  init(url: String) throws {
    self.fileUrl = url
    try readFile()
  }

  func findLine(line: String) -> Int? {
    let array = content.components(separatedBy: .newlines)
    return array.firstIndex { $0 == line }
  }

  func insert(text: String, on line: Int) throws {
    var array = content.components(separatedBy: .newlines)
    array.insert(text, at: line)
    let newContent = array.joined(separator: "\n")
    try newContent.write(toFile: fileUrl, atomically: true, encoding: .utf8)
    try readFile()
  }

  private func readFile() throws {
    content = try String(contentsOfFile: fileUrl)
  }
}
