//
//  ViewController.swift
//  NewsBlocker
//
//  Created by Elisha Eshed on 30/07/2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    // Programmatically added UIImageView and UILabel
    var imageView: UIImageView!
    var label: UILabel!
    var statusLabel: UILabel!
    var refreshLabel: UILabel!
    var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background color programmatically
        self.view.backgroundColor = UIColor.white

        // Set up the imageView
        imageView = UIImageView(image: UIImage(named: "Icon.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // Set up the label
        label = UILabel()
        label.text = "You can turn on NewsBlocker’s Safari extension in Settings."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        // Set up the status label
        statusLabel = UILabel()
        statusLabel.text = "Content Blocker Status: Unknown"
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        // Set up the status label
        refreshLabel = UILabel()
        refreshLabel.text = ""
        refreshLabel.numberOfLines = 0
        refreshLabel.textAlignment = .center
        refreshLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(refreshLabel)

        // Set up the button
        button = UIButton(type: .system)
        button.setTitle("Reload Blocker", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        
        // Set up constraints for imageView and labels
        setupConstraints()

        // Check if content blocker is enabled
        checkContentBlockerStatus()
    }

    // Function to set up constraints for UI components
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // imageView constraints
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.heightAnchor.constraint(equalToConstant: 128),

            // label constraints
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // statusLabel constraints
            statusLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // refreshbutton constraints
            button.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            
        ])
    }

    // Function to check if the content blocker is enabled
    func checkContentBlockerStatus() {
        let blockerIdentifier = "software.botanica.NewsBlocker.filter"

        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: blockerIdentifier) { [weak self] (state, error) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    // Handle error (e.g., incorrect identifier)
                    self.statusLabel.text = "Error: Unable to determine status:  \(error.localizedDescription)"
                    print("Error checking content blocker state: \(error.localizedDescription)")
                    return
                }

                if let state = state {
                    if state.isEnabled {
                        self.statusLabel.text = "Content Blocker Status: Enabled"
                    } else {
                        self.statusLabel.text = "Content Blocker Status: Disabled"
                    }
                } else {
                    self.statusLabel.text = "Content Blocker Status: Unknown"
                }
            }
        }
    }
    
    @objc func reloadButtonTapped() {
        refresh()
    }

    func refresh() {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "software.botanica.NewsBlocker.filter") { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.statusLabel.text = "Failed to reload content blocker: \(error)"
                } else {
                    self.statusLabel.text = "Content Blocker reloaded"
                }
                print(self.statusLabel.text!)
            }
        }
    }
}
