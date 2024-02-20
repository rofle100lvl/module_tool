import Foundation
import SwiftSyntax

enum ModuleFactory {
  static func createCoreModule(module: String) -> MemberBlockItemSyntax {
    createCoreModule(
      moduleName: module.loweringFirstLetter(),
      moduleType: module.capitalizingFirstLetter()
    )
  }

  static func createFeatureModule(module: String) -> MemberBlockItemSyntax {
    createFeatureModule(
      moduleName: module.loweringFirstLetter(),
      moduleType: module.capitalizingFirstLetter()
    )
  }

  private static func createFeatureModule(moduleName: String, moduleType: String) -> MemberBlockItemSyntax {
    MemberBlockItemSyntax(
      decl: VariableDeclSyntax(
        leadingTrivia: .spaces(2),
        modifiers: DeclModifierListSyntax([
          DeclModifierSyntax(name: .keyword(.static), trailingTrivia: .space),
        ]),
        bindingSpecifier: .keyword(.let, trailingTrivia: .space),
        bindings: PatternBindingListSyntax([
          PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(identifier: .identifier(moduleName, trailingTrivia: .space)),
            initializer: InitializerClauseSyntax(
              equal: .equalToken(trailingTrivia: .space),
              value: FunctionCallExprSyntax(
                calledExpression: DeclReferenceExprSyntax(baseName: .identifier("MicroFeature")),
                leftParen: .leftParenToken(trailingTrivia: .newline),
                arguments: createFeatureModuleArgumentsList(moduleName: moduleName, moduleType: moduleType),
                rightParen: .rightParenToken(leadingTrivia: .newline.merging(.spaces(2)))
              )
            )
          ),
        ])
      )
    )
  }

  private static func createFeatureModuleArgumentsList(
    moduleName: String,
    moduleType: String
  ) -> LabeledExprListSyntax {
    LabeledExprListSyntax([
      LabeledExprSyntax(
        leadingTrivia: .spaces(4),
        label: .identifier("layer"),
        colon: .colonToken(trailingTrivia: .space),
        expression: MemberAccessExprSyntax(
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: .identifier("feature"))
        ),
        trailingComma: .commaToken(trailingTrivia: .newline)
      ),
      LabeledExprSyntax(
        leadingTrivia: .spaces(4),
        label: .identifier("name"),
        colon: .colonToken(trailingTrivia: .space),
        expression: StringLiteralExprSyntax(
          openingQuote: .stringQuoteToken(),
          segments: StringLiteralSegmentListSyntax([
            StringLiteralSegmentListSyntax.Element.stringSegment(
              StringSegmentSyntax(content: .identifier(moduleType))
            ),
          ]),
          closingQuote: .stringQuoteToken()
        ),

        trailingComma: .commaToken(trailingTrivia: .newline)
      ),
      LabeledExprSyntax(
        leadingTrivia: .spaces(4),
        label: .identifier("apiDependenciesBuilder"),
        colon: .colonToken(trailingTrivia: .space),
        expression: FunctionCallExprSyntax(
          calledExpression: DeclReferenceExprSyntax(baseName: .identifier("DependenciesBuilder")),
          leftParen: .leftParenToken(),
          arguments: LabeledExprListSyntax(),
          rightParen: .rightParenToken()
        ),
        trailingComma: .commaToken(trailingTrivia: .newline)
      ),
      LabeledExprSyntax(
        leadingTrivia: .spaces(4),
        label: .identifier("implDependenciesBuilder"),
        colon: .colonToken(trailingTrivia: .space),
        expression: FunctionCallExprSyntax(
          calledExpression: DeclReferenceExprSyntax(baseName: .identifier("DependenciesBuilder")),
          leftParen: .leftParenToken(),
          arguments: LabeledExprListSyntax(),
          rightParen: .rightParenToken()
        )
      ),
    ])
  }

  private static func createCoreModule(moduleName: String, moduleType: String) -> MemberBlockItemSyntax {
    MemberBlockItemSyntax(
      decl: VariableDeclSyntax(
        leadingTrivia: .spaces(2),
        attributes: AttributeListSyntax(),
        modifiers: DeclModifierListSyntax(
          [
            DeclModifierSyntax(name: .keyword(.static), trailingTrivia: .space),
          ]
        ),
        bindingSpecifier: .keyword(.let, trailingTrivia: .space),
        bindings: PatternBindingListSyntax(
          [
            PatternBindingSyntax(
              pattern: IdentifierPatternSyntax(
                identifier: TokenSyntax(
                  .identifier(moduleName),
                  trailingTrivia: .space,
                  presence: .present
                )
              ),
              initializer: InitializerClauseSyntax(
                equal: TokenSyntax.equalToken(trailingTrivia: .space),
                value: FunctionCallExprSyntax(
                  calledExpression: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(
                      baseName: .identifier("Target")
                    ),
                    period: .periodToken(),
                    declName: DeclReferenceExprSyntax(
                      baseName: .identifier("coreTarget")
                    )
                  ),
                  leftParen: .leftParenToken(),
                  arguments: createCoreModuleArgumentsList(moduleType: moduleType),
                  rightParen: .rightParenToken()
                )
              )
            ),
          ]
        )
      )
    )
  }

  private static func createCoreModuleArgumentsList(moduleType: String) -> LabeledExprListSyntax {
    LabeledExprListSyntax(
      [
        LabeledExprSyntax(
          label: TokenSyntax.identifier("name"),
          colon: TokenSyntax.colonToken(trailingTrivia: .space),
          expression: StringLiteralExprSyntax(
            openingQuote: TokenSyntax.stringQuoteToken(),
            segments: StringLiteralSegmentListSyntax(
              [
                StringLiteralSegmentListSyntax.Element.stringSegment(
                  StringSegmentSyntax(
                    content: TokenSyntax(
                      .stringSegment(moduleType),
                      presence: .present
                    )
                  )
                ),
              ]
            ),
            closingQuote: TokenSyntax.stringQuoteToken()
          )
        ),
      ]
    )
  }
}
