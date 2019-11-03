//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import EasyDi

class MainViewModelAssembly: Assembly {
    private lazy var serviceAssembly: ServicesAssembly = self.context.assembly()

    var mainViewModel: MainViewModelProtocol {
        return define(init: MainViewModel(doctorsService: self.serviceAssembly.doctorsService))
    }
}

class MainViewAssembly: Assembly {
    private lazy var viewModelAssembly: MainViewModelAssembly = self.context.assembly()

    func inject(into vc: MainViewController) {
        defineInjection(into: vc) {
            $0.viewModel = self.viewModelAssembly.mainViewModel
            return $0
        }
    }
}
