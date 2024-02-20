import SwiftSyntax

enum Source {
  case core
  case feature

  var name: String {
    switch self {
    case .core:
      "Target"
    case .feature:
      "MicroFeature"
    }
  }
}

final class DefinitionRewriter: SyntaxRewriter {
  let source: Source
  let newModuleName: String

  init(
    source: Source,
    newModuleName: String
  ) {
    self.newModuleName = newModuleName
    self.source = source
  }

  override func visit(_ node: MemberBlockItemListSyntax) -> MemberBlockItemListSyntax {
    guard let parent = node.parent,
          let grandParanet = parent.parent,
          let extentionDecl = ExtensionDeclSyntax(grandParanet),
          let identifierDecl = IdentifierTypeSyntax(extentionDecl.extendedType),
          identifierDecl.name.text == source.name
    else {
      return node
    }

    var children = node.children(viewMode: .all).compactMap {
      MemberBlockItemSyntax($0)
    }

    if let lastChild = children.popLast() {
      children.append(lastChild.with(\.trailingTrivia, .newlines(2)))
    }

    let newModule: MemberBlockItemSyntax = switch source {
    case .core:
      ModuleFactory.createCoreModule(module: newModuleName)
    case .feature:
      ModuleFactory.createFeatureModule(module: newModuleName)
    }

    children.append(newModule)

    return MemberBlockItemListSyntax(children)
  }
}
