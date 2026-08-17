import AppKit
import Foundation

final class CustomBackgroundImageStore {
    private let fileURL: URL

    init(directory: URL = CustomBackgroundImageStore.defaultDirectory()) {
        self.fileURL = directory.appendingPathComponent("CustomBackground.png", isDirectory: false)
    }

    func save(_ image: NSImage) -> Bool {
        guard let data = Self.pngData(from: image) else { return false }
        return save(data)
    }

    func save(_ data: Data) -> Bool {
        guard let image = NSImage(data: data), let pngData = Self.pngData(from: image) else { return false }
        do {
            let directory = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            try pngData.write(to: fileURL, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    func load() -> NSImage? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return NSImage(data: data)
    }

    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }

    var hasImage: Bool {
        FileManager.default.fileExists(atPath: fileURL.path) && load() != nil
    }

    private static func defaultDirectory() -> URL {
        let fileManager = FileManager.default
        if let base = try? fileManager.url(for: .applicationSupportDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: true) {
            return base.appendingPathComponent("LaunchNext", isDirectory: true)
        }
        return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }

    private static func pngData(from image: NSImage) -> Data? {
        guard let tiff = image.tiffRepresentation,
              let representation = NSBitmapImageRep(data: tiff) else { return nil }
        return representation.representation(using: .png, properties: [:])
    }
}
