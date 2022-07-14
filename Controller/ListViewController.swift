//
//  ListViewController.swift
//  note4.0
//
//  Created by student on 2022/1/5.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoteViewControllerDelegate {
    
   
    @IBOutlet weak var TableView: UITableView!
    
    var data : [Note] = []

    required init?(coder: NSCoder) {
        super .init(coder: coder)
//        for i in 1..<10 {
//            let note = Note()
//            note.text = "note \(i)"
//            data.append(note)
//        }
        self.loadFromFile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addNote(_ sender: Any) {
        
        let note = Note()
        note.text = "New note"
        self.data.insert(note, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.TableView.insertRows(at: [indexPath], with: .automatic)
        self.saveToFile()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.TableView.setEditing(editing, animated: true)
    }
    //反向選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.TableView.deselectRow(at: indexPath, animated: true)
        print("位置 \(indexPath.row + 1)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.data.remove(at: indexPath.row)
            self.TableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.saveToFile()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let note = self.data.remove(at: sourceIndexPath.row)
        self.data.insert(note, at: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteSegue" {
            let noteVC = segue.destination as! NoteViewController
            if let indexPath = self.TableView.indexPathForSelectedRow {
                let note = self.data[indexPath.row]
                noteVC.note = note
                noteVC.delegate = self
            }
        }
    }
    
    func didFinishUpdateNote(note : Note){
        let index = self.data.firstIndex { item in
            return note.noteID == item.noteID
        }
        guard let i = index else {
            return
        }
        let indexPath = IndexPath(row: i, section: 0)
        self.TableView.reloadRows(at: [indexPath], with: .automatic)
        self.saveToFile()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = self.data[indexPath.row]
        cell.textLabel?.text = note.text
        cell.imageView?.image = note.image()
        cell.showsReorderControl = true
        return cell
    }
    func saveToFile()  {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let docURL = homeURL.appendingPathComponent("Documents")
        let fileURL = docURL.appendingPathComponent("notes.archive")
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.data, requiringSecureCoding: false)
            try data.write(to: fileURL, options: [.atomicWrite])
        }catch{
            print("error\(error)")
        }
    }
    func loadFromFile()  {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let docURL = homeURL.appendingPathComponent("Documents")
        let fileURL = docURL.appendingPathComponent("notes.archive")
        do{
            let data = try Data(contentsOf: fileURL)
            self.data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Note]
        }catch{
            print("error\(error)")
        }
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
