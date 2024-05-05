//
//  AllArgsConstructorMacro.swift
//  
//
//  Created by Данила Бондаренко on 01.05.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AllArgsConstructorMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(ClassDeclSyntax.self) else {
           throw StructInitError.onlyApplicableToStruct
        }
           
        let members = structDecl.memberBlock.members
        let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let variablesName = variableDecl.compactMap { $0.bindings.first?.pattern }
        let variablesType = variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }

        let initializer = try InitializerDeclSyntax(AllArgsConstructorMacro.generateInitialCode(variablesName: variablesName, variablesType:variablesType)) {
            for name in variablesName {
                ExprSyntax("self.\(name) = \(name)")
            }
        }
        return [DeclSyntax(initializer)]
    }
    
    public static func generateInitialCode(variablesName: [PatternSyntax],
                                           variablesType: [TypeSyntax]) -> SyntaxNodeString {
        var initialCode: String = "init("
        for (name, type) in zip(variablesName, variablesType) {
            initialCode += "\(name): \(type), "
        }
        initialCode = String(initialCode.dropLast(2))
        initialCode += ")"
        return SyntaxNodeString(stringLiteral: initialCode)
    }
}
