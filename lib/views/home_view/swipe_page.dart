import 'package:finetravel/models/destination.dart';
import 'package:finetravel/data/mock_data.dart';
import 'package:finetravel/services/favorites_service.dart';
import 'package:finetravel/services/location_service.dart';
import 'package:finetravel/views/home_view/location_selection_map.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final CardSwiperController controller = CardSwiperController();
  late List<Destination> destinations;
  String activeFilter = 'All'; // 'All', 'Nearby', 'Top Rated'
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    destinations = List.from(MockData.destinations);
    MockData.destinationsNotifier.addListener(_onDestinationsChanged);
  }

  void _onDestinationsChanged() {
    if (mounted) {
      setState(() {
        destinations = List.from(MockData.destinations);
        if (activeFilter == 'Top Rated') {
          destinations.sort((a, b) => b.rating.compareTo(a.rating));
        } else if (activeFilter == 'Nearby') {
          final location = LocationService().currentLocation;
          if (location != null) {
            destinations.sort((a, b) {
              if (a.latitude == null || b.latitude == null) return 0;
              double distA = LocationService().calculateDistance(location.latitude, location.longitude, a.latitude!, a.longitude!);
              double distB = LocationService().calculateDistance(location.latitude, location.longitude, b.latitude!, b.longitude!);
              return distA.compareTo(distB);
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    MockData.destinationsNotifier.removeListener(_onDestinationsChanged);
    controller.dispose();
    super.dispose();
  }

  void _applyFilter(String filter) async {
    final locationService = LocationService();
    
    if (filter == 'Nearby') {
      // Show Permission Dialog
      bool? permissionGranted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.location_on, size: 48, color: Colors.blue),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Location Permission',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'FineTravel needs your location to show you the closest destinations. Allow access to GPS?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Deny', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Allow', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (permissionGranted == true) {
        await locationService.getCurrentLocation();
        _sortDestinationsByDistance();
      } else if (permissionGranted == false) {
        // Show manual selection map automatically if denied
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission denied. Please select location manually.')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationSelectionMap()),
          ).then((_) => _sortDestinationsByDistance());
        }
      }
    } else if (filter == 'Top Rated') {
      _sortDestinationsByRating();
    } else {
      setState(() {
        destinations = List.from(MockData.destinations);
        activeFilter = 'All';
      });
    }
  }

  void _sortDestinationsByDistance() {
    final location = LocationService().currentLocation;
    if (location == null) return;

    setState(() {
      activeFilter = 'Nearby';
      destinations.sort((a, b) {
        if (a.latitude == null || b.latitude == null) return 0;
        double distA = LocationService().calculateDistance(location.latitude, location.longitude, a.latitude!, a.longitude!);
        double distB = LocationService().calculateDistance(location.latitude, location.longitude, b.latitude!, b.longitude!);
        return distA.compareTo(distB);
      });
    });
  }

  void _sortDestinationsByRating() {
    setState(() {
      activeFilter = 'Top Rated';
      destinations.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _filterBar(),
            Expanded(
              key: ValueKey(activeFilter + destinations.length.toString()),
              child: destinations.isEmpty 
                ? const Center(child: CircularProgressIndicator())
                : CardSwiper(
                    controller: controller,
                    cardsCount: destinations.length,
                    isLoop: true,
                    onSwipe: (prev, curr, dir) {
                      setState(() => _currentIndex = curr ?? 0);
                      return _onSwipe(prev, curr, dir);
                    },
                    numberOfCardsDisplayed: destinations.length > 2 ? 3 : destinations.length,
                    backCardOffset: const Offset(0, 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    cardBuilder: (context, index, _, __) => _destinationCard(destinations[index]),
                  ),
            ),
            _actionButtons(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _filterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _filterChip('All'),
          const SizedBox(width: 10),
          _filterChip('Nearby'),
          const SizedBox(width: 10),
          _filterChip('Top Rated'),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final bool isSelected = activeFilter == label;
    return GestureDetector(
      onTap: () => _applyFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _destinationCard(Destination destination) {
    final userLoc = LocationService().currentLocation;
    String distanceText = '2.5 KM AWAY';
    if (userLoc != null && destination.latitude != null) {
      double dist = LocationService().calculateDistance(
        userLoc.latitude, userLoc.longitude, destination.latitude!, destination.longitude!
      );
      distanceText = '${dist.toStringAsFixed(1)} KM AWAY';
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Image.network(
                    destination.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      _tagChip('NATURE', Icons.terrain),
                      const SizedBox(width: 8),
                      _tagChip('ADVENTURE', Icons.directions_walk),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _distanceChip(distanceText),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          destination.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _stackedProfiles(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        destination.location,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        destination.rating.toString(),
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    destination.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _infoChip(Icons.access_time, destination.workingHours),
                      const SizedBox(width: 8),
                      _infoChip(Icons.payments_outlined, destination.entryFee),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _distanceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.send, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _stackedProfiles() {
    return SizedBox(
      width: 80,
      height: 32,
      child: Stack(
        children: [
          _profileAvatar(0, 'https://i.pravatar.cc/150?u=1'),
          _profileAvatar(1, 'https://i.pravatar.cc/150?u=2'),
          Positioned(
            left: 48,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
              ),
              child: Center(
                child: Text(
                  '+3',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileAvatar(int index, String url) {
    return Positioned(
      left: index * 24.0,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _roundButton(
            onPressed: () => controller.swipe(CardSwiperDirection.left),
            icon: Icons.close,
            color: Colors.red.withOpacity(0.2),
            iconColor: Colors.red,
            size: 60,
          ),
          _roundButton(
            onPressed: () => _showFriendPicker(context, destinations[_currentIndex]),
            icon: Icons.send_rounded,
            color: Colors.white.withOpacity(0.05),
            iconColor: Colors.blue,
            size: 60,
          ),
          _roundButton(
            onPressed: () => controller.swipe(CardSwiperDirection.right),
            icon: Icons.favorite,
            color: Theme.of(context).colorScheme.primary,
            iconColor: Colors.white,
            size: 80,
            hasShadow: true,
          ),
        ],
      ),
    );
  }

  void _showFriendPicker(BuildContext context, Destination destination) {
    final socialService = SocialService();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Share with Friend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: socialService.friends.isEmpty 
                ? const Center(child: Text('No friends yet'))
                : ListView.builder(
                    itemCount: socialService.friends.length,
                    itemBuilder: (context, index) {
                      final friend = socialService.friends[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(friend.avatarUrl)),
                        title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.send, color: Colors.blue),
                        onTap: () {
                          socialService.sendDestination(friend.id, destination.name);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sent to ${friend.name}!')),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required double size,
    bool hasShadow = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]
            : [],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: size * 0.4),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // Save to Trips when swiped in any direction
    final swipedDestination = destinations[previousIndex];
    FavoritesService().add(swipedDestination);

    debugPrint('Saved ${swipedDestination.name} to Trips');
    return true;
  }
}
