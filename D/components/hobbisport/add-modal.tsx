"use client"

import { X } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"

interface AddModalProps {
  isOpen: boolean
  onClose: () => void
  type: "hobby" | "post" | "event" | "activity"
}

export function AddModal({ isOpen, onClose, type }: AddModalProps) {
  if (!isOpen) return null

  const titles = {
    hobby: "Add New Hobby",
    post: "Create Post",
    event: "Add Event",
    activity: "Log Activity",
  }

  const placeholders = {
    hobby: "Hobby name...",
    post: "What&apos;s on your mind?",
    event: "Event title...",
    activity: "Activity name...",
  }

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} />
      <div className="relative w-full max-w-md bg-card rounded-t-3xl sm:rounded-3xl p-6 border border-border/50 shadow-2xl animate-in slide-in-from-bottom duration-300">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold text-foreground">{titles[type]}</h2>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-muted flex items-center justify-center text-muted-foreground hover:text-foreground transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
        
        <div className="space-y-4">
          <div>
            <label className="text-sm font-medium text-foreground mb-2 block">
              {type === "post" ? "Content" : "Name"}
            </label>
            <Input 
              placeholder={placeholders[type]}
              className="bg-muted border-border/50 focus:border-primary"
            />
          </div>
          
          {type === "hobby" && (
            <div>
              <label className="text-sm font-medium text-foreground mb-2 block">Category</label>
              <Input 
                placeholder="e.g., Sports, Creative, Outdoor..."
                className="bg-muted border-border/50 focus:border-primary"
              />
            </div>
          )}
          
          {type === "event" && (
            <>
              <div>
                <label className="text-sm font-medium text-foreground mb-2 block">Time</label>
                <Input 
                  type="time"
                  className="bg-muted border-border/50 focus:border-primary"
                />
              </div>
              <div>
                <label className="text-sm font-medium text-foreground mb-2 block">Location</label>
                <Input 
                  placeholder="Where is it?"
                  className="bg-muted border-border/50 focus:border-primary"
                />
              </div>
            </>
          )}
          
          {type === "activity" && (
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="text-sm font-medium text-foreground mb-2 block">Distance</label>
                <Input 
                  placeholder="0.0 km"
                  className="bg-muted border-border/50 focus:border-primary"
                />
              </div>
              <div>
                <label className="text-sm font-medium text-foreground mb-2 block">Duration</label>
                <Input 
                  placeholder="00:00"
                  className="bg-muted border-border/50 focus:border-primary"
                />
              </div>
            </div>
          )}
          
          <div>
            <label className="text-sm font-medium text-foreground mb-2 block">Description</label>
            <textarea
              placeholder="Add some details..."
              className="w-full h-24 px-3 py-2 bg-muted border border-border/50 rounded-lg focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 resize-none text-foreground placeholder:text-muted-foreground"
            />
          </div>
          
          <div className="flex gap-3 pt-2">
            <Button
              variant="outline"
              className="flex-1"
              onClick={onClose}
            >
              Cancel
            </Button>
            <Button className="flex-1 bg-primary text-primary-foreground hover:bg-primary/90">
              {type === "post" ? "Post" : "Save"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
