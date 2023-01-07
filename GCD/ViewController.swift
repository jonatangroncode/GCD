//
//  ViewController.swift
//  GCD
//
//  Created by ITHS on 2023-01-05.
//  Copyright © 2023 ITHS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let imageURLstring = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/RedCat_8727.jpg/1280px-RedCat_8727.jpg"

    //variablen är en Dispatcher     ?= kan vara nill
    var inactiveQueue : DispatchQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //simpleQueue()
      //  queuesWithPriority()
       // concurrentQueue()
        
      //  inactiveQueue?.activate()
        
        showImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        for i in 1...1000000 {
//            print("Hej")
//            
//        }
//    }
    
    
    func simpleQueue() {
        
        let queue = DispatchQueue(label: "queue1")
        
        //ligger i en kö alltså inte på huvudtråden, körs när det finns tid
        queue.async {
            for i in 0...10{
                print("🔵 \(i)")
            }
        }
        //körs på huvudtråden
        for i in 0...10 {
            print("🔴 \(i)")
        }
        
    }
    
    func queuesWithPriority() {
        
        let queue1 = DispatchQueue(label: "queue1", qos:.userInitiated)
        let queue2 = DispatchQueue(label: "queue2", qos:.utility )
        
        queue1.async {
        for i in 1...10{
            print("🔴 \(i)")

            }
        }
        
        queue2.async {
            for i in 1...10{
                print("⚫️ \(i)")
                
            }
        }

        for i in 1...10{
            print("🔵 \(i)")
            
        }

    }
    
    //röd visas alltid först
    func concurrentQueue() {
        let queue = DispatchQueue(label: "queue", qos: .utility,
                                  attributes: [.concurrent, .initiallyInactive])
        
        
        inactiveQueue = queue
        
        queue.async {
            for i in 1...10{
                print("⚫️ \(i)")
                
            }
        }
        
        queue.async {

            for i in 1...10{
                print("🔵 \(i)")
                
            }

         }
    
    
        
        for i in 0...10 {
            print("🔴 \(i)")
        }
        
    }
    
    //hämtar bild från internet och visar i en imageview
    func showImage() {
        
        //skapar en URL från en sträng som lagras i konstanten imageUrl, om de inte går returnerar
        guard let imageUrl = URL(string: imageURLstring) else {return}
        
        //skapar en sessionsvariabel (hantera en serie sammanhängande händelser), dataTask hämtar datan från imageUrl (https länken) session pausas
       let session = URLSession(configuration: .default).dataTask(with: imageUrl) {
            imageData, response, error in //här hamnar resultatet av hämtningen i imageData från urllänken
        
            //Om allt funkar läggs datan från bilden i data
            if let data = imageData {
                print("bild nerladdad")
                
                //som sedan UIImage skapar bilden med och lägger i en imageview
                DispatchQueue.main.async {  // i main tråden
                    self.imageView.image = UIImage(data: data)                 }
                
            }
        }
        //startar nedladdningen av bilden
        session.resume() // session exekveras i en bakgrundstråd och print i huvudtråden parallelt
        print("♥️") // körs direkt när session har skapats och blivit pausad
    }


}












