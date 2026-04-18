"use client"

import { useState } from "react"
import { ThemeProvider } from "@/components/hobbisport/theme-provider"
import { BottomNav } from "@/components/hobbisport/bottom-nav"
import { FloatingActionButton } from "@/components/hobbisport/floating-action-button"
import { AddModal } from "@/components/hobbisport/add-modal"
import { HobbiesScreen } from "@/components/hobbisport/screens/hobbies-screen"
import { CommunityScreen } from "@/components/hobbisport/screens/community-screen"
import { AgendaScreen } from "@/components/hobbisport/screens/agenda-screen"
import { SportsScreen } from "@/components/hobbisport/screens/sports-screen"
import { ThemesScreen } from "@/components/hobbisport/screens/themes-screen"

const modalTypes = {
  hobbies: "hobby" as const,
  community: "post" as const,
  agenda: "event" as const,
  sports: "activity" as const,
}

export default function HobbiSportApp() {
  const [activeTab, setActiveTab] = useState("hobbies")
  const [isModalOpen, setIsModalOpen] = useState(false)

  const renderScreen = () => {
    switch (activeTab) {
      case "hobbies":
        return <HobbiesScreen />
      case "community":
        return <CommunityScreen />
      case "agenda":
        return <AgendaScreen />
      case "sports":
        return <SportsScreen />
      case "themes":
        return <ThemesScreen />
      default:
        return <HobbiesScreen />
    }
  }

  const showFab = activeTab !== "themes"

  return (
    <ThemeProvider>
      <div className="min-h-screen bg-background">
        {/* Mobile Container */}
        <div className="max-w-md mx-auto relative min-h-screen">
          {/* Header */}
          <header className="sticky top-0 z-30 bg-background/80 backdrop-blur-xl border-b border-border/50 px-4 py-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-xl bg-primary flex items-center justify-center">
                  <span className="text-primary-foreground font-bold text-sm">H</span>
                </div>
                <span className="font-bold text-foreground text-lg">HobbiSport</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center">
                  <span className="text-muted-foreground text-sm font-medium">JD</span>
                </div>
              </div>
            </div>
          </header>
          
          {/* Main Content */}
          <main className="pb-20">
            {renderScreen()}
          </main>
          
          {/* Floating Action Button */}
          {showFab && (
            <FloatingActionButton onClick={() => setIsModalOpen(true)} />
          )}
          
          {/* Bottom Navigation */}
          <BottomNav activeTab={activeTab} onTabChange={setActiveTab} />
          
          {/* Add/Edit Modal */}
          <AddModal
            isOpen={isModalOpen}
            onClose={() => setIsModalOpen(false)}
            type={modalTypes[activeTab as keyof typeof modalTypes] || "hobby"}
          />
        </div>
      </div>
    </ThemeProvider>
  )
}
