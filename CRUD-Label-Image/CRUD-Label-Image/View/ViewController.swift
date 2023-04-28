//
//  ViewController.swift
//  CRUD-Label-Image
//
//  Created by Shivam Pandya on 28/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var vwEnterData: UIView!
    @IBOutlet weak var imageVW: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    
    var imagePicker = UIImagePickerController()
    var items:[Person]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwEnterData.isHidden = true
        reloadData()
    }
    
    func reloadData(){
        items = coredata().getData()
        DispatchQueue.main.async {
            self.tbl.reloadData()
        }
    }
    
    @IBAction func addData(_ sender: Any) {
        
        vwEnterData.isHidden = false
        
    }
    
    @IBAction func addImg(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnOk(_ sender: Any) {
        
        let images = imageVW
        let textField = txtName
        
        coredata().addData(data: textField?.text ?? "", data2: (images?.image?.pngData())!)
        coredata().saveData()
        self.reloadData()
        
        vwEnterData.isHidden = true
        txtName.text = nil
        imageVW.image = UIImage()
        
    }

}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataCell
        
        cell.lblName.text = self.items?[indexPath.row].name
        let images = self.items![indexPath.row]
        cell.img.image = UIImage(data: images.photo!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person =  self.items![indexPath.row]
        
        imageVW.isHidden = false
        let images = imageVW
        let textField = txtName
        
        coredata().updateData(data: person, text: textField?.text ?? "", img: (images?.image?.pngData())!)
        coredata().saveData()
        self.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            let personToRemove = self.items![indexPath.row]
            
            coredata().deleteData(dataToRemove: personToRemove)
            coredata().saveData()
            self.reloadData()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageVW.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
}
