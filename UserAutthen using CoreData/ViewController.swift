//
//  ViewController.swift
//  UserAutthen using CoreData
//
//  Created by Viraj Padte on 1/31/17.
//  Copyright © 2017 Bit2Labz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var dereg: UIButton!
    @IBOutlet weak var updateUname: UIButton!
    @IBOutlet weak var cancel: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pageTitle.text = "Enter your name"
        button.setTitle("Check!", for: [])
        
        //dissable and dissapper buttons
        dereg.isEnabled = false
        updateUname.isEnabled = false
        cancel.isEnabled = false
        
        dereg.alpha = 0
        updateUname.alpha = 0
        cancel.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checking(_ sender: UIButton) {
        print(sender.tag)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        
        
        if sender.tag == 0{
            if button.titleLabel?.text == "Check!"{
                //retrive and check
                var found  = false //indicating not found
                do {
                    let results = try context.fetch(request)
                    print("We could fetch data")
                    if results.count > 0{
                        print("fetched data array not empty")
                        for result in results as! [NSManagedObject]{
                            if nameInput.text == result.value(forKey: "name") as? String{
                                print("Found")
                                found = true
                                break
                            }
                        }
                        if found{
                            button.alpha = 0
                            message.text = "You are already registered!"
                            //show buttons
                            //dissable and dissapper buttons
                            dereg.isEnabled = true
                            updateUname.isEnabled = true
                            cancel.isEnabled = true
                            
                            dereg.alpha = 1
                            updateUname.alpha = 1
                            cancel.alpha = 1
                        }
                        else{
                            //if name doesnt exists start the registeration routine
                            
                            //make the GUI registration ready
                            pageTitle.text = "You need need to register!"
                            //set a temporary placeholder
                            nameInput.text = ""
                            nameInput.placeholder = "Enter your name to register here!"
                            button.setTitle("Register!", for: [])
                        }
                    }
                    else{
                        //make the GUI registration ready
                        pageTitle.text = "You need need to register!"
                        //set a temporary placeholder
                        nameInput.text = ""
                        nameInput.placeholder = "Enter your name to register here!"
                        button.setTitle("Register!", for: [])
                        message.text = ""
                    }
                } catch  {
                    print("couldn't fetch anything")
                }
            }
            else if button.titleLabel?.text == "Register!"{
                self.register()
            }
        }
        else if sender.tag == 1 {
            //De-register
            var found = false
            do {
                let results = try context.fetch(request)
                print("We could fetch data")
                if results.count > 0{
                    print("fetched data array not empty")
                    for result in results as! [NSManagedObject]{
                        if nameInput.text == result.value(forKey: "name") as? String{
                            context.delete(result)
                            found = true
                        }
                    }
                    if found{
                        message.text = "You are successfully deregistered"
                        dereg.alpha = 0
                        updateUname.alpha = 0
                        cancel.alpha = 0
                        button.alpha = 0
                        let when = DispatchTime.now() + 0.3 // change 2 to desired number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.cancelled(Any)
                        }
                        
                    }
                }
            }catch  {
                
            }
        }
        else if sender.tag == 2{
            //Update
            let newName = "Viraj"
            var found = false
            do {
                let results = try context.fetch(request)
                print("We could fetch data")
                if results.count > 0{
                    print("fetched data array not empty")
                    for result in results as! [NSManagedObject]{
                        if nameInput.text == result.value(forKey: "name") as? String{
                            result.setValue(newName, forKey: "name")
                            found = true
                        }
                    }
                    if found{
                        message.text = "You have updated your name"
                        dereg.alpha = 0
                        updateUname.alpha = 0
                        cancel.alpha = 0
                        button.alpha = 0
                        let when = DispatchTime.now() + 0.3 // change 2 to desired number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.cancelled(Any)
                        }
                    }
                }
            }catch  {
                
            }
        }
    }

   
    func register(){
        //get the name:
        let name  = nameInput.text
        //store the name
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newName = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newName.setValue(name, forKey: "name")
        do {
            try context.save()
            print("Could save")
            //after registeration clear the placeholder and chnage the button text back to check!
            message.text = "Thanks for registering!"
            button.alpha = 0
            //delay for UI and then clear the message and make the GUI ready for checking again
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.pageTitle.text = "Enter your name"
                self.button.setTitle("Check!", for: [])
                self.message.text = ""
                self.nameInput.text = ""
                self.nameInput.placeholder = ""
                self.button.alpha = 1
            }
            
        } catch  {
            print("Couldn't save")
        }
    }
        
    @IBAction func cancelled(_ sender: Any) {
        button.setTitle("Check!", for: [])
        self.message.text = ""
        self.nameInput.text = ""
        
        //dissable and dissapper buttons
        dereg.isEnabled = false
        updateUname.isEnabled = false
        cancel.isEnabled = false
        
        dereg.alpha = 0
        updateUname.alpha = 0
        cancel.alpha = 0
        button.alpha = 1

    }
    

    
    
}



