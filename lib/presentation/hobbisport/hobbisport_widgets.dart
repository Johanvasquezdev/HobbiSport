import 'package:flutter/material.dart';
import 'hobbisport_models.dart';
import 'hobbisport_theme.dart';

Color toneColor(BuildContext context, AccentTone tone) {
  final scheme = Theme.of(context).colorScheme;
  switch (tone) {
    case AccentTone.primary:
      return scheme.primary;
    case AccentTone.secondary:
      return scheme.secondary;
    case AccentTone.accent:
      return scheme.tertiary;
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class ScreenIntro extends StatelessWidget {
  const ScreenIntro({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class HobbyCard extends StatelessWidget {
  const HobbyCard({super.key, required this.item});

  final HobbyItem item;

  @override
  Widget build(BuildContext context) {
    final color = toneColor(context, item.tone);
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.category,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likes,
    required this.onLikePressed,
  });

  final PostItem post;
  final bool isLiked;
  final int likes;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = post.username
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: scheme.primary.withValues(alpha: 0.22),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      post.timestamp,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.92),
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _ActionCounterButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                value: '$likes',
                color: isLiked ? scheme.primary : scheme.onSurfaceVariant,
                onPressed: onLikePressed,
              ),
              const SizedBox(width: 12),
              _ActionCounterButton(
                icon: Icons.mode_comment_outlined,
                value: '${post.comments}',
                color: scheme.onSurfaceVariant,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCounterButton extends StatelessWidget {
  const _ActionCounterButton({
    required this.icon,
    required this.value,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String value;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(value),
    );
  }
}

class CalendarStripCard extends StatelessWidget {
  const CalendarStripCard({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'April 2026',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: agendaDays.map((day) {
              final selected = selectedDay == day.day;
              final dayLabelColor = selected
                  ? scheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: selected
                        ? scheme.primary
                        : Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onDaySelected(day.day),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              day.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: dayLabelColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${day.day}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: selected
                                        ? scheme.onPrimary
                                        : scheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final accent = toneColor(context, event.tone);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: accent, width: 4),
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.45)),
          right: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.45)),
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.45)),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _EventMeta(icon: Icons.access_time, label: event.time),
                    _EventMeta(icon: Icons.place_outlined, label: event.location),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMeta extends StatelessWidget {
  const _EventMeta({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: scheme.primary.withValues(alpha: 0.2),
                ),
                child: Icon(activity.icon, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  activity.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActivityMetric(
                  icon: Icons.trending_up,
                  iconColor: scheme.secondary,
                  label: 'Distance',
                  value: activity.distance,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActivityMetric(
                  icon: Icons.timer_outlined,
                  iconColor: scheme.primary,
                  label: 'Duration',
                  value: activity.duration,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActivityMetric(
                  icon: Icons.local_fire_department_outlined,
                  iconColor: scheme.error,
                  label: 'Calories',
                  value: activity.calories,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityMetric extends StatelessWidget {
  const _ActivityMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class ThemeOptionCard extends StatelessWidget {
  const ThemeOptionCard({
    super.key,
    required this.palette,
    required this.activePalette,
    required this.onTap,
  });

  final HobbiSportPalette palette;
  final HobbiSportPalette activePalette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = palette == activePalette;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? scheme.primary
                  : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.55),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Row(
                children: [
                  _ThemeSwatch(
                    color: palette.primarySwatchColor,
                    backgroundColor: scheme.surfaceContainerHigh,
                  ),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: _ThemeSwatch(
                      color: palette.secondarySwatchColor,
                      backgroundColor: scheme.surfaceContainerHigh,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      palette.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      palette.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary,
                  ),
                  child: Icon(Icons.check, color: scheme.onPrimary, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: backgroundColor, width: 2),
      ),
    );
  }
}

