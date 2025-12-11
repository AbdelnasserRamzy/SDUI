////
////  NavigationController.swift
////  iosApp
////
////  Created by Shrouk Yasser on 10/12/2025.
////
//
//import UIKit.UINavigationController
//
//final class NavigationController: UINavigationController, UINavigationBarDelegate {
//    // MARK: - SubViews
//    private let backgroundView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        view.backgroundColor = .black
//
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        view.layer.shadowColor = UIColor(.white).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowOpacity = 0.1
//        view.layer.masksToBounds = false
//        return view
//    }()
//    
//    private let backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("", for: .normal)
//        button.setImage(.checkmark, for: .normal)
//        button.addTarget(
//            NavigationController.self,
//            action: #selector(backButtonTapped),
//            for: .touchUpInside
//        )
//        return button
//    }()
//    
//    // MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupTheme()
//        self.interactivePopGestureRecognizer?.delegate = nil
//    }
//    
//    // MARK: - Base Functions
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        super.pushViewController(viewController, animated: animated)
//        addBackButton(to: viewController)
//    }
//    
//    // MARK: - Config Functions
//    private func setupTheme() {
//        if let navigationBarSuperview = navigationBar.superview {
//            navigationBarSuperview.insertSubview(backgroundView, belowSubview: navigationBar)
//            NSLayoutConstraint.activate([
//                backgroundView.leadingAnchor.constraint(equalTo: navigationBarSuperview.leadingAnchor),
//                backgroundView.trailingAnchor.constraint(equalTo: navigationBarSuperview.trailingAnchor),
//                backgroundView.topAnchor.constraint(equalTo: navigationBarSuperview.topAnchor),
//                backgroundView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
//            ])
//        }
//        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .clear
//        
//        
//        navigationBar.setBackgroundImage(UIImage(), for:.default)
//        navigationBar.shadowImage = UIImage()
//        navigationBar.standardAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//        navigationBar.compactAppearance = appearance
//        navigationBar.tintColor = .yellow
//        navigationBar.layoutIfNeeded()
//    }
//    
//    private func addBackButton(to viewController: UIViewController) {
//        guard viewControllers.count > 1 else { return }
//        
//        let backButtonContainer = UIView()
//        backButtonContainer.addSubview(backButton)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: backButtonContainer.leadingAnchor, constant: 10),
//            backButton.trailingAnchor.constraint(equalTo: backButtonContainer.trailingAnchor),
//            backButton.topAnchor.constraint(equalTo: backButtonContainer.topAnchor),
//            backButton.bottomAnchor.constraint(equalTo: backButtonContainer.bottomAnchor)
//        ])
//        
//        let backBarButtonItem = UIBarButtonItem(customView: backButtonContainer)
//        viewController.navigationItem.leftBarButtonItem = backBarButtonItem
//    }
//    
//    // MARK: - Actions
//    @objc private func backButtonTapped() {
//        popViewController(animated: true)
//    }
//}
