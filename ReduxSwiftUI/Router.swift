//
//  File.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/22.
//

import Foundation
import Combine
import ComposableArchitecture
import SwiftUI

protocol Routable {
    var path: String { get }
    var isActive: Bool { get set }
    var childs: [Routable] { get set }
}

class BaseRouterState: Equatable, Routable {
    static func == (lhs: BaseRouterState, rhs: BaseRouterState) -> Bool {
        false
    }

    let path: String
    var isActive: Bool = false
    var childs: [Routable]
    
    init(path: String, childs: [Routable] = []) {
        self.path = path
        self.childs = childs
    }
}

struct Dependency {}

extension Array where Element: Routable {
    subscript(path: String) -> Routable? {
        self.first { $0.path == path }
    }
    
    func routable(from path: String) -> Routable? {
        self.first { $0.path == path }
    }
}
