import ArgumentParser
import Foundation

enum SavePathError: Error, CustomStringConvertible {
  case environmentVariableSetError

  var description: String {
    switch self {
    case .environmentVariableSetError:
      "Setting environment variable wasn't successful. Tru to set path to \"Tuist_Project\" variable by yourself "
    }
  }
}

struct SavePathCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "save",
    abstract: "A Swift CLI to save path to the project.",
    version: "0.0.1"
  )

  @Argument
  var path: String

  func run() throws {
    guard PathValidator.validatePath(path: path) else {
      fatalError("Path should be valid directory and should contains TravelApp project")
    }

    let setResult = setenv("Tuist_Project", path, 1)

    switch setResult {
    case -1:
      throw SavePathError.environmentVariableSetError
    default:
      break
    }
  }
}
