import UIKit
import PhotosUI

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    
    var picker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCamera()
        setupConfig()
    }
    
    func checkCamera() {
        let hasCam = UIImagePickerController.isSourceTypeAvailable(.camera)
        cameraBtn.isEnabled = hasCam
        if hasCam {
            setupPicker()
        }
    }
    
    
    @IBAction func cameraPicker(_ sender: UIButton) {
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func libraryButton(_ sender: UIButton) {
        self.present(libraryPicker!, animated: true, completion: nil)
        
    }
}

extension PhotosViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let r = results.first {
            let item = r.itemProvider
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let newImage = image as? UIImage {
                            self.iv.image = newImage
                        }
                        print(error?.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
    
    func setupConfig() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .automatic
        libraryPicker = PHPickerViewController(configuration: config)
        libraryPicker!.delegate = self
    }
    
    
    
    
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupPicker() {
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.iv.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

