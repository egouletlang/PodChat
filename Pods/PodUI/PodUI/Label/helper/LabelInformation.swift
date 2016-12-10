//
//  LabelInformation.swift
//  BaseUIClasses
//
//  Created by Etienne Goulet-Lang on 11/19/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public class LabelInformation: NSObject {
    var attr: NSAttributedString?
    var links: [URL] = []
    var ranges: [NSRange] = []
}
