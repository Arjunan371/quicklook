//
//  ViewController.swift
//  FileManager with tableview Add
//
//  Created by Mohammed Abdullah on 17/07/23.
//
struct FileItem {
    let fileName: String
    let fileURL: URL
    let fileType: String
}
import AVFoundation
import UIKit
import QuickLook
import MobileCoreServices


class ViewController: UIViewController,UINavigationControllerDelegate,UIDocumentPickerDelegate {
    @IBOutlet weak var table: UITableView!
    var array:[FileItem] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //        imageView.isUserInteractionEnabled = true
        //        imageView.addGestureRecognizer(tapGestureRecognizer)
 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Add(_ sender: UIButton) {
        
      addima()
        
    }
    func addima(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeContent as String], in: .import)
          documentPicker.delegate = self
          documentPicker.allowsMultipleSelection = false // Set to true if you want to allow multiple file selection
          present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            print("No URL selected")
            return
        }
        let fileType = selectedURL.pathExtension
        let fileName = selectedURL.deletingPathExtension().lastPathComponent
        let fileItem = FileItem(fileName: fileName, fileURL: selectedURL,fileType: fileType)
        array.append(fileItem)
        
        table.reloadData()
    }
    
}
extension ViewController: QLPreviewControllerDelegate,QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return array.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {

        return array[index].fileURL as QLPreviewItem
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "one", for: indexPath) as! firstTableViewCell

        let fileItem = array[indexPath.row]
        cell.label1.text = fileItem.fileName
        cell.label2.text = fileItem.fileType

        let fileExtension = fileItem.fileType.lowercased()
        
        switch fileExtension {
        case "pdf":
            cell.imaeView.image = UIImage(named: "pdf")
        case "jpg", "jpeg", "png":
            if let imageData = try? Data(contentsOf: fileItem.fileURL),
               let image = UIImage(data: imageData) {
                cell.imaeView.image = image
            } else {
                cell.imaeView.image = UIImage(named: "default_image")
            }
        case "mp3":
            cell.imaeView.image = UIImage(named: "mp3")
        case "mp4", "mov":
            if fileExtension == "mp4"{
                cell.imaeView.image = UIImage(named: "mp4")
            } else{
                cell.imaeView.image = UIImage(named: "video")
            }
        default:
            cell.imaeView.image = UIImage(systemName:  "person.fill")
        }
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewController = QLPreviewController()
            previewController.dataSource = self
        previewController.currentPreviewItemIndex = indexPath.row
            present(previewController, animated: true)
        let fileItem = array[indexPath.row].fileType.lowercased()
        switch fileItem{
        case "mp3":
            let player = AVPlayer(url: array[indexPath.row].fileURL)
                player.play()
        case "mp4", "mov":
           toPlayVideo()
            print("success")
        default:
            print("failure")
        }
        func toPlayVideo(){
            let player = AVPlayer(url: array[indexPath.row].fileURL)
            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let fileURL = array[indexPath.row].fileURL
//
//            do {
//                try FileManager.default.removeItem(at: fileURL)
//                array.remove(at: indexPath.row)
//                table.deleteRows(at: [indexPath], with: .fade)
//                print("File deleted successfully")
//            } catch {
//                print("Error deleting file: \(error)")
//            }
////            if indexPath.row == 0{
////                imageView.image = nil
////            }
//        }
//    }
}





