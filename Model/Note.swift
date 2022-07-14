import Foundation
import UIKit

class Note: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.text, forKey: "text")
        coder.encode(self.imageName, forKey: "imageName")
        coder.encode(self.noteID, forKey: "noteID")
    }
    
    required init?(coder: NSCoder) {
        self.noteID = coder.decodeObject(forKey: "noteID") as! String
        self.imageName = coder.decodeObject(forKey: "imageName") as? String
        self.text = coder.decodeObject(forKey: "text") as? String
    }
    
   override init() {
        
    }
    
var text: String?
//var image: UIImage?
var imageName: String?
var noteID: String = UUID().uuidString
    
    func image() -> UIImage? {
        
        if let fileName = self.imageName {
            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
            let docURL = homeURL.appendingPathComponent("Documents")
            let photoURL = docURL.appendingPathComponent(fileName)
            return UIImage(contentsOfFile: photoURL.path)
        }
        
        return nil
    }
    
}
