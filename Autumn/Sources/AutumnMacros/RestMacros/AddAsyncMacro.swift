//
//  AddAsyncMacro.swift
//  
//
//  Created by Данила Бондаренко on 01.05.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct AddAsyncMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        guard let macroAttributes = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw StructInitError.onlyApplicableToStruct
        }
        guard let url = macroAttributes
            .filter({ $0.label?.text == "url"})
            .first?.expression.as(StringLiteralExprSyntax.self)?
            .segments.first?.as(StringSegmentSyntax.self)?
            .content.text
        else {
            throw StructInitError.onlyApplicableToStruct
        }
        
        guard let funName = macroAttributes
            .filter({ $0.label?.text == "requestName"})
            .first?.expression.as(StringLiteralExprSyntax.self)?
            .segments.first?.as(StringSegmentSyntax.self)?
            .content.text else {
            throw StructInitError.onlyApplicableToStruct
        }
        
        guard let typeOfCoding = macroAttributes
            .filter({$0.label?.text == "returnType"})
            .first?.expression.as(MemberAccessExprSyntax.self)?
            .base?.as(DeclReferenceExprSyntax.self)?
            .baseName.text
        else {
            throw StructInitError.onlyApplicableToStruct
        }
        let funcDecls = try makeRequest(funcName: funName, url: url, typeOfCoding: typeOfCoding)
                
        return [DeclSyntax(funcDecls)]
    }
    
    public static func makeRequest(funcName: String, url: String, typeOfCoding: String) throws -> FunctionDeclSyntax {
        let funcDecl = try FunctionDeclSyntax(makeParametersFuc(funcName: funcName, url: url, typeOfCoding: typeOfCoding))
        let newF = funcDecl.with(
            \.body,
             CodeBlockSyntax(
                leftBrace: .leftBraceToken(leadingTrivia: .newline),
                statements: [CodeBlockItemSyntax(item: .expr(makeBody(url: url, typeOfCoding: typeOfCoding)))],
                rightBrace: .rightBraceToken(leadingTrivia: .newline)
             )
        )
        return newF
    }
    
    public static func makeParametersFuc(funcName: String, url: String, typeOfCoding: String) -> SyntaxNodeString {
        let startDecl = "func \(funcName)(_ completion: @escaping (Result<\(typeOfCoding), NetworkError>) -> Void)"
        
        return SyntaxNodeString(stringLiteral: startDecl)
    }
    
    public static func makeBody(url: String, typeOfCoding: String) -> ExprSyntax {
        let bodyFunc: ExprSyntax =
        """
            guard let url = URL(string: "\(raw: url)") else {
                return
            }
            
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
                if let error = error {
                    completion(.failure(NetworkError.fail))
                }
                
                if let data  {
                    do {
                        let decodedData = try JSONDecoder().decode(\(raw: typeOfCoding).self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(NetworkError.fail))
                    }
                    
                }
                completion(.failure(NetworkError.fail))
            }.resume()
        """
        
        return bodyFunc
    }
}
