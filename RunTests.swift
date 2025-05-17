#!/usr/bin/env swift
//
// Simple test runner script
//

import Foundation

print("🚀 Starting test suite...")

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/xcodebuild")
process.arguments = [
    "-project", "NativeYoutube.xcodeproj",
    "-scheme", "NativeYoutube",
    "test"
]

do {
    try process.run()
    process.waitUntilExit()
    
    if process.terminationStatus == 0 {
        print("✅ Tests passed!")
    } else {
        print("❌ Tests failed with status: \(process.terminationStatus)")
    }
} catch {
    print("❌ Error running tests: \(error)")
}