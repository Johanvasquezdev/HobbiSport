"use client"

import { Heart, MessageCircle } from "lucide-react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"

interface PostCardProps {
  avatar: string
  username: string
  timestamp: string
  content: string
  likes: number
  comments: number
  liked?: boolean
  onLike?: () => void
}

export function PostCard({
  avatar,
  username,
  timestamp,
  content,
  likes,
  comments,
  liked = false,
  onLike,
}: PostCardProps) {
  return (
    <div className="bg-card rounded-2xl p-4 border border-border/50 shadow-lg shadow-black/10">
      <div className="flex items-center gap-3 mb-3">
        <Avatar className="w-10 h-10 ring-2 ring-primary/20">
          <AvatarImage src={avatar} alt={username} />
          <AvatarFallback className="bg-primary/20 text-primary font-medium">
            {username.slice(0, 2).toUpperCase()}
          </AvatarFallback>
        </Avatar>
        <div className="flex-1 min-w-0">
          <p className="font-semibold text-foreground truncate">{username}</p>
          <p className="text-xs text-muted-foreground">{timestamp}</p>
        </div>
      </div>
      <p className="text-foreground/90 text-sm leading-relaxed mb-4">{content}</p>
      <div className="flex items-center gap-4">
        <button
          onClick={onLike}
          className={`flex items-center gap-1.5 text-sm transition-colors ${
            liked ? "text-primary" : "text-muted-foreground hover:text-primary"
          }`}
        >
          <Heart className={`w-4 h-4 ${liked ? "fill-current" : ""}`} />
          <span>{likes}</span>
        </button>
        <button className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-secondary transition-colors">
          <MessageCircle className="w-4 h-4" />
          <span>{comments}</span>
        </button>
      </div>
    </div>
  )
}
