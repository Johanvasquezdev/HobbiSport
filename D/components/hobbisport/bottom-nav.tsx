"use client"

import { Palette, Heart, Users, Calendar, Activity } from "lucide-react"

interface BottomNavProps {
  activeTab: string
  onTabChange: (tab: string) => void
}

export function BottomNav({ activeTab, onTabChange }: BottomNavProps) {
  const tabs = [
    { id: "hobbies", icon: Heart, label: "Hobbies" },
    { id: "community", icon: Users, label: "Community" },
    { id: "agenda", icon: Calendar, label: "Agenda" },
    { id: "sports", icon: Activity, label: "Sports" },
    { id: "themes", icon: Palette, label: "Themes" },
  ]

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-card/95 backdrop-blur-xl border-t border-border z-50">
      <div className="max-w-md mx-auto flex items-center justify-around py-2 px-2">
        {tabs.map((tab) => {
          const Icon = tab.icon
          const isActive = activeTab === tab.id
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all duration-200 ${
                isActive
                  ? "text-primary bg-primary/10"
                  : "text-muted-foreground hover:text-foreground"
              }`}
            >
              <Icon className={`w-5 h-5 ${isActive ? "scale-110" : ""}`} />
              <span className="text-xs font-medium">{tab.label}</span>
            </button>
          )
        })}
      </div>
    </nav>
  )
}
