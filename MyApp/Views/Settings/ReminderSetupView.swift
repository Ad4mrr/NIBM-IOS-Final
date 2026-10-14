import SwiftUI

struct ReminderSetupView: View {
    @State private var reminderTime = Calendar.current.date(
        bySettingHour: 19,
        minute: 0,
        second: 0,
        of: .now
    ) ?? .now
    @State private var activeDays: Set<Int> = [1, 2, 3, 4, 5]

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
                .labelsHidden()
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

                PrimaryButton("Save Reminder", systemImage: "bell.fill") { }

                Button("Disable Reminder", role: .destructive) { }
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Study Reminder")
        .anatomyScreenBackground()
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
