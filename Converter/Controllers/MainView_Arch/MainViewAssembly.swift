//
//  MainViewAssembly.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

extension ModuleFactory {

    static func createMainModule_Arch() -> Module<MainViewController> {
        
        let builder = MainViewScreenBuilder()
        let vc = builder.build(())
       
        return Module(presentable: vc)
    }
    
}
