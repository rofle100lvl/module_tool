import SwiftSyntax

final class ProjectRewriter: SyntaxRewriter {
  let source: Source
  let newModuleName: String

  init(
    source: Source,
    newModuleName: String
  ) {
    self.newModuleName = newModuleName
    self.source = source
  }

  override func visit(_ node: PatternBindingSyntax) -> PatternBindingSyntax {
    switch source {
    case .core:
      if let identifierPattern = node.pattern.as(IdentifierPatternSyntax.self),
         identifierPattern.identifier.text == "baseTargets" {
        return super.visit(node)
      }
    case .feature:
      if let identifierPattern = node.pattern.as(IdentifierPatternSyntax.self),
         identifierPattern.identifier.text == "features" {
        return super.visit(node)
      }
    }
    return node
  }

  override func visit(_ node: ArrayElementListSyntax) -> ArrayElementListSyntax {
    var arguments = node.map { $0 }
    var newElement = ArrayElementSyntax(
      expression: MemberAccessExprSyntax(
        leadingTrivia: .newline.merging(.spaces(2)),
        name: .identifier(newModuleName.loweringFirstLetter())
      )
    )
    newElement.trailingComma = .commaToken()
    arguments.append(newElement)
    return ArrayElementListSyntax(arrayLiteral: arguments)
  }
}

public extension SyntaxCollection {
  init(arrayLiteral elements: [Element]) {
    self.init(elements)
  }
}
