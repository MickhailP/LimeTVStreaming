//
//  Mockable.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 13.12.2022.
//

import Foundation

protocol Mockable: AnyObject {
    
    var bundle: Bundle { get }
    func loadJSON(filename: String) -> Result<Data, Error>
}

extension Mockable {
    var bundle: Bundle {
        return  Bundle(for: type(of: self))
    }
    func loadJSON(filename: String) -> Result<Data, Error> {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else { fatalError("Failed to load JSON file from bundle")}
        
        do {
            let data = try Data(contentsOf: path)
            return .success(data)
        } catch  {
            return .failure(error)
        }
    }
}
