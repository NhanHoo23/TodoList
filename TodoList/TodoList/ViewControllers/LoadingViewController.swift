//
//  LoadingViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK

//MARK: Init and Variables
class LoadingViewController: UIViewController {

    //Variables
}

//MARK: Lifecycle
extension LoadingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension LoadingViewController {
    private func setupView() {
        
    }
}

