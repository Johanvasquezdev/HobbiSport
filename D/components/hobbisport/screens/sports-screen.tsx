"use client"

import { Bike, Footprints, Waves, Dumbbell, Mountain } from "lucide-react"
import { ActivityCard } from "../activity-card"

const activities = [
  {
    name: "Running",
    icon: Footprints,
    distance: "8.5 km",
    duration: "45:30",
    calories: "520",
  },
  {
    name: "Cycling",
    icon: Bike,
    distance: "25.2 km",
    duration: "1:15:00",
    calories: "680",
  },
  {
    name: "Swimming",
    icon: Waves,
    distance: "1.5 km",
    duration: "35:00",
    calories: "420",
  },
  {
    name: "Gym Workout",
    icon: Dumbbell,
    distance: "—",
    duration: "1:00:00",
    calories: "350",
  },
  {
    name: "Hiking",
    icon: Mountain,
    distance: "12.3 km",
    duration: "3:45:00",
    calories: "890",
  },
]

const weeklyStats = {
  totalDistance: "47.5 km",
  totalDuration: "7h 20m",
  totalCalories: "2,860",
}

export function SportsScreen() {
  return (
    <div className="px-4 pb-32 pt-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">Sports</h1>
        <p className="text-muted-foreground text-sm mt-1">Track your athletic activities</p>
      </div>
      
      {/* Weekly Summary */}
      <div className="bg-card rounded-2xl p-4 border border-border/50 shadow-lg shadow-black/10 mb-6">
        <h2 className="font-semibold text-foreground mb-3">This Week</h2>
        <div className="grid grid-cols-3 gap-3">
          <div className="text-center">
            <p className="text-2xl font-bold text-primary">{weeklyStats.totalDistance}</p>
            <p className="text-xs text-muted-foreground">Distance</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-secondary">{weeklyStats.totalDuration}</p>
            <p className="text-xs text-muted-foreground">Duration</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-destructive">{weeklyStats.totalCalories}</p>
            <p className="text-xs text-muted-foreground">Calories</p>
          </div>
        </div>
      </div>
      
      {/* Activities List */}
      <h2 className="font-semibold text-foreground mb-3">Recent Activities</h2>
      <div className="space-y-4">
        {activities.map((activity, index) => (
          <ActivityCard key={index} {...activity} />
        ))}
      </div>
    </div>
  )
}
