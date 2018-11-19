//
//  IProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IProfileInteractor {
    func setup()
    var delegate: ProfileInteractorDelegate? { get set }
}
