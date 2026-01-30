//
//  AccessibilityHelper.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-31.
//

//

import SwiftUI

/// Helper class for managing accessibility features throughout the app
struct AccessibilityHelper {
    
    // MARK: - VoiceOver Announcements
    
    /// Priority levels for VoiceOver announcements
    enum AnnouncementPriority {
        case low
        case medium
        case high
        
        var notification: UIAccessibility.Notification {
            switch self {
            case .low, .medium:
                return .announcement
            case .high:
                return .screenChanged
            }
        }
    }
    
    /// Make a VoiceOver announcement
    /// - Parameters:
    ///   - message: The message to announce
    ///   - priority: The priority level (default: medium)
    static func announce(_ message: String, priority: AnnouncementPriority = .medium) {
        DispatchQueue.main.async {
            UIAccessibility.post(
                notification: priority.notification,
                argument: message
            )
        }
    }
    
    // MARK: - Dynamic Type Support
    
    /// Check if user has enabled larger accessibility text sizes
    static var isAccessibilitySizeEnabled: Bool {
        UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory
    }
    
    /// Get scaled font size based on user's Dynamic Type setting
    /// - Parameters:
    ///   - baseSize: The base font size
    ///   - maximumSize: Optional maximum size to cap at
    /// - Returns: Scaled font size
    static func scaledFontSize(_ baseSize: CGFloat, maximum maximumSize: CGFloat? = nil) -> CGFloat {
        let scaled = UIFontMetrics.default.scaledValue(for: baseSize)
        if let max = maximumSize {
            return min(scaled, max)
        }
        return scaled
    }
    
    // MARK: - Motion Preferences
    
    /// Check if user prefers reduced motion
    static var prefersReducedMotion: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    /// Get animation duration respecting user's reduce motion preference
    /// - Parameter standard: Standard animation duration
    /// - Returns: Adjusted duration (0 if reduce motion is enabled)
    static func animationDuration(_ standard: Double) -> Double {
        prefersReducedMotion ? 0 : standard
    }
    
    // MARK: - VoiceOver Detection
    
    /// Check if VoiceOver is currently running
    static var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    // MARK: - Focus Management
    
    /// Move VoiceOver focus to a specific element
    /// - Parameter element: The element to focus on
    static func focusOnElement(_ element: Any?) {
        guard let element = element else { return }
        UIAccessibility.post(notification: .layoutChanged, argument: element)
    }
    
    // MARK: - Haptic Feedback
    
    /// Provide haptic feedback for an action
    /// - Parameter style: The haptic feedback style
    static func provideHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Provide success haptic feedback
    static func provideSuccessFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Provide error haptic feedback
    static func provideErrorFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // MARK: - Color Contrast
    
    /// Calculate contrast ratio between two colors
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: Contrast ratio (1.0 to 21.0)
    static func contrastRatio(between color1: Color, and color2: Color) -> Double {
        let luminance1 = relativeLuminance(of: color1)
        let luminance2 = relativeLuminance(of: color2)
        
        let lighter = max(luminance1, luminance2)
        let darker = min(luminance1, luminance2)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    /// Check if color combination meets WCAG AA standard (4.5:1)
    static func meetsWCAGAA(foreground: Color, background: Color) -> Bool {
        contrastRatio(between: foreground, and: background) >= 4.5
    }
    
    /// Check if color combination meets WCAG AAA standard (7:1)
    static func meetsWCAGAAA(foreground: Color, background: Color) -> Bool {
        contrastRatio(between: foreground, and: background) >= 7.0
    }
    
    private static func relativeLuminance(of color: Color) -> Double {
        guard let components = UIColor(color).cgColor.components else { return 0 }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        func adjust(_ value: CGFloat) -> Double {
            if value <= 0.03928 {
                return Double(value) / 12.92
            } else {
                return pow((Double(value) + 0.055) / 1.055, 2.4)
            }
        }
        
        return 0.2126 * adjust(r) + 0.7152 * adjust(g) + 0.0722 * adjust(b)
    }
    
    // MARK: - Accessibility Identifiers
    
    /// Generate consistent accessibility identifier
    /// - Parameters:
    ///   - type: Element type (e.g., "button", "card")
    ///   - identifier: Unique identifier
    /// - Returns: Formatted accessibility identifier
    static func identifier(type: String, id: String) -> String {
        "\(type)_\(id)"
    }
}

// MARK: - SwiftUI Environment Values Extension

extension EnvironmentValues {
    /// Custom environment value to check if accessibility features are enabled
    var isAccessibilityEnabled: Bool {
        UIAccessibility.isVoiceOverRunning ||
        UIAccessibility.isReduceMotionEnabled ||
        UIAccessibility.isBoldTextEnabled ||
        UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory
    }
}

// MARK: - View Extension for Accessibility

extension View {
    /// Add consistent accessibility support to a button
    func accessibleButton(
        label: String,
        hint: String? = nil,
        identifier: String? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier(identifier ?? "")
    }
    
    /// Add consistent accessibility support to a header
    func accessibleHeader(
        label: String
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }
    
    /// Conditionally apply animation based on reduce motion preference
    func adaptiveAnimation<V: Equatable>(
        _ animation: Animation?,
        value: V
    ) -> some View {
        self.animation(
            AccessibilityHelper.prefersReducedMotion ? .none : animation,
            value: value
        )
    }
}
