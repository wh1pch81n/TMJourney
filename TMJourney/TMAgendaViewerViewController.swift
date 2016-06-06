//
//  TMAgendaViewer.swift
//  TMJourney
//
//  Created by Derrick  Ho on 6/5/16.
//  Copyright © 2016 Derrick  Ho. All rights reserved.
//

import UIKit

enum TMError: ErrorType {
	case LoginError(NSError?)
	case LoginProcessingError
	case AgendaFetchError(NSError?)
	case AgendaProcessingError
}

struct LoginItems {
	let clubID: String = "newheights"
	let username: String = "derrickho328@gmail.com"
	let password: String = "yam3235"
}

class TMLoginManager {
	static var authToken: String?
//	private static let 
	static func login(credentials: LoginItems, completion: (success: Bool, authToken: String, error: TMError?) ->()) {
		let clubID = credentials.clubID
		let urlComponent = NSURLComponents(string: "http://\(clubID).toastmastersclubs.org/index.cgi")!
		urlComponent.queryItems = [
			NSURLQueryItem(name: "action", value: "memberlogin"),
			NSURLQueryItem(name: "memberid", value: ""),
			NSURLQueryItem(name: "memberselect", value: credentials.username),
			NSURLQueryItem(name: "mpass", value: credentials.password)
		]
		
		SessionManager.dataTask(urlComponent.URL!)
		{ (d: NSData?, err: NSError?) in
			if let err = err {
				completion(success: false, authToken: "", error: .LoginError(err))
				return
			}
			
			guard let data = d,
				dict = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? Dictionary<String, AnyObject>,
				status = dict["status"] as? String
			where status == "success",
				let memberSessionId = dict["membersessionid"] as? String
			else
			{
				completion(success: false, authToken: "", error: .LoginProcessingError)
				return
			}
			authToken = memberSessionId
			completion(success: true, authToken: memberSessionId, error: nil)
		}
	}
}

class TMAgendaManager {
	static func fetchAgenda(credentials: LoginItems, authToken: String, completion: (str: String, error: TMError?) -> ()) {
		// TODO: We are getting the default "non" member page for the agenda page which brings us to the home page instead.  Use charles to sniff out where they are "inserting" the session key.  How else would they determine someone is logged in.  Either that or the cache is empty
		let urlComponents = NSURLComponents(string: "http://\(credentials.clubID).toastmastersclubs.org/agenda.html")!
		SessionManager.dataTask(urlComponents.URL!)
		{ (d: NSData?, err: NSError?) in
			if let err = err {
				completion(str: "", error: .AgendaFetchError(err))
				return
			}
			
			guard let data = d,
				str = String(data: data, encoding: NSUTF8StringEncoding)
			else
			{
				completion(str: "", error: .AgendaProcessingError)
				return
			}
			completion(str: str, error: nil)
		}
	}
}

struct SessionManager {
	static func dataTask(url: NSURL, completionHandler: (NSData?, NSError?) -> ()) {
		let request = NSURLRequest(URL: url
			, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy
			, timeoutInterval: 30
		)
		
		let session = NSURLSession.sharedSession().dataTaskWithRequest(request)
		{ (d: NSData?, res: NSURLResponse?, err: NSError?) in
			if let err = err {
				completionHandler(d, err)
				return
			}
			guard let data = d else {
				completionHandler(nil, NSError(domain: "SessionManager", code: 0, userInfo: nil))
				return
			}
			completionHandler(data, nil)
		}
		session.resume()
	}
}

class TMAgendaViewerViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource*/ {
	
	
	
}
