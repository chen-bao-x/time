//
//  ViewController.swift
//  time
//
//  Created by chenbao on 9/7/24.
//

import Cocoa

class ViewController: NSViewController {
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor

        let label = NSTextField(labelWithString: "Hello World!")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // ...
}
