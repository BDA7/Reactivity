//
//  ViewModelProtocol.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 27.04.2024.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
