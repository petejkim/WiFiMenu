//
//  AppDelegate.swift
//  WiFiMenu
//
//  Created by Peter Jihoon Kim on 3/31/17.
//  Copyright © 2017 Peter Jihoon Kim. All rights reserved.
//

import Cocoa
import CoreWLAN

func getSSID() -> String {
  return CWWiFiClient()?.interface(withName: nil)?.ssid() ?? "No Wi-Fi"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
  let reachability = Reachability()!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.updateTitle()
    let menu = NSMenu()
    menu.addItem(NSMenuItem(title: "Quit WiFiMenu", action: #selector(self.quit), keyEquivalent: ""))
    self.statusItem.menu = menu

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.updateTitle),
      name: ReachabilityChangedNotification,
      object: nil
    )

    do {
      try self.reachability.startNotifier()
    } catch {}

    NSWorkspace.shared().notificationCenter.addObserver(
      self,
      selector: #selector(self.updateTitle),
      name: NSNotification.Name.NSWorkspaceDidWake,
      object: nil
    )
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    NotificationCenter.default.removeObserver(self)
    reachability.stopNotifier()
    NSWorkspace.shared().notificationCenter.removeObserver(self)
  }

  func updateTitle() {
    self.statusItem.title = getSSID()
  }

  func quit() {
    NSApplication.shared().terminate(self)
  }
}
