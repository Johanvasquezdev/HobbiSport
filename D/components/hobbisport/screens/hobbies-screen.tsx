"use client"

import { HobbyCard } from "../hobby-card"

const hobbies = [
  {
    name: "Mountain Biking",
    category: "Outdoor",
    description: "Exploring trails and enjoying nature on two wheels",
    categoryColor: "primary" as const,
  },
  {
    name: "Photography",
    category: "Creative",
    description: "Capturing moments and landscapes through the lens",
    categoryColor: "secondary" as const,
  },
  {
    name: "Rock Climbing",
    category: "Sports",
    description: "Challenging myself with indoor and outdoor climbing routes",
    categoryColor: "accent" as const,
  },
  {
    name: "Cooking",
    category: "Creative",
    description: "Experimenting with new recipes and cuisines from around the world",
    categoryColor: "secondary" as const,
  },
  {
    name: "Yoga",
    category: "Wellness",
    description: "Daily practice for flexibility and mental clarity",
    categoryColor: "primary" as const,
  },
]

export function HobbiesScreen() {
  return (
    <div className="px-4 pb-32 pt-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">My Hobbies</h1>
        <p className="text-muted-foreground text-sm mt-1">Track and manage your interests</p>
      </div>
      <div className="space-y-3">
        {hobbies.map((hobby, index) => (
          <HobbyCard key={index} {...hobby} />
        ))}
      </div>
    </div>
  )
}
