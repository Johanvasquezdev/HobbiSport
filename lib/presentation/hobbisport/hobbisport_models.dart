import 'package:flutter/material.dart';
import 'hobbisport_theme.dart';

enum AccentTone { primary, secondary, accent }

enum HobbiSportTab { hobbies, community, agenda, sports, themes }

extension HobbiSportTabX on HobbiSportTab {
  String get label {
    switch (this) {
      case HobbiSportTab.hobbies:
        return 'Hobbies';
      case HobbiSportTab.community:
        return 'Community';
      case HobbiSportTab.agenda:
        return 'Agenda';
      case HobbiSportTab.sports:
        return 'Sports';
      case HobbiSportTab.themes:
        return 'Themes';
    }
  }

  IconData get icon {
    switch (this) {
      case HobbiSportTab.hobbies:
        return Icons.favorite_outline;
      case HobbiSportTab.community:
        return Icons.groups_outlined;
      case HobbiSportTab.agenda:
        return Icons.calendar_month_outlined;
      case HobbiSportTab.sports:
        return Icons.fitness_center_outlined;
      case HobbiSportTab.themes:
        return Icons.palette_outlined;
    }
  }

  String get addLabel {
    switch (this) {
      case HobbiSportTab.hobbies:
        return 'New hobby';
      case HobbiSportTab.community:
        return 'New post';
      case HobbiSportTab.agenda:
        return 'New event';
      case HobbiSportTab.sports:
        return 'New activity';
      case HobbiSportTab.themes:
        return 'Theme';
    }
  }
}

class HobbyItem {
  const HobbyItem({
    required this.name,
    required this.category,
    required this.description,
    required this.tone,
  });

  final String name;
  final String category;
  final String description;
  final AccentTone tone;
}

class PostItem {
  const PostItem({
    required this.id,
    required this.username,
    required this.timestamp,
    required this.content,
    required this.likes,
    required this.comments,
  });

  final int id;
  final String username;
  final String timestamp;
  final String content;
  final int likes;
  final int comments;
}

class AgendaDay {
  const AgendaDay({
    required this.day,
    required this.label,
  });

  final int day;
  final String label;
}

class EventItem {
  const EventItem({
    required this.title,
    required this.time,
    required this.location,
    required this.tone,
  });

  final String title;
  final String time;
  final String location;
  final AccentTone tone;
}

class ActivityItem {
  const ActivityItem({
    required this.name,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.icon,
  });

  final String name;
  final String distance;
  final String duration;
  final String calories;
  final IconData icon;
}

class WeeklyStats {
  const WeeklyStats({
    required this.totalDistance,
    required this.totalDuration,
    required this.totalCalories,
  });

  final String totalDistance;
  final String totalDuration;
  final String totalCalories;
}

const hobbiesData = <HobbyItem>[
  HobbyItem(
    name: 'Mountain Biking',
    category: 'Outdoor',
    description: 'Exploring trails and enjoying nature on two wheels',
    tone: AccentTone.primary,
  ),
  HobbyItem(
    name: 'Photography',
    category: 'Creative',
    description: 'Capturing moments and landscapes through the lens',
    tone: AccentTone.secondary,
  ),
  HobbyItem(
    name: 'Rock Climbing',
    category: 'Sports',
    description: 'Challenging myself with indoor and outdoor climbing routes',
    tone: AccentTone.accent,
  ),
  HobbyItem(
    name: 'Cooking',
    category: 'Creative',
    description:
        'Experimenting with new recipes and cuisines from around the world',
    tone: AccentTone.secondary,
  ),
  HobbyItem(
    name: 'Yoga',
    category: 'Wellness',
    description: 'Daily practice for flexibility and mental clarity',
    tone: AccentTone.primary,
  ),
];

