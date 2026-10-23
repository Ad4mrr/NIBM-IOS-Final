import SwiftUI

struct ReminderSetupView: View {
    @Environment(NotificationService.self) private var notificationService
    @State private var reminderTime = Calendar.current.date(
        bySettingHour: 19,
        minute: 0,
        second: 0,
        of: .now
    ) ?? .now
    @State private var activeDays: Set<Int> = [1, 2, 3, 4, 5]
    @State private var hasLoadedSavedReminder = false

    private let days = [
        Weekday(id: 1, shortName: "M"),
        Weekday(id: 2, shortName: "T"),
        Weekday(id: 3, shortName: "W"),
        Weekday(id: 4, shortName: "T"),
        Weekday(id: 5, shortName: "F"),
        Weekday(id: 6, shortName: "S"),
        Weekday(id: 7, shortName: "S")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                DatePicker(
                    "Reminder time",
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Active Days")
                        .font(.headline)

                    HStack {
                        ForEach(days) { day in
                            Button(day.shortName) {
                                toggle(day.id)
                            }
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(
                                activeDays.contains(day.id) ? AnatomyTheme.teal : AnatomyTheme.surface,
                                in: Circle()
                            )
                            .foregroundStyle(
                                activeDays.contains(day.id) ? Color.white : AnatomyTheme.textPrimary
                            )
                            .accessibilityLabel(day.accessibilityName)
                            .accessibilityValue(activeDays.contains(day.id) ? "Active" : "Inactive")
                            .accessibilityAddTraits(activeDays.contains(day.id) ? .isSelected : [])
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Message")
                        .font(.headline)
                    Text("Time for a 10-minute anatomy session.")
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .anatomyCard()

                VStack(alignment: .leading, spacing: 6) {
                    Label(
                        notificationService.isEnabled ? "Reminder active" : "Reminder inactive",
                        systemImage: notificationService.isEnabled ? "bell.badge.fill" : "bell.slash"
                    )
                    .font(.headline)

                    Text(notificationService.authorizationDescription)
                        .font(.footnote)
                        .foregroundStyle(AnatomyTheme.textSecondary)

                    if let message = notificationService.statusMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(AnatomyTheme.teal)
                    }

                    if let error = notificationService.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(AnatomyTheme.heart)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .anatomyCard()

                PrimaryButton("Save Reminder", systemImage: "bell.fill") {
                    Task {
                        await notificationService.saveReminder(
                            time: reminderTime,
                            activeDays: activeDays
                        )
                    }
                }

                Button("Disable Reminder", role: .destructive) {
                    notificationService.disableReminder()
                }
                    .frame(maxWidth: .infinity)
                    .disabled(!notificationService.isEnabled)
            }
            .padding()
        }
        .navigationTitle("Study Reminder")
        .anatomyScreenBackground()
        .task {
            guard !hasLoadedSavedReminder else { return }
            reminderTime = notificationService.savedTime
            activeDays = notificationService.savedActiveDays
            await notificationService.refreshAuthorizationStatus()
            hasLoadedSavedReminder = true
        }
    }

    private func toggle(_ dayID: Int) {
        if activeDays.contains(dayID) {
            activeDays.remove(dayID)
        } else {
            activeDays.insert(dayID)
        }
    }
}

private struct Weekday: Identifiable {
    let id: Int
    let shortName: String

    var accessibilityName: String {
        ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][id - 1]
    }
}
