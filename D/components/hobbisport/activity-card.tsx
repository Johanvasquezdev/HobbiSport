"use client"

import { Timer, Flame, TrendingUp, type LucideIcon } from "lucide-react"

interface ActivityCardProps {
  name: string
  icon: LucideIcon
  distance: string
  duration: string
  calories: string
}

export function ActivityCard({ name, icon: Icon, distance, duration, calories }: ActivityCardProps) {
  return (
    <div className="bg-card rounded-2xl p-4 border border-border/50 shadow-lg shadow-black/10">
      <div className="flex items-center gap-3 mb-4">
        <div className="w-12 h-12 rounded-xl bg-primary/20 flex items-center justify-center">
          <Icon className="w-6 h-6 text-primary" />
        </div>
        <h3 className="font-semibold text-foreground text-lg">{name}</h3>
      </div>
      <div className="grid grid-cols-3 gap-3">
        <div className="bg-muted/50 rounded-xl p-3 text-center">
          <TrendingUp className="w-4 h-4 text-secondary mx-auto mb-1" />
          <p className="text-xs text-muted-foreground">Distance</p>
          <p className="font-semibold text-foreground">{distance}</p>
        </div>
        <div className="bg-muted/50 rounded-xl p-3 text-center">
          <Timer className="w-4 h-4 text-primary mx-auto mb-1" />
          <p className="text-xs text-muted-foreground">Duration</p>
          <p className="font-semibold text-foreground">{duration}</p>
        </div>
        <div className="bg-muted/50 rounded-xl p-3 text-center">
          <Flame className="w-4 h-4 text-destructive mx-auto mb-1" />
          <p className="text-xs text-muted-foreground">Calories</p>
          <p className="font-semibold text-foreground">{calories}</p>
        </div>
      </div>
    </div>
  )
}
