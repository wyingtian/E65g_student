//
//  GridProtocol.swift
//  Assignment4
//
//  Created by Ying on 3/29/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

public struct GridPosition: Equatable{
    var row: Int
    var col: Int
    
    public static func == (lhs: GridPosition, rhs: GridPosition) -> Bool{
        return (lhs.row == rhs.row && lhs.col == rhs.col)
    }
}

public struct GridSize{
    var rows: Int
    var cols: Int
}

public enum CellState: String {
    case alive = "alive"
    case empty = "empty"
    case born = "born"
    case died = "died"
    public func description() -> String {
        switch self{
        case .alive:
            return rawValue
        case .empty:
            return rawValue
        case .born:
            return rawValue
        case .died:
            return rawValue
        }
    }
    public func allValues() -> Array<String>{
        return ["alive", "empty", "born", "died"]
    }
    public func toggle(_ value: CellState) -> CellState{
        switch value{
        case .alive, .born:
            return .empty
        case .died, .empty:
            return .alive
        }
    }
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}

public protocol GridViewDataSource {
    subscript (pos: Position) -> CellState {get set}
}

//public protocol GridProtocol: CustomStringConvertible{
//    init(_ size: GridSize, cellInitializer:(GridPosition) -> CellState)
//    var size: GridSize {get}
//    subscript (row:Int, col:Int) -> CellState {get set}
//    func next() -> Self
//}
