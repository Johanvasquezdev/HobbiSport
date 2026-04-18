import 'package:flutter/material.dart';
import 'hobbisport_models.dart';
import 'hobbisport_theme.dart';
import 'hobbisport_widgets.dart';

class HobbiSportApp extends StatefulWidget {
  const HobbiSportApp({
    super.key,
    required this.palette,
    required this.onPaletteChanged,
  });

  final HobbiSportPalette palette;
  final ValueChanged<HobbiSportPalette> onPaletteChanged;

  @override
  State<HobbiSportApp> createState() => _HobbiSportAppState();
}

class _HobbiSportAppState extends State<HobbiSportApp> {
  HobbiSportTab _activeTab = HobbiSportTab.hobbies;

  bool get _showFab => _activeTab != HobbiSportTab.themes;

  void _openAddBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create ${_activeTab.addLabel}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'UI placeholder for quick actions.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.add),
                label: Text('Add ${_activeTab.addLabel}'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Stack(
              children: [
                Column(
                  children: [
                    _ShellHeader(
                      onAvatarTap: () {},
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: scheme.surface),
                        child: IndexedStack(
                          index: HobbiSportTab.values.indexOf(_activeTab),
                          children: [
                            const _HobbiesScreen(),
                            const _CommunityScreen(),
                            const _AgendaScreen(),
                            const _SportsScreen(),
                            _ThemesScreen(
                              activePalette: widget.palette,
                              onSelectPalette: widget.onPaletteChanged,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _BottomNavBar(
                      activeTab: _activeTab,
                      onTabChanged: (tab) => setState(() => _activeTab = tab),
                    ),
                  ],
                ),
                if (_showFab)
                  Positioned(
                    right: 16,
                    bottom: 84,
                    child: FloatingActionButton(
                      onPressed: _openAddBottomSheet,
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellHeader extends StatelessWidget {
  const _ShellHeader({required this.onAvatarTap});

  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'H',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'HobbiSport',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            onPressed: onAvatarTap,
            style: IconButton.styleFrom(
              backgroundColor: scheme.surfaceContainer,
              minimumSize: const Size(34, 34),
            ),
            icon: Text(
              'JD',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.activeTab,
    required this.onTabChanged,
  });

  final HobbiSportTab activeTab;
  final ValueChanged<HobbiSportTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.97),
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: HobbiSportTab.values.map((tab) {
          final selected = tab == activeTab;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onTabChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 20,
                          color:
                              selected ? scheme.primary : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: selected
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                                fontWeight:
                                    selected ? FontWeight.w600 : FontWeight.w500,
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
    );
  }
}

class _HobbiesScreen extends StatelessWidget {
  const _HobbiesScreen();

  @override
  Widget build(BuildContext context) {
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenIntro(
            title: 'My Hobbies',
            subtitle: 'Track and manage your interests',
          ),
          const SizedBox(height: 20),
          ...hobbiesData.map(
            (hobby) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HobbyCard(item: hobby),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityScreen extends StatefulWidget {
  const _CommunityScreen();

  @override
  State<_CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<_CommunityScreen> {
  late final Set<int> _likedPostIds;
  late final Map<int, int> _likesByPost;

  @override
  void initState() {
    super.initState();
    _likedPostIds = <int>{};
    _likesByPost = {
      for (final post in communityPosts) post.id: post.likes,
    };
  }

  void _toggleLike(PostItem post) {
    setState(() {
      if (_likedPostIds.contains(post.id)) {
        _likedPostIds.remove(post.id);
        _likesByPost[post.id] = (_likesByPost[post.id] ?? post.likes) - 1;
      } else {
        _likedPostIds.add(post.id);
        _likesByPost[post.id] = (_likesByPost[post.id] ?? post.likes) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenIntro(
            title: 'Community',
            subtitle: 'Connect with fellow enthusiasts',
          ),
          const SizedBox(height: 20),
          ...communityPosts.map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: PostCard(
                post: post,
                isLiked: _likedPostIds.contains(post.id),
                likes: _likesByPost[post.id] ?? post.likes,
                onLikePressed: () => _toggleLike(post),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaScreen extends StatefulWidget {
  const _AgendaScreen();

  @override
  State<_AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<_AgendaScreen> {
  int _selectedDay = 17;

  @override
  Widget build(BuildContext context) {
    final events = eventsByDay[_selectedDay] ?? const <EventItem>[];
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenIntro(
            title: 'Agenda',
            subtitle: 'Your upcoming activities',
          ),
          const SizedBox(height: 20),
          CalendarStripCard(
            selectedDay: _selectedDay,
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),
          const SizedBox(height: 20),
          Text(
            '${events.length} ${events.length == 1 ? 'Event' : 'Events'} Today',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Center(
                child: Text(
                  'No events scheduled for this day',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            )
          else
            ...events.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EventCard(event: event),
              ),
            ),
        ],
      ),
    );
  }
}

class _SportsScreen extends StatelessWidget {
  const _SportsScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenIntro(
            title: 'Sports',
            subtitle: 'Track your athletic activities',
          ),
          const SizedBox(height: 20),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Week',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        value: sportsSummary.totalDistance,
                        label: 'Distance',
                        color: scheme.primary,
                      ),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        value: sportsSummary.totalDuration,
                        label: 'Duration',
                        color: scheme.secondary,
                      ),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        value: sportsSummary.totalCalories,
                        label: 'Calories',
                        color: scheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recent Activities',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...sportsActivities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ActivityCard(activity: activity),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ThemesScreen extends StatelessWidget {
  const _ThemesScreen({
    required this.activePalette,
    required this.onSelectPalette,
  });

  final HobbiSportPalette activePalette;
  final ValueChanged<HobbiSportPalette> onSelectPalette;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenIntro(
            title: 'Themes',
            subtitle: 'Customize your experience',
          ),
          const SizedBox(height: 20),
          ...themeOptions.map(
            (theme) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ThemeOptionCard(
                palette: theme,
                activePalette: activePalette,
                onTap: () => onSelectPalette(theme),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.45)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Themes',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Switch between vibrant color themes to personalize your HobbiSport experience. '
                  'Each theme keeps clean contrast and readability.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageContainer extends StatelessWidget {
  const _PageContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      child: child,
    );
  }
}