const communityPosts = <PostItem>[
  PostItem(
    id: 1,
    username: 'Alex Chen',
    timestamp: '2 hours ago',
    content:
        'Just finished my first 10km run of the month! The sunrise was absolutely beautiful this morning. Who else is working on their running goals?',
    likes: 24,
    comments: 8,
  ),
  PostItem(
    id: 2,
    username: 'Sarah Miller',
    timestamp: '5 hours ago',
    content:
        "Finally nailed that bouldering route I've been working on for weeks! The feeling of accomplishment is incredible. Keep pushing everyone!",
    likes: 56,
    comments: 12,
  ),
  PostItem(
    id: 3,
    username: 'James Wilson',
    timestamp: '1 day ago',
    content:
        'Looking for hiking partners this weekend. Planning to explore the Blue Ridge trail. Anyone interested in joining? Drop a comment!',
    likes: 18,
    comments: 23,
  ),
  PostItem(
    id: 4,
    username: 'Emma Davis',
    timestamp: '2 days ago',
    content:
        "Started learning pottery last week and I'm absolutely hooked! There's something so therapeutic about working with clay. Anyone else into ceramic arts?",
    likes: 42,
    comments: 15,
  ),
];

const agendaDays = <AgendaDay>[
  AgendaDay(day: 14, label: 'Mon'),
  AgendaDay(day: 15, label: 'Tue'),
  AgendaDay(day: 16, label: 'Wed'),
  AgendaDay(day: 17, label: 'Thu'),
  AgendaDay(day: 18, label: 'Fri'),
  AgendaDay(day: 19, label: 'Sat'),
  AgendaDay(day: 20, label: 'Sun'),
];

const eventsByDay = <int, List<EventItem>>{
  14: [
    EventItem(
      title: 'Morning Yoga Class',
      time: '7:00 AM',
      location: 'Zen Studio',
      tone: AccentTone.primary,
    ),
  ],
  15: [
    EventItem(
      title: 'Team Basketball',
      time: '6:00 PM',
      location: 'Community Gym',
      tone: AccentTone.secondary,
    ),
  ],
  16: [
    EventItem(
      title: 'Photography Walk',
      time: '5:30 PM',
      location: 'City Park',
      tone: AccentTone.accent,
    ),
    EventItem(
      title: 'Dinner with Club',
      time: '8:00 PM',
      location: 'The Olive',
      tone: AccentTone.primary,
    ),
  ],
  17: [
    EventItem(
      title: 'Swimming Session',
      time: '6:30 AM',
      location: 'Aqua Center',
      tone: AccentTone.secondary,
    ),
    EventItem(
      title: 'Rock Climbing',
      time: '4:00 PM',
      location: 'Peak Gym',
      tone: AccentTone.primary,
    ),
    EventItem(
      title: 'Book Club Meeting',
      time: '7:30 PM',
      location: 'Online',
      tone: AccentTone.accent,
    ),
  ],
  18: [
    EventItem(
      title: 'Cycling Group',
      time: '8:00 AM',
      location: 'Trail Head',
      tone: AccentTone.primary,
    ),
  ],
  19: [
    EventItem(
      title: 'Art Workshop',
      time: '10:00 AM',
      location: 'Creative Hub',
      tone: AccentTone.accent,
    ),
    EventItem(
      title: 'Beach Volleyball',
      time: '3:00 PM',
      location: 'Sunset Beach',
      tone: AccentTone.secondary,
    ),
  ],
  20: [
    EventItem(
      title: 'Rest Day',
      time: 'All Day',
      location: 'Home',
      tone: AccentTone.primary,
    ),
  ],
};

const sportsActivities = <ActivityItem>[
  ActivityItem(
    name: 'Running',
    icon: Icons.directions_run,
    distance: '8.5 km',
    duration: '45:30',
    calories: '520',
  ),
  ActivityItem(
    name: 'Cycling',
    icon: Icons.directions_bike,
    distance: '25.2 km',
    duration: '1:15:00',
    calories: '680',
  ),
  ActivityItem(
    name: 'Swimming',
    icon: Icons.pool_outlined,
    distance: '1.5 km',
    duration: '35:00',
    calories: '420',
  ),
  ActivityItem(
    name: 'Gym Workout',
    icon: Icons.fitness_center,
    distance: '-',
    duration: '1:00:00',
    calories: '350',
  ),
  ActivityItem(
    name: 'Hiking',
    icon: Icons.terrain_outlined,
    distance: '12.3 km',
    duration: '3:45:00',
    calories: '890',
  ),
];

const sportsSummary = WeeklyStats(
  totalDistance: '47.5 km',
  totalDuration: '7h 20m',
  totalCalories: '2,860',
);

const themeOptions = <HobbiSportPalette>[
  HobbiSportPalette.neon,
  HobbiSportPalette.sunset,
  HobbiSportPalette.pop,
];
