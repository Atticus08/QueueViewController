//
//  ViewController.swift
//  QueueViewController
//
//  Created by Atticus on 12/11/17.
//  Copyright © 2017 Atticus08. All rights reserved.
//

import UIKit
class ViewController: QueueViewController<UIImageView>, QueueViewControllerDelegate {
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    let thirdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .purple
        return imageView
    }()
    
    let fourthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let fifthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    let sixthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let seventhImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    let eigthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    
    
    let button: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("Pop View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(removeImageFromStack), for: .touchUpInside)
        return button
    }()
    
    var indexTracking: Int = 0
    var queueControllerSource = [UIImageView]()
    
    init() {
        self.indexTracking = 3
        self.queueControllerSource = [firstImageView, secondImageView, thirdImageView, fourthImageView,
                                      fifthImageView, sixthImageView, seventhImageView, eigthImageView]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .white
        self.view.addSubview(self.button)
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func removeImageFromStack() {
        print("Removing Image From Stack!")
        if self.indexTracking < self.queueControllerSource.count {
            self.popTransition(newImageView: self.queueControllerSource[indexTracking])
            self.indexTracking += 1
        } else {
            self.popTransition(newImageView: nil)
        }
    }
    
    func popItem(item: UIImageView) {
        print("I'm in the delegate and i can see I popped")
    }

    public override func numberOfItemsToShow() -> Int {
        return self.indexTracking
    }
    
    public override func queueSources() -> [UIImageView] {
        return self.queueControllerSource
    }
    
    public override func queueView(sizeForItemAt: Int) -> CGSize {
        return CGSize(width: 100, height: 75)
    }
    
    public override func queueView(minimumEdgeSpacingForItems: CGFloat) -> CGFloat {
        return 12.0
    }
    
    public override func queueView(minimumLineSpacingForItems: CGFloat) -> CGFloat {
        return 12.0
    }
}
