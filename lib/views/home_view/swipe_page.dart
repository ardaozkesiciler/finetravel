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

  List<Widget> cards = [
    cardWidget(
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fd/48/fethiye.jpg?w=1200&h=700&s=1',
    ),
    cardWidget(
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fd/48/fethiye.jpg?w=1200&h=700&s=1',
    ),
    cardWidget(
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fd/48/fethiye.jpg?w=1200&h=700&s=1',
    ),
    cardWidget(
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fd/48/fethiye.jpg?w=1200&h=700&s=1',
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                isLoop:
                    false, //burasi loopu bitiyor yoksa hep aynilari donup duruyor.
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder:
                    (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                    ) => cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      CupertinoIcons.multiply,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.done, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undod from the ${direction.name}');
    return true;
  }
}

Widget cardWidget(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(url),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  Text(
                    'Oludeniz,Fethiye',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    'Oludeniz is a small village in Fethiye. It is 13 km away from Fethiye town center, 4 km from Hisaronu and 18 km from famous Calis Beach. Oludeniz also known as Blue Lagoon is one of the most popular holiday destinations of Turkey and Europe. Its unique sea and fantastic view makes the village popular and one of the most photographed beach of the world. Oludeniz is a beach resort, full of hotel and hostels and great restaurants and bars on the beach side. Valley is right at the edge of Babadag mountain which is again extremely popular in the world by paragliders. It’s one of the best paragliding spot of the world with its fantastic view and weather conditions.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
