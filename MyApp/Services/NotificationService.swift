import Foundation
import Observation
import UIKit
import UserNotifications

@MainActor
@Observable
final class NotificationService {
    // reminder settings are saved locally and scheduled as weekly notifications
    private enum StorageKey {
        static let isEnabled = "studyReminder.isEnabled"
        static let hour = "studyReminder.hour"
        static let minute = "studyReminder.minute"
        static let activeDays = "studyReminder.activeDays"
    }

    private let notificationCenter = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard

    private(set) var isEnabled: Bool
    private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    private(set) var statusMessage: String?
    private(set) var errorMessage: String?

    var savedTime: Date {
        let hour = defaults.object(forKey: StorageKey.hour) as? Int ?? 19
        let minute = defaults.object(forKey: StorageKey.minute) as? Int ?? 0
        return Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: .now
        ) ?? .now
    }

    var savedActiveDays: Set<Int> {
        let storedDays = defaults.array(forKey: StorageKey.activeDays) as? [Int]
        return Set(storedDays ?? [1, 2, 3, 4, 5])
    }

    var authorizationDescription: String {
        switch authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return "Notifications are allowed."
        case .denied:
            return "Notifications are disabled in iOS Settings."
        case .notDetermined:
            return "Permission will be requested when you save a reminder."
        @unknown default:
            return "Notification permission status is unavailable."
        }
    }

    init() {
        isEnabled = defaults.bool(forKey: StorageKey.isEnabled)
    }

    func refreshAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    func saveReminder(time: Date, activeDays: Set<Int>) async {
        // rebuild all weekly requests so removed days do not stay scheduled
        errorMessage = nil
        statusMessage = nil

        guard !activeDays.isEmpty else {
            errorMessage = "Select at least one day for the reminder."
            return
        }

        do {
            let isAuthorized = try await requestAuthorizationIfNeeded()
            guard isAuthorized else {
                errorMessage = "Allow notifications in iOS Settings to use study reminders."
                return
            }

            removeScheduledReminders()

            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            for dayID in activeDays.sorted() {
                var schedule = DateComponents()
                schedule.weekday = calendarWeekday(for: dayID)
                schedule.hour = timeComponents.hour
                schedule.minute = timeComponents.minute

                let content = UNMutableNotificationContent()
                content.title = "Time to study anatomy"
                content.body = "Continue your AnatomyAR learning journey with a short lesson."
                content.sound = .default

                let request = UNNotificationRequest(
                    identifier: reminderIdentifier(for: dayID),
                    content: content,
                    trigger: UNCalendarNotificationTrigger(dateMatching: schedule, repeats: true)
                )
                try await notificationCenter.add(request)
            }

            savePreferences(time: time, activeDays: activeDays)
            isEnabled = true
            statusMessage = "Your weekly study reminder is active."

#if canImport(FirebaseMessaging)
            // APNs is needed for Firebase notifications
            UIApplication.shared.registerForRemoteNotifications()
#endif
        } catch {
            errorMessage = "The reminder could not be saved: \(error.localizedDescription)"
        }
    }

    func disableReminder() {
        removeScheduledReminders()
        defaults.set(false, forKey: StorageKey.isEnabled)
        isEnabled = false
        errorMessage = nil
        statusMessage = "Study reminders are disabled."
    }

    private func requestAuthorizationIfNeeded() async throws -> Bool {
        // only show the system permission prompt on the first save attempt
        await refreshAuthorizationStatus()

        if authorizationStatus == .notDetermined {
            _ = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await refreshAuthorizationStatus()
        }

        return authorizationStatus == .authorized
            || authorizationStatus == .provisional
            || authorizationStatus == .ephemeral
    }

    private func savePreferences(time: Date, activeDays: Set<Int>) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        defaults.set(components.hour ?? 19, forKey: StorageKey.hour)
        defaults.set(components.minute ?? 0, forKey: StorageKey.minute)
        defaults.set(activeDays.sorted(), forKey: StorageKey.activeDays)
        defaults.set(true, forKey: StorageKey.isEnabled)
    }

    private func removeScheduledReminders() {
        let identifiers = (1...7).map(reminderIdentifier(for:))
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    private func reminderIdentifier(for dayID: Int) -> String {
        "study-reminder-\(dayID)"
    }

    private func calendarWeekday(for dayID: Int) -> Int {
        // the screen uses Monday = 1, while Calendar uses Sunday = 1
        dayID == 7 ? 1 : dayID + 1
    }
}
