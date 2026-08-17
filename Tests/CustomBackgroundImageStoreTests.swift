import AppKit
import Foundation

@main
struct CustomBackgroundImageStoreTests {
    static func main() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let store = CustomBackgroundImageStore(directory: directory)
        let image = NSImage(size: NSSize(width: 2, height: 2))
        image.lockFocus()
        NSColor.systemBlue.setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 0, width: 2, height: 2)).fill()
        image.unlockFocus()

        precondition(store.save(image))
        precondition(store.load() != nil)
        precondition(!store.save(Data("not an image".utf8)))

        store.clear()
        precondition(store.load() == nil)
        print("CustomBackgroundImageStoreTests passed")
    }
}
