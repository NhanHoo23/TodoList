//
//  LoadingViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MiTu

//MARK: Init and Variables
class LoadingViewController: UIViewController {

    //Variables
    let imgView = UIImageView()
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
        self.nextScreen()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension LoadingViewController {
    private func setupView() {
        view.backgroundColor = Color.mainBackground
        
        imgView >>> view >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(maxWidth * 0.3)
                $0.height.equalTo(imgView.snp.width).multipliedBy(1)
            }
            $0.image = UIImage(named: "img_splash")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func nextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0
            }, completion: {_ in
                self.navigationController?.push(TaskListViewController(), transitionType: .fade)
            })
        })
    }
}

