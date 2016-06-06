//
//  ViewController.swift
//  TMJourney
//
//  Created by Derrick  Ho on 6/5/16.
//  Copyright © 2016 Derrick  Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var webView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let credentials = LoginItems()
		TMLoginManager.login(credentials)
		{ (success, authToken, error) in
		print("authToken: ", authToken, " error ", error)
			
			TMAgendaManager.fetchAgenda(credentials, authToken: authToken)
			{ (str, error) in
				self.webView.loadHTMLString(str, baseURL: nil)
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

