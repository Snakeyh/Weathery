//
//  DetailViewController.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import UIKit

class DetailViewController: NiblessViewController {
    
    private let vm: DetailViewModel
    
    private lazy var averageLabel: UILabel = styledLabel()
    private lazy var medianLabel: UILabel = styledLabel()
    private lazy var maxLabel: UILabel = styledLabel()
    private lazy var minLabel: UILabel = styledLabel()
    
    
    init(vm: DetailViewModel) {
        self.vm = vm
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        setupContent()
    }
    
    private func styledLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont(name: "Avenir", size: 30)
        label.textColor = .black
        
        return label
    }
    
    private func setupViews() {
        view.addSubview(averageLabel)
        view.addSubview(medianLabel)
        view.addSubview(minLabel)
        view.addSubview(maxLabel)
        
        NSLayoutConstraint.activate([
            averageLabel.bottomAnchor.constraint(equalTo: medianLabel.topAnchor, constant: -20),
            averageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            medianLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            medianLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            
            minLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            
            maxLabel.topAnchor.constraint(equalTo: minLabel.bottomAnchor, constant: 20),
            maxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    private func setupContent() {
        title = vm.title
        
        averageLabel.text = vm.averageTemperature()
        medianLabel.text = vm.medianTemperature()
        maxLabel.text = vm.maxTemperature()
        minLabel.text = vm.minTemperature()
    }
    
}
