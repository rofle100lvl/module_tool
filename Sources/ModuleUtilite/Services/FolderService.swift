import Foundation

enum FolderServiceError: Error, CustomStringConvertible {
  case fileNotCreated(String)

  var description: String {
    switch self {
    case let .fileNotCreated(path):
      "File at path: \(path) was not created"
    }
  }
}

enum FolderService {
  static func createFolders(moduleName: String, source: Source, projectURL: String) throws {
    var filesShouldBeCreated: [String] = []
    var foldersShouldBeCreated: [String] = []

    switch source {
    case .core:
      filesShouldBeCreated = [
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.coreSourcesFolder)/Source.swift",
      ]
      foldersShouldBeCreated = [
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.coreSourcesFolder)",
      ]
    case .feature:
      filesShouldBeCreated = [
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.apiSourcesFolder)/API.swift",
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.implSourcesFolder)/Impl.swift",
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.unitTestSourcesFolder)/Tests.swift",
      ]
      foldersShouldBeCreated = [
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.apiSourcesFolder)",
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.implSourcesFolder)",
        projectURL + "Targets/\(moduleName.capitalizingFirstLetter())\(Constants.unitTestSourcesFolder)",
      ]
    }

    try foldersShouldBeCreated.forEach {
      try FileManager.default.createDirectory(atPath: $0, withIntermediateDirectories: true)
    }

    try filesShouldBeCreated.forEach { file in
      if !FileManager.default.createFile(atPath: file, contents: nil, attributes: nil) {
        throw FolderServiceError.fileNotCreated(file)
      }
    }
  }
}

private extension FolderService {
  enum Constants {
    static let coreSourcesFolder = "/Sources"
    static let apiSourcesFolder = "/API/Sources"
    static let implSourcesFolder = "/Impl/Sources"
    static let unitTestSourcesFolder = "/UnitTests/Sources"
  }
}
