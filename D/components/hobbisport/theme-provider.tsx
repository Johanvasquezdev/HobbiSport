"use client"

import { createContext, useContext, useState, type ReactNode } from "react"

type Theme = "neon" | "sunset" | "pop"

interface ThemeContextType {
  theme: Theme
  setTheme: (theme: Theme) => void
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>("neon")

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      <div className={theme === "neon" ? "" : `theme-${theme}`}>
        {children}
      </div>
    </ThemeContext.Provider>
  )
}

export function useTheme() {
  const context = useContext(ThemeContext)
  if (!context) {
    throw new Error("useTheme must be used within a ThemeProvider")
  }
  return context
}
