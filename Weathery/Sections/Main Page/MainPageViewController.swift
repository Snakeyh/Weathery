//
//  ViewController.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import UIKit

class MainPageViewController: NiblessViewController {
    
    
    // MARK: - Dependencies
    private let vm: MainPageViewModel
    
    // MARK: - UI Components
    private lazy var cityTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Search for city here"
        field.contentVerticalAlignment = .bottom
        field.adjustsFontSizeToFitWidth = true
        field.font =  UIFont(name: "Avenir", size: 40)
        field.delegate = self
        field.textColor = .black
        
        return field
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        
        return divider
    }()
        
    private lazy var loadingScreen: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.backgroundColor = .white
        loading.startAnimating()
        loading.color = .black
        
        return loading
    }()
    
    private lazy var errorScreen: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font =  UIFont(name: "Avenir", size: 60)
        temp.textColor = .black
        
        return temp
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font =  UIFont(name: "Avenir", size: 30)
        desc.textColor = .black
        
        return desc
    }()
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("More Details", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(detailsButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    init(vm: MainPageViewModel) {
        self.vm = vm
        super.init()
        
        initialSetup()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func initialSetup() {
        view.backgroundColor = .white
        cityTextField.text = vm.currentCity
        updateForNewState(state: vm.state)
        
        vm.onStateChange = { [weak self] state in
            self?.updateForNewState(state: state)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupViews() {
        view.addSubview(cityTextField)
        view.addSubview(divider)
        
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            cityTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2), 
            cityTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 8),
            divider.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),
            
            guide.topAnchor.constraint(equalTo: divider.bottomAnchor),
            guide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            detailsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            detailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(loadingScreen)
        view.addSubview(errorScreen)
        
        NSLayoutConstraint.activate([
            loadingScreen.topAnchor.constraint(equalTo: divider.bottomAnchor),
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorScreen.topAnchor.constraint(equalTo: divider.bottomAnchor),
            errorScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateForNewState(state: MainPageViewModel.State) {
        switch state {
        case .loading: 
            loadingScreen.isHidden = false
            errorScreen.isHidden = true
        case .error(let error):
            loadingScreen.isHidden = true
            errorScreen.isHidden = false
            errorScreen.text = error.localizedDescription
        case .weather:
            updateViewWithWeather()
        }
    }
    
    private func updateViewWithWeather(){
        loadingScreen.isHidden = true
        errorScreen.isHidden = true
        
        if let tempString = vm.temperatureLabel() {
            temperatureLabel.text = tempString
        }
        
        if let description = vm.descriptionLabel() {
            descriptionLabel.text = description
        }
    }
    
    @objc
    private func detailsButtonPressed() {
        guard let vm = vm.detailViewModel() else {
            return
        }
        
        self.show(DetailViewController(vm: vm), sender: self)
    }
    
}

extension MainPageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        vm.didEndEditing(with: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return false
    }
    
}

