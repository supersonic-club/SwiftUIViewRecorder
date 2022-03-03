import UIKit
import UIImageExtensions
import Combine

public class VideoRenderer: FramesRenderer {
    public init() {}
    public func render(frames: [UIImage], framesPerSecond: Double) -> Future<URL?, Error> {
        frames.toVideo(framesPerSecond: framesPerSecond)
    }
}
