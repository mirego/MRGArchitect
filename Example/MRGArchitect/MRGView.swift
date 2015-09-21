// Copyright (c) 2014-2015, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

import UIKit

@available(iOS 8.0, *)
@objc(MRGView) class MRGView: UIView {
    
    private var architect : MRGArchitect;
    private var subview: UIView;
    private var image: UIImageView;
    private var label: UILabel;
    
    override init(frame: CGRect) {
        let name = NSStringFromClass(MRGView);
        self.architect = MRGArchitect(forClassName: name);
        self.subview = UIView(frame: frame);
        self.image = UIImageView(image: UIImage(named: "Image"));
        self.label = UILabel();
        super.init(frame: frame);
        self.backgroundColor = UIColor.redColor();
        self.subview.backgroundColor = UIColor.blueColor()

        self.addSubview(self.subview);
        self.subview.addSubview(self.image);
        self.subview.addSubview(self.label);
        self.image.sizeToFit();
        self.label.text = String(format: "%@", self.architect.stringForKey("title"));
        self.label.sizeToFit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        let name = NSStringFromClass(MRGView);
        self.architect = MRGArchitect(forClassName: name);
        self.subview = UIView(frame: CGRectZero);
        self.image = UIImageView(image: UIImage(named: "Image"));
        self.label = UILabel();
        super.init(coder: aDecoder);
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        self.architect.traitCollection = self.traitCollection;
        self.label.text = String(format: "%@", self.architect.stringForKey("title"));
        self.label.sizeToFit();
        self.setNeedsLayout();
    }
    
    override func layoutSubviews() {
        self.subview.frame = CGRect(x: 20, y: 20, width: self.bounds.width - 40, height: self.bounds.height - 40);
        self.image.frame = CGRect(x: (self.subview.bounds.width * 0.5) - (self.image.frame.width * 0.5), y: (self.subview.bounds.height * 0.5) - (self.image.frame.height * 0.5), width: self.image.frame.width, height: self.image.frame.width);
    }
}
