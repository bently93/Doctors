//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import EasyDi

class DoctorsViewModelAssembly: Assembly {
    private lazy var serviceAssembly: ServicesAssembly = self.context.assembly()

    func getDoctorsViewModel(speciality: Speciality)-> DoctorsViewModelProtocol {
        return define(init: DoctorsViewModel(speciality: speciality,
                doctorsService: self.serviceAssembly.doctorsService))
    }
}

class DoctorsViewAssembly: Assembly {
    private lazy var viewModelAssembly: DoctorsViewModelAssembly = self.context.assembly()

    func inject(into vc: DoctorsViewController, speciality: Speciality) {
        defineInjection(into: vc) {
            $0.viewModel = self.viewModelAssembly.getDoctorsViewModel(speciality: speciality)
            return $0
        }
    }
}
