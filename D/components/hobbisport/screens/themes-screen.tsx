"use client"

import { Check } from "lucide-react"
import { useTheme } from "../theme-provider"

const themes = [
  {
    id: "neon" as const,
    name: "Neon",
    description: "Coral + Cyan vibes",
    colors: ["#ff6b6b", "#4ecdc4"],
  },
  {
    id: "sunset" as const,
    name: "Sunset",
    description: "Orange + Purple warmth",
    colors: ["#ff9f43", "#a55eea"],
  },
  {
    id: "pop" as const,
    name: "Pop",
    description: "Lime + Pink energy",
    colors: ["#a8e6cf", "#ff8fab"],
  },
]

export function ThemesScreen() {
  const { theme, setTheme } = useTheme()

  return (
    <div className="px-4 pb-32 pt-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">Themes</h1>
        <p className="text-muted-foreground text-sm mt-1">Customize your experience</p>
      </div>
      
      <div className="space-y-4">
        {themes.map((t) => {
          const isActive = theme === t.id
          return (
            <button
              key={t.id}
              onClick={() => setTheme(t.id)}
              className={`w-full bg-card rounded-2xl p-4 border-2 transition-all text-left ${
                isActive
                  ? "border-primary shadow-lg shadow-primary/20"
                  : "border-border/50 hover:border-border"
              }`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="flex -space-x-2">
                    {t.colors.map((color, i) => (
                      <div
                        key={i}
                        className="w-10 h-10 rounded-full border-2 border-card"
                        style={{ backgroundColor: color }}
                      />
                    ))}
                  </div>
                  <div>
                    <h3 className="font-semibold text-foreground">{t.name}</h3>
                    <p className="text-sm text-muted-foreground">{t.description}</p>
                  </div>
                </div>
                {isActive && (
                  <div className="w-6 h-6 rounded-full bg-primary flex items-center justify-center">
                    <Check className="w-4 h-4 text-primary-foreground" />
                  </div>
                )}
              </div>
            </button>
          )
        })}
      </div>
      
      <div className="mt-8 p-4 bg-muted/30 rounded-2xl border border-border/30">
        <h3 className="font-semibold text-foreground mb-2">About Themes</h3>
        <p className="text-sm text-muted-foreground leading-relaxed">
          Switch between vibrant color themes to personalize your HobbiSport experience. 
          Each theme brings a unique aesthetic while maintaining excellent readability and contrast.
        </p>
      </div>
    </div>
  )
}
