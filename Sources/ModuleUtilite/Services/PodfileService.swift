import Foundation

struct PodfileService: ~Copyable {
  private let targetName: String
  private let url: String
  private let source: Source

  init(targetName: String, source: Source, url: String) {
    self.targetName = targetName
    self.url = url
    self.source = source
  }

  func addTarget() throws {
    let service = try FileService(url: url)
    let line = service.findLine(line: Constants.stringToInsert)
    guard let line else { return }
    try service.insert(text: targetDeclaration(), on: line + Constants.linePlusToInsert)
  }

  private func targetDeclaration() -> String {
    switch source {
    case .core:
      targetDeclarationString(name: targetName.capitalizingFirstLetter())
    case .feature:
      targetDeclarationString(name: targetName.capitalizingFirstLetter() + "Impl")
    }
  }
}

private extension PodfileService {
  enum Constants {
    static let stringToInsert = "target 'Travel' do"
    static let linePlusToInsert = 3
  }

  func targetDeclarationString(name: String) -> String {
    """
      target 'T\(name)' do
        inherit! :search_paths
      end

    """
  }
}
