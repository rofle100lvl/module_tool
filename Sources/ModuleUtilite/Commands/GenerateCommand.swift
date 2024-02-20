import ArgumentParser
import Foundation
import SwiftParser
import SwiftSyntax

struct GenerateCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "generate",
    abstract: "A Swift CLI to generate module.",
    version: "0.0.1"
  )

  @Flag(help: "Flag indicates should we work with Features. By default - Core targets")
  var f = false

  @Flag(help: "Flag indicates should we add new module to Podfile. By default - false")
  var pods = false

  @Argument
  var name: String

  func run() throws {
    try GenerateService()
      .run(targetName: name, isFeature: f, podsRequired: pods)
  }
}
