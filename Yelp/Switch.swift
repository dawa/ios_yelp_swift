// Copyright © 2016 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import C4
import UIKit

@IBDesignable
class Switch: UISwitch {
    var thumb: SwitchThumb?
    var background: SwitchBackground?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        thumb = SwitchThumb()
        background = SwitchBackground()
        replaceViews()
        setup()
        toggle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        thumb = SwitchThumb()
        background = SwitchBackground()
        replaceViews()
        setup()
        toggle()
    }
    
    init(thumb aThumb: SwitchThumb? = SwitchThumb(), background aBackground: SwitchBackground? = SwitchBackground()) {
        super.init(frame: CGRect())
        
        thumb = aThumb
        background = aBackground
        replaceViews()
        setup()
    }
    
    internal func replaceViews() {
        let subviews = self.subviews
        let mainView = subviews[0]
        let imageView = subviews[0].subviews[3] as! UIImageView // swiftlint:disable:this force_cast
        thumb?.center = Point(Double(imageView.bounds.size.width-28.66666), Double(imageView.bounds.midY-0.66666))
        imageView.addSubview(thumb!.view)
        imageView.image = UIImage()
        
        self.addTarget(self, action: #selector(Switch.toggle), for: UIControlEvents.valueChanged)
        
        mainView.add(background)
        mainView.bringToFront(imageView)
        
        let sv0 = mainView.subviews[0]
        let sv1 = mainView.subviews[1]
        let sv2 = mainView.subviews[2]
        
        mainView.remove(sv0)
        mainView.remove(sv1)
        mainView.remove(sv2)
    }
    
    func setup() {
    }
    
    func toggle() {
        self.thumb?.toggle(force: isOn)
        self.background?.toggle(force: isOn)
    }
}
