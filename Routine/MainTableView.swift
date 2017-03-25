//
//  MainTableView.swift
//  Routine
//
//  Created by mesird on 25/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class MainTableView: UITableView {
    
    var pressedCell: MainTableViewCell?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("table view touches began")
        let point = ((touches as NSSet).anyObject() as! UITouch).location(in: self)
        let indexPath = self.indexPathForRow(at: point)
        if indexPath != nil {
            let cell: MainTableViewCell = self.cellForRow(at: indexPath!) as! MainTableViewCell
            cell.displayPressAnimation()
            pressedCell = cell
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = ((touches as NSSet).anyObject() as! UITouch).location(in: self)
        print("table view touches moved: \(point)")
        if pressedCell != nil {
            if pressedCell!.point(inside: point, with: nil) {
                pressedCell!.displayReleaseAnimation()
                pressedCell = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let point = ((touches as NSSet).anyObject() as! UITouch).location(in: self)
        let indexPath = self.indexPathForRow(at: point)
        print("table view touches ended")
        if pressedCell != nil {
            pressedCell!.displayReleaseAnimation()
            pressedCell = nil
            if self.delegate != nil && indexPath != nil {
                self.delegate!.tableView!(self, didSelectRowAt: indexPath!)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("table view touches cancelled")
        if pressedCell != nil {
            pressedCell!.displayReleaseAnimation()
            pressedCell = nil
        }
    }
}
