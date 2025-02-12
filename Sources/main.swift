//
// main.swift
// modulegen
//

import ArgumentParser
import Foundation

struct Modulegen: ParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "A Swift CLI tool for generate cocoapods modules.",
        version: "0.0.1"
    )
    
    @Argument(help: "Name of the module, e.g. \"feature-weather\"")
    var moduleName: String
    
    @Argument(help: "Prefix name of the source file, e.g. \"FeatureWeather\" for \"FeatureWeatherViewController\"")
    var fileName: String
    
    @Flag(wrappedValue: false, help: "Determines the SwiftUI template, default is false")
    var sui: Bool
    
    @Flag(wrappedValue: false, help: "Determines the template without KMP ViewModel, default is false")
    var novm: Bool
    
    func run() throws {
        let generator = Generator(
            moduleName: moduleName,
            fileName: fileName,
            sui: sui,
            noVm: novm
        )
        
        generator.generate()
    }
}

Modulegen.main()
