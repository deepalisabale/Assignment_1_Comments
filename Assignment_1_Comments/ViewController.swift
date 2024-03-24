//
//  ViewController.swift
//  Assignment_1_Comments
//
//  Created by Deepali on 24/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CommentTableView: UITableView!
    
    var uiNib : UINib?
    var commenttableViewCell : CommentTableViewCell?
    private var commentViewCellIdentifier = "CommentTableViewCell"
    var url : URL?
    var urlRequest : URLRequest?
    var urlSession : URLSession?
    var comments : [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonSerialization()
        initializeTableView()
        registerXIBWithTableiew()
     }
     
     func initializeTableView(){
         CommentTableView.delegate = self
         CommentTableView.dataSource = self
     }

     
     func registerXIBWithTableiew(){
         let uiNIb = UINib(nibName: "CommentTableViewCell", bundle: nil)
         self.CommentTableView.register(uiNIb, forCellReuseIdentifier: "CommentTableViewCell" )
         
     }
     
     func jsonSerialization(){
         
         url = URL(string: "https://jsonplaceholder.typicode.com/comments")
         urlRequest = URLRequest(url: url!)
         urlRequest?.httpMethod = "GET"
         urlSession = URLSession(configuration: .default)
         let dataTask = urlSession?.dataTask(with: urlRequest!)
         {
             data, response, error in
             print(data)
             print(response)
             print(error)
             let jsonResponse = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
             for eachComment in jsonResponse
             {
                 let eachCommentPostId = eachComment["postId"] as! Int
                 let eachCommentId = eachComment["id"] as! Int
                 let eachCommentName = eachComment["name"] as! String
                 let eachCommentEmail = eachComment["email"] as! String
                 let eachCommentBody = eachComment["body"] as! String
                 let eachCommentObject = Comment(postId: eachCommentPostId, id: eachCommentId, name: eachCommentName, email: eachCommentEmail, body: eachCommentBody)
                 
                 self.comments.append(eachCommentObject)
                 
             }
             DispatchQueue.main.async {
             self.CommentTableView.reloadData()
             }
         }
         dataTask?.resume()
         
     }

 }
 extension ViewController : UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return comments.count
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         commenttableViewCell = (self.CommentTableView.dequeueReusableCell(withIdentifier: commentViewCellIdentifier, for: indexPath)as! CommentTableViewCell)
         commenttableViewCell?.postIdLabel.text = String(comments[indexPath.row].postId)
         commenttableViewCell?.idLabel.text = String(comments[indexPath.row].id)
         commenttableViewCell?.nameLabel.text = comments[indexPath.row].name
         commenttableViewCell?.emailLabel.text = comments[indexPath.row].email
         commenttableViewCell?.bodyLabel.text = comments[indexPath.row].body
         commenttableViewCell?.bodyLabel.adjustsFontSizeToFitWidth = true
         return commenttableViewCell!

     }
 }
 extension ViewController : UITableViewDelegate{
     
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 300.0
     }
 }

