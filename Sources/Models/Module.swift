//
//  Module.swift
//  modulegen
//

import Foundation

struct Module: Codable {
    
    let moduleRoot: Folder
    let files: [FileModel]
    
    private enum CodingKeys: String, CodingKey {
        case moduleRoot = "module"
        case files
    }
    
    init() {
        moduleRoot = Folder()
        files = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        moduleRoot = try container.decode(Folder.self, forKey: .moduleRoot)
        files = try container.decode([FileModel].self, forKey: .files)
    }

    private func getData(meta: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)
    }
}
