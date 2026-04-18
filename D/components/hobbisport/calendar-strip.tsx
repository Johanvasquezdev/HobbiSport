"use client"

interface CalendarStripProps {
  selectedDay: number
  onSelectDay: (day: number) => void
}

export function CalendarStrip({ selectedDay, onSelectDay }: CalendarStripProps) {
  const days = [
    { day: 14, label: "Mon" },
    { day: 15, label: "Tue" },
    { day: 16, label: "Wed" },
    { day: 17, label: "Thu" },
    { day: 18, label: "Fri" },
    { day: 19, label: "Sat" },
    { day: 20, label: "Sun" },
  ]

  return (
    <div className="bg-card rounded-2xl p-4 border border-border/50 shadow-lg shadow-black/10">
      <h3 className="font-semibold text-foreground mb-3">April 2026</h3>
      <div className="flex items-center justify-between gap-2">
        {days.map(({ day, label }) => {
          const isSelected = selectedDay === day
          return (
            <button
              key={day}
              onClick={() => onSelectDay(day)}
              className={`flex flex-col items-center gap-1 py-2 px-3 rounded-xl transition-all ${
                isSelected
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:bg-muted"
              }`}
            >
              <span className="text-xs font-medium">{label}</span>
              <span className={`text-lg font-bold ${isSelected ? "" : "text-foreground"}`}>{day}</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}
