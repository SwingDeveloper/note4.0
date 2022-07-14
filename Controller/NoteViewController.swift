//
//  NoteViewController.swift
//  note4.0
//
//  Created by student on 2022/1/5.
//

import UIKit

protocol NoteViewControllerDelegate: AnyObject {
    func didFinishUpdateNote(note : Note)
}

class NoteViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var note : Note!
    weak var delegate : NoteViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = note.text
        self.imageView.image = note.image()
    }
    @IBAction func done(_ sender: Any) {
        if let image = self.imageView.image,let imageData = image.jpegData(compressionQuality: 1) {
            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
            let docURL = homeURL.appendingPathComponent("Documents")
            let photoURL = docURL.appendingPathComponent("\(self.note.noteID).jpg")
            self.note.imageName = "\(self.note.noteID).jpg"
            do {
                try imageData.write(to: photoURL, options: [.atomicWrite])
            } catch  {
                print("error\(error)")
            }
        }
        
        self.note.text = self.textView.text
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didFinishUpdateNote(note: self.note)
    }
    
    @IBAction func carema(_ sender: Any) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
