//
//  MainViewController.swift
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 17/04/24.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private lazy var labelVersion: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        uiLabel.textColor = .darkGray
        
        return uiLabel
    }()
    
    private lazy var pictureView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.layer.borderWidth = 0.25
        uiImageView.layer.borderColor = UIColor.lightGray.cgColor
        uiImageView.clipsToBounds = true
        
        return uiImageView
    }()
    
    private lazy var callCameraButton: UIButton = {
        let uiButton = UIButton()
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.setTitle("Iniciar Camera", for: .normal)
        uiButton.setTitleColor(.white, for: .normal)
        uiButton.backgroundColor = .blue
        uiButton.layer.cornerRadius = 5
        
        return uiButton
    }()
    
    private lazy var callPhotoLibraryButton: UIButton = {
        let uiButton = UIButton()
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.setTitle("Biblioteca", for: .normal)
        uiButton.setTitleColor(.white, for: .normal)
        uiButton.backgroundColor = .blue
        uiButton.layer.cornerRadius = 5
        uiButton.addTarget(self, action: #selector(callPhotoLibrary), for: .touchUpInside)
        
        return uiButton
    }()
    
    private var pickerController = UIImagePickerController()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        
        view.addSubview(pictureView)
        view.addSubview(callCameraButton)
        view.addSubview(callPhotoLibraryButton)
        view.addSubview(labelVersion)
        
        let constraints = [
            pictureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pictureView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            pictureView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            
            callCameraButton.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10),
            callCameraButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            callCameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            callCameraButton.widthAnchor.constraint(equalToConstant: 150),
            
            callPhotoLibraryButton.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10),
            callPhotoLibraryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            callPhotoLibraryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            callPhotoLibraryButton.widthAnchor.constraint(equalToConstant: 150),
            
            callCameraButton.trailingAnchor.constraint(lessThanOrEqualTo: callPhotoLibraryButton.leadingAnchor, constant: 20),
            
            labelVersion.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            labelVersion.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelVersion.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelVersion.text = OpenCVImage.versionNumber()
    }
    
    @objc fileprivate func callPhotoLibrary() {
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickerController.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        pictureView.image = OpenCVImage.classifyImage(image)
    }
}
