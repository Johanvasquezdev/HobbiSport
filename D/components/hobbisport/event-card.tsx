"use client"

import { Clock, MapPin } from "lucide-react"

interface EventCardProps {
  title: string
  time: string
  location: string
  color: "primary" | "secondary" | "accent"
}

export function EventCard({ title, time, location, color }: EventCardProps) {
  const colorClasses = {
    primary: "border-l-primary bg-primary/5",
    secondary: "border-l-secondary bg-secondary/5",
    accent: "border-l-accent bg-accent/5",
  }

  const dotClasses = {
    primary: "bg-primary",
    secondary: "bg-secondary",
    accent: "bg-accent",
  }

  return (
    <div className={`rounded-xl p-4 border-l-4 ${colorClasses[color]} border border-border/30`}>
      <div className="flex items-start gap-3">
        <div className={`w-2 h-2 rounded-full mt-2 ${dotClasses[color]}`} />
        <div className="flex-1">
          <h4 className="font-semibold text-foreground">{title}</h4>
          <div className="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
            <span className="flex items-center gap-1">
              <Clock className="w-3.5 h-3.5" />
              {time}
            </span>
            <span className="flex items-center gap-1">
              <MapPin className="w-3.5 h-3.5" />
              {location}
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}
