"use client"

import { useState } from "react"
import { PostCard } from "../post-card"

const initialPosts = [
  {
    id: 1,
    avatar: "",
    username: "Alex Chen",
    timestamp: "2 hours ago",
    content: "Just finished my first 10km run of the month! The sunrise was absolutely beautiful this morning. Who else is working on their running goals? 🏃‍♂️",
    likes: 24,
    comments: 8,
  },
  {
    id: 2,
    avatar: "",
    username: "Sarah Miller",
    timestamp: "5 hours ago",
    content: "Finally nailed that bouldering route I've been working on for weeks! The feeling of accomplishment is incredible. Keep pushing everyone!",
    likes: 56,
    comments: 12,
  },
  {
    id: 3,
    avatar: "",
    username: "James Wilson",
    timestamp: "1 day ago",
    content: "Looking for hiking partners this weekend. Planning to explore the Blue Ridge trail. Anyone interested in joining? Drop a comment!",
    likes: 18,
    comments: 23,
  },
  {
    id: 4,
    avatar: "",
    username: "Emma Davis",
    timestamp: "2 days ago",
    content: "Started learning pottery last week and I'm absolutely hooked! There's something so therapeutic about working with clay. Anyone else into ceramic arts?",
    likes: 42,
    comments: 15,
  },
]

export function CommunityScreen() {
  const [posts, setPosts] = useState(
    initialPosts.map((post) => ({ ...post, liked: false }))
  )

  const handleLike = (id: number) => {
    setPosts((prev) =>
      prev.map((post) =>
        post.id === id
          ? {
              ...post,
              liked: !post.liked,
              likes: post.liked ? post.likes - 1 : post.likes + 1,
            }
          : post
      )
    )
  }

  return (
    <div className="px-4 pb-32 pt-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">Community</h1>
        <p className="text-muted-foreground text-sm mt-1">Connect with fellow enthusiasts</p>
      </div>
      <div className="space-y-4">
        {posts.map((post) => (
          <PostCard
            key={post.id}
            {...post}
            onLike={() => handleLike(post.id)}
          />
        ))}
      </div>
    </div>
  )
}
