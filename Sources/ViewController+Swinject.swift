//
//  ViewController+Swinject.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/31/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ObjectiveC

#if canImport(UIKit)
import UIKit

private var uivcRegistrationNameKey: String = "UIViewController.swinjectRegistrationName"
private var uivcWasInjectedKey: String = "UIViewController.wasInjected"

extension UIViewController: RegistrationNameAssociatable, InjectionVerifiable {
    public var swinjectRegistrationName: String? {
        get { withUnsafePointer(to: &uivcRegistrationNameKey) { getAssociatedString(key: $0) } }
        set { withUnsafePointer(to: &uivcRegistrationNameKey) { setAssociatedString(newValue, key: $0) } }
    }

    public var wasInjected: Bool {
        get { withUnsafePointer(to: &uivcWasInjectedKey) { getAssociatedBool(key: $0) ?? false } }
        set { withUnsafePointer(to: &uivcWasInjectedKey) { setAssociatedBool(newValue, key: $0) } }
    }
}

#elseif canImport(Cocoa)
import Cocoa

private var nsvcRegistrationNameKey: String = "NSViewController.swinjectRegistrationName"
private var nswcRegistrationNameKey: String = "NSWindowController.swinjectRegistrationName"
private var nsvcWasInjectedKey: String = "NSViewController.wasInjected"
private var nswcWasInjectedKey: String = "NSWindowController.wasInjected"

extension NSViewController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return getAssociatedString(key: &nsvcRegistrationNameKey) }
        set { setAssociatedString(newValue, key: &nsvcRegistrationNameKey) }
    }

    internal var wasInjected: Bool {
        get { return getAssociatedBool(key: &nsvcWasInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nsvcWasInjectedKey) }
    }
}

extension NSWindowController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return getAssociatedString(key: &nsvcRegistrationNameKey) }
        set { setAssociatedString(newValue, key: &nsvcRegistrationNameKey) }
    }

    internal var wasInjected: Bool {
        get { return getAssociatedBool(key: &nswcWasInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nswcWasInjectedKey) }
    }
}

#endif

extension NSObject {
    fileprivate func getAssociatedString(key: UnsafeRawPointer) -> String? {
        return objc_getAssociatedObject(self, key) as? String
    }

    fileprivate func setAssociatedString(_ string: String?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, string, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    fileprivate func getAssociatedBool(key: UnsafeRawPointer) -> Bool? {
        return (objc_getAssociatedObject(self, key) as? NSNumber)?.boolValue
    }
    
    fileprivate func setAssociatedBool(_ bool: Bool, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, NSNumber(value: bool), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
}
