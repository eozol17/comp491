//
//  FirstCameraViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import UIKit

class FirstCameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//

    @IBOutlet weak var CamerButton: UIButton!
    @IBOutlet weak var CameraView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

        // Do any additional setup after loading the view.
    }
    @IBAction func TappedCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        CameraView?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

