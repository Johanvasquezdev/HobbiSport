"use client"

import { useState } from "react"
import { CalendarStrip } from "../calendar-strip"
import { EventCard } from "../event-card"

const events = {
  14: [
    { title: "Morning Yoga Class", time: "7:00 AM", location: "Zen Studio", color: "primary" as const },
  ],
  15: [
    { title: "Team Basketball", time: "6:00 PM", location: "Community Gym", color: "secondary" as const },
  ],
  16: [
    { title: "Photography Walk", time: "5:30 PM", location: "City Park", color: "accent" as const },
    { title: "Dinner with Club", time: "8:00 PM", location: "The Olive", color: "primary" as const },
  ],
  17: [
    { title: "Swimming Session", time: "6:30 AM", location: "Aqua Center", color: "secondary" as const },
    { title: "Rock Climbing", time: "4:00 PM", location: "Peak Gym", color: "primary" as const },
    { title: "Book Club Meeting", time: "7:30 PM", location: "Online", color: "accent" as const },
  ],
  18: [
    { title: "Cycling Group", time: "8:00 AM", location: "Trail Head", color: "primary" as const },
  ],
  19: [
    { title: "Art Workshop", time: "10:00 AM", location: "Creative Hub", color: "accent" as const },
    { title: "Beach Volleyball", time: "3:00 PM", location: "Sunset Beach", color: "secondary" as const },
  ],
  20: [
    { title: "Rest Day", time: "All Day", location: "Home", color: "primary" as const },
  ],
}

export function AgendaScreen() {
  const [selectedDay, setSelectedDay] = useState(17)

  const dayEvents = events[selectedDay as keyof typeof events] || []

  return (
    <div className="px-4 pb-32 pt-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">Agenda</h1>
        <p className="text-muted-foreground text-sm mt-1">Your upcoming activities</p>
      </div>
      
      <CalendarStrip selectedDay={selectedDay} onSelectDay={setSelectedDay} />
      
      <div className="mt-6">
        <h2 className="font-semibold text-foreground mb-3">
          {dayEvents.length} {dayEvents.length === 1 ? "Event" : "Events"} Today
        </h2>
        <div className="space-y-3">
          {dayEvents.length > 0 ? (
            dayEvents.map((event, index) => (
              <EventCard key={index} {...event} />
            ))
          ) : (
            <div className="text-center py-8 text-muted-foreground">
              <p>No events scheduled for this day</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
