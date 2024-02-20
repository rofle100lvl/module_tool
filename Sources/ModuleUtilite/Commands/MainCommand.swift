import ArgumentParser

struct MainCommand: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "main",
    abstract: "A Swift CLI to manage modules",
    subcommands: [
      GenerateCommand.self,
      SavePathCommand.self,
    ]
  )
}
