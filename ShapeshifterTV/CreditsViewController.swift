//
//  CreditsViewController.swift
//  ShapeshifterTV
//
//  Created by David Lang on 10/16/15.
//  Copyright © 2015 David Lang. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func `return`(sender: AnyObject) {
    }
    @IBOutlet weak var credits: UITableView!
    var songs = [
        "\"Prelude and Action\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Mechanolith\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Clenched Teeth\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Round Drums\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Machinations\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Dangerous\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0  http://creativecommons.org/licenses/by/3.0/",
        "\"Vortex\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Monkeys Spinning Monkeys\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Exciting Trailer\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Feral Chase\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Crisis\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Take a Chance\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Call to Adventure\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"The Descent\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Cortosis\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Cupid's Revenge\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Scattershot\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/",
        "\"Evil March\" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/"
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //credits.allowsSelection = false
        print(self.view.window?.rootViewController)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "theSongs")
        cell.textLabel?.text = self.songs[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial", size: 14.0)
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return songs.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CREDITS"
    }
    @IBAction func goBack(sender: AnyObject) {
        performSegueWithIdentifier("toMenuSegue", sender: nil)
    }
    
}
