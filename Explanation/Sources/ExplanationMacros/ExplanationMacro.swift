import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

// MARK: - StructInitMacro

public struct StructInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
            
            guard let structDecl = declaration.as(StructDeclSyntax.self) else {
                
                throw StructInitError.onlyApplicableToStruct
            }
            
            let members = structDecl.memberBlock.members
            let variableDecl = members.compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            let variableNames = variableDecl.compactMap({ $0.bindings.first?.pattern})
            let variablesType = variableDecl.compactMap({ $0.bindings.first?.typeAnnotation?.type})
            
            var initialParameter: String = "init("
            
            for (name, type) in zip(variableNames, variablesType) {
                
                initialParameter += "\(name): \(type), "
            }
            
            initialParameter = String(initialParameter.dropLast(2))
            initialParameter += ")"
            
            let syntaxNodeString = SyntaxNodeString(stringLiteral: initialParameter)
            let initialBody = try InitializerDeclSyntax.init(syntaxNodeString, bodyBuilder: {
                for name in variableNames {
                   ExprSyntax("self.\(name) = \(name)")
                }
            })
            
            return [DeclSyntax(initialBody)]
    }
}


// MARK: - EnumTitleMacro

public struct EnumTitleMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
            guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
                
                throw EnumInitError.onlyApplicableToEnum
            }
            
            let members = enumDecl.memberBlock.members
            let casesDecl = members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self )})
            let casesTitle = casesDecl.compactMap({ $0.elements.first?.name.text })
            
            var title: String = """
            
                var title: String {
                    switch self {
            """
            
            for caseTitle in casesTitle {
                
                title += "case .\(caseTitle):"
                title += "return \"\(caseTitle.capitalized)\""
            }
            
            title += """
               }
            }
            """
            
            return [DeclSyntax(stringLiteral: title)]
    }
}

// MARK: - URLMacro

public struct URLMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext) throws -> ExprSyntax {
            
            guard
                let argument = node.argumentList.first?.expression,
                let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
                segments.count == 1,
                case .stringSegment(let literalSegment)? = segments.first else {
                
                throw URLMacroError.requiresStaticStringLiteral
            }
            
            guard let _ = URL(string: literalSegment.content.text) else {
                throw URLMacroError.malforedURL(urlString: "\(argument)")
            }
            
            return "URL(string: \(argument))!"
    }
}


@main
struct ExplanationPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        StructInitMacro.self,
        EnumTitleMacro.self,
        URLMacro.self
    ]
}
