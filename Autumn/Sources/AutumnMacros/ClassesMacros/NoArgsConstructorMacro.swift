//
//  NoArgsConstructorMacro.swift
//
//
//  Created by Данила Бондаренко on 01.05.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NoArgsConstructorMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        let initializer = try InitializerDeclSyntax(NoArgsConstructorMacro.generateInitialCode()) {
            
        }
        
        return [DeclSyntax(initializer)]
    }
    
    public static func generateInitialCode() -> SyntaxNodeString {
        var initialCode: String = "init("
        initialCode += ")"
        return SyntaxNodeString(stringLiteral: initialCode)
    }
}
