//
//  Copyright (C) DB Systel GmbH.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

import UIKit

//Represents content which gets displayed during empty states.
public struct EmptyContent {
    public init(title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, shouldAllowTouch: Bool? = false, shouldAllowScroll: Bool? = false, shouldAllowImageViewAnimate: Bool? = false) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.shouldAllowTouch = shouldAllowTouch
        self.shouldAllowScroll = shouldAllowScroll
        self.shouldAllowImageViewAnimate = shouldAllowImageViewAnimate
    }
    
    public let title: String?
    public let subtitle: String?
    public let image: UIImage?
    public let shouldAllowTouch: Bool?
    public let shouldAllowScroll: Bool?
    public let shouldAllowImageViewAnimate: Bool?
    
}

public extension EmptyContent {
    //Represents content that gets overwritten by a custom representation.
    static let customPresentation = EmptyContent(title: nil, subtitle: nil, image: nil)
}
