//
//  PathValidator.swift
//
//
//  Created by Roman Gorbenko on 04.01.2024.
//

import Foundation

enum PathValidator {
  static func validatePath(path: String) -> Bool {
    var isDir = ObjCBool(true)

    let filesShouldBePresented = [
      path.appending(Constants.projectFilePath),
      path.appending(Constants.podfilePath),
      path.appending(Constants.corePath),
      path.appending(Constants.featuresPath),
    ]

    let foldersShouldBePresented = [
      path.appending(Constants.targetsFolderPath),
    ]

    return filesShouldBePresented.allSatisfy {
      FileManager.default.fileExists(atPath: $0)
    } && foldersShouldBePresented.allSatisfy {
      FileManager.default.fileExists(atPath: $0, isDirectory: &isDir)
    }
  }
}
