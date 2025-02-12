//
//  File.swift
//  modulegen
//

import Foundation

final class Generator {
    
    private let fileManager = FileManager.default
    
    private var hasError: Bool = false
    
    private var moduleName: String
    private var fileName: String
    private var sui: Bool
    private var noVm: Bool
    
    init(
        moduleName: String,
        fileName: String,
        sui: Bool,
        noVm: Bool
    ) {
        self.moduleName = moduleName
        self.fileName = fileName
        self.sui = sui
        self.noVm = noVm
    }
    
    func generate() {
        guard let module = getModuleRootFromJSON()
        else {
            handleError("Failed to get module object from JSON")
            return
        }
        
        let currentDirectoryPath = fileManager.currentDirectoryPath
        let moduleName = module.moduleRoot.name ?? moduleName
        let moduleMainFolderPath = "\(currentDirectoryPath)/\(moduleName)"
        
        // проверка на существование директории модуля
        guard !fileManager.fileExists(atPath: moduleMainFolderPath)
        else {
            handleError("Error: folder \"\(moduleName)\" already exists")
            return
        }
        
        // проверка на существование файлов в корне — podspec
        var testFileNameWithExtension = ""
        guard module.files.contains(where: { file in
            let newFileName = getFileName(file: file)
            testFileNameWithExtension = "\(newFileName).\(file.fileExtension.rawValue)"
            let creatingFilePath = "\(currentDirectoryPath)/\(testFileNameWithExtension)"
            
            return !fileManager.fileExists(atPath: creatingFilePath)
        })
        else {
            handleError("Error: file \"\(testFileNameWithExtension)\" already exists")
            return
        }
        
        // создание корневых файлов — podspec
        module.files.forEach { file in
            createFile(file: file, dirPath: currentDirectoryPath, fileManager: fileManager)
        }
        
        handleFolder(
            rootFolder: module.moduleRoot,
            directoryToWrite: moduleMainFolderPath,
            fileManager: fileManager
        )
        
        if !hasError {
            print("\nModule \"\(moduleName)\" has been created successfully\n".green)
        }
    }
    
    private func getModuleStructureFileName() -> String {
        if sui {
            if noVm {
                return ModuleStructureType.suiNoVmModule.rawValue
            }
            return ModuleStructureType.suiModule.rawValue
        }
        
        if noVm {
            return ModuleStructureType.noVmModule.rawValue
        }
        
        return ModuleStructureType.defaultModule.rawValue
    }
    
    private func handleFolder(
        rootFolder: Folder,
        directoryToWrite: String,
        fileManager: FileManager
    ) {
        do {
            try fileManager.createDirectory(
                atPath: directoryToWrite,
                withIntermediateDirectories: false
            )
        } catch {
            handleError("Failed to create directory \(directoryToWrite)")
            return
        }
        
        rootFolder.files.forEach { file in
            createFile(file: file, dirPath: directoryToWrite, fileManager: fileManager)
        }
        
        rootFolder.folders.forEach { folder in
            handleFolder(
                rootFolder: folder,
                directoryToWrite: "\(directoryToWrite)/\(folder.name ?? moduleName)",
                fileManager: fileManager
            )
        }
    }
    
    private func getFileName(file: FileModel) -> String {
        var newFileName: String
        if let fixedFileName = file.type.fixedFileName {
            newFileName = fixedFileName
        } else {
            if let fileNamePostfix = file.type.fileNamePostfix {
                newFileName = fileName + fileNamePostfix
            } else {
                newFileName = moduleName
            }
            if let fileNamePrefix = file.type.fileNamePrefix {
                newFileName = fileNamePrefix + newFileName
            }
        }
        return newFileName
    }
    
    private func createFile(file: FileModel, dirPath: String, fileManager: FileManager) {
        let newFileName = getFileName(file: file)
        let fileNameWithExtension = "\(newFileName).\(file.fileExtension.rawValue)"
        let creatingFilePath = "\(dirPath)/\(fileNameWithExtension)"
        
        guard !fileManager.fileExists(atPath: creatingFilePath)
        else {
            handleError("Error: file \"\(fileNameWithExtension)\" already exists")
            return
        }
        
        let data = getTemplateFileData(
            templateFile: file.type.templateFileName,
            fileExtension: "txt"
        )
        
        fileManager.createFile(atPath: creatingFilePath, contents: data)
    }
    
    private func getModuleRootFromJSON() -> Module? {
        let fileName = getModuleStructureFileName()
        do {
            guard let bundlePath = Bundle.module.path(forResource: fileName, ofType: "json"),
                  let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            else {
                handleError("Failed to get data from module structure file \(fileName).json")
                return nil
            }
            
            return try JSONDecoder().decode(Module.self, from: jsonData)
        } catch {
            handleError("Failed to parse module object from json: \(error)")
            return nil
        }
    }
    
    private func getTemplateFileData(
        templateFile: String,
        fileExtension: String
    ) -> Data? {
        do {
            guard let bundlePath = Bundle.module.path(forResource: templateFile, ofType: fileExtension)
            else {
                handleError("Failed to get template file path \(templateFile).\(fileExtension)")
                return nil
            }
            return try String(contentsOfFile: bundlePath)
                .replaceTemplateSubstrings(fileNamePrefix: fileName, moduleName: moduleName)
                .data(using: .utf8)
        } catch {
            handleError("Failed to get data from template file \"\(templateFile)\": \(error)")
            return nil
        }
    }
    
    private func handleError(_ text: String) {
        print(text.red)
        hasError = true
    }
}
