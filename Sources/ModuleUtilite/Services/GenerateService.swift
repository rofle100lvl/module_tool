import Foundation
import SwiftParser
import SwiftSyntax

enum GenerateServiceError: Error, CustomStringConvertible, Equatable {
  case firstLaunchSave
  case settedVariableNotAnURL
  case pathIsNotValid

  var description: String {
    switch self {
    case .firstLaunchSave:
      "You need to launch save command first with absolute path to tuist folder."
    case .settedVariableNotAnURL:
      "It looks like setted string is not URL. Check it out. And set it With save command"
    case .pathIsNotValid:
      "Your path is not valid. Please set path to your project. Using save comand."
    }
  }
}

final class GenerateService {
  public func run(targetName: String, isFeature: Bool, podsRequired: Bool) throws {
    let source = isFeature ? Source.feature : Source.core

//    guard let urlString = Environment.getVar("Tuist_Project") else {
//      throw GenerateServiceError.firstLaunchSave
//    }

    let urlString = "/Users/rofle100lvl/arcadia/mobile/travel/ios/"

    guard let dir = URL(string: "file://" + urlString) else {
      throw GenerateServiceError.settedVariableNotAnURL
    }

    guard PathValidator.validatePath(path: urlString) else {
      throw GenerateServiceError.pathIsNotValid
    }

    try changeTuistFile(dir: dir, targetName: targetName, source: source)

    try changeProjectFile(dir: dir, targetName: targetName, source: source)

    if podsRequired {
      try changePodsFile(urlString: urlString, targetName: targetName, source: source)
    }

    try FolderService.createFolders(
      moduleName: targetName,
      source: source,
      projectURL: urlString
    )
  }

  private func changeProjectFile(dir: URL, targetName: String, source: Source) throws {
    let projectPath = dir.appending(path: Constants.projectFilePath)

    let projectFileText = try String(contentsOf: projectPath, encoding: .utf8)
    let projectRootNode: SourceFileSyntax = Parser.parse(source: projectFileText)

    let rewrittenProjectRootNode = ProjectRewriter(
      source: source,
      newModuleName: targetName
    ).rewrite(projectRootNode)

    try rewrittenProjectRootNode.description.write(to: projectPath, atomically: true, encoding: .utf8)
  }

  private func changePodsFile(urlString: String, targetName: String, source: Source) throws {
    try PodfileService(
      targetName: targetName,
      source: source,
      url: urlString.appending(Constants.podfilePath)
    )
    .addTarget()
  }

  private func changeTuistFile(dir: URL, targetName: String, source: Source) throws {
    let filePath: URL = switch source {
    case .core:
      dir.appending(path: Constants.corePath)
    case .feature:
      dir.appending(path: Constants.featuresPath)
    }

    let text = try String(contentsOf: filePath, encoding: .utf8)
    let rootNode: SourceFileSyntax = Parser.parse(source: text)

    let definitionRewriter = DefinitionRewriter(
      source: source,
      newModuleName: targetName
    ).rewrite(rootNode)

    try definitionRewriter.description.write(to: filePath, atomically: true, encoding: .utf8)
  }
}
