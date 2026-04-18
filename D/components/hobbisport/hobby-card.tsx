"use client"

interface HobbyCardProps {
  name: string
  category: string
  description: string
  categoryColor?: "primary" | "secondary" | "accent"
}

export function HobbyCard({ name, category, description, categoryColor = "primary" }: HobbyCardProps) {
  const colorClasses = {
    primary: "bg-primary/20 text-primary",
    secondary: "bg-secondary/20 text-secondary",
    accent: "bg-accent/20 text-accent",
  }

  return (
    <div className="bg-card rounded-2xl p-4 border border-border/50 shadow-lg shadow-black/10 hover:shadow-xl hover:border-border transition-all duration-200">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h3 className="font-semibold text-foreground text-lg truncate">{name}</h3>
          <p className="text-muted-foreground text-sm mt-1 line-clamp-2">{description}</p>
        </div>
        <span className={`px-3 py-1 rounded-full text-xs font-medium shrink-0 ${colorClasses[categoryColor]}`}>
          {category}
        </span>
      </div>
    </div>
  )
}
