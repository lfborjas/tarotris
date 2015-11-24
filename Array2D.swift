//
//  Array2D.swift
//  Tarotris
//
//  Created by Luis Borjas on 11/23/15.
//  Copyright © 2015 Luis Borjas. All rights reserved.
//

//FIXME: added by XCode while generating the file
//import Foundation

class Array2D<T> {

    let columns: Int
    let rows: Int
    
    var array: Array<T?>
    
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get{
            return array[(row * columns) + column]
        }
        set(newValue){
            array[(row * columns) + column] = newValue
        }
    }

}
