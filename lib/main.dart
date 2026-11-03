import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const CanopyCuisineApp());
}

class GourmetRecipe {
  final String npcName;
  final String npcRole;
  final String dishName;
  final List<String> ingredients;
  final String quote;

  GourmetRecipe({
    required this.npcName,
    required this.npcRole,
    required this.dishName,
    required this.ingredients,
    required this.quote,
  });
}

class CanopyCuisineApp extends StatelessWidget {
  const CanopyCuisineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canopy Cuisine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF1E2720), // Koyu orman yeşili
      ),
      home: const KitchenScreen(),
    );
  }
}

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  // 3 Farklı NPC ve onların 10 özel siparişi
  final List<GourmetRecipe> _allOrders = [
    GourmetRecipe(npcName: "Elandor", npcRole: "Elven Ranger", dishName: "Truffle Pine Risotto", ingredients: ["Truffle", "Pine Nuts", "Artisan Cheese"], quote: "\"I need a hearty meal before the long patrol.\","),
    GourmetRecipe(npcName: "Lady Vesper", npcRole: "Noble Traveler", dishName: "Smoked Venison Carpaccio", ingredients: ["Venison", "Smoked Wood", "Edible Flowers"], quote: "\"Surprise my delicate palate, chef.\","),
    GourmetRecipe(npcName: "Grom", npcRole: "Forest Barbarian", dishName: "Hunters Roost", ingredients: ["Wild Boar", "Truffle", "Quail Egg"], quote: "\"Meat! Give Grom meat and eggs!\","),
    GourmetRecipe(npcName: "Elandor", npcRole: "Elven Ranger", dishName: "Wild Berry Forest Tart", ingredients: ["Wild Berries", "Honeycomb", "Edible Flowers"], quote: "\"Something sweet, reminiscent of the deep woods.\","),
    GourmetRecipe(npcName: "Lady Vesper", npcRole: "Noble Traveler", dishName: "Golden Honey Boar", ingredients: ["Wild Boar", "Honeycomb", "Pine Nuts"], quote: "\"A rich, glazed cut would suit me well today.\","),
    GourmetRecipe(npcName: "Grom", npcRole: "Forest Barbarian", dishName: "Smoked Boar Ribs", ingredients: ["Wild Boar", "Smoked Wood", "Wild Berries"], quote: "\"Smoke it well! Make it smell like fire!\","),
    GourmetRecipe(npcName: "Lady Vesper", npcRole: "Noble Traveler", dishName: "Truffle Cheese Board", ingredients: ["Truffle", "Artisan Cheese", "Honeycomb"], quote: "\"A simple pairing of earthy and sweet.\","),
    GourmetRecipe(npcName: "Elandor", npcRole: "Elven Ranger", dishName: "Ranger's Quail Skewer", ingredients: ["Quail Egg", "Venison", "Pine Nuts"], quote: "\"Quick protein for the journey ahead.\","),
    GourmetRecipe(npcName: "Grom", npcRole: "Forest Barbarian", dishName: "Berry Cheese Mash", ingredients: ["Artisan Cheese", "Wild Berries", "Honeycomb"], quote: "\"Grom wants the sweet and sticky cheese!\","),
    GourmetRecipe(npcName: "Lady Vesper", npcRole: "Noble Traveler", dishName: "Royal Venison Roast", ingredients: ["Venison", "Truffle", "Smoked Wood"], quote: "\"The finest cut you have, smoked to perfection.\","),
  ];

  final List<String> _pantryItems = [
    "Truffle", "Pine Nuts", "Wild Berries", "Venison",
    "Edible Flowers", "Quail Egg", "Smoked Wood", 
    "Honeycomb", "Artisan Cheese", "Wild Boar"
  ];

  int _currentOrderIndex = 0;
  List<String> _plate = [];
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 40;
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 40;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      _score = (_score - 25).clamp(0, 99999);
      _streak = 0;
      _advanceOrder();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Time out! Customer left. (-25 pts)"), backgroundColor: Colors.redAccent, duration: Duration(milliseconds: 1000)),
    );
  }

  void _addToPlate(String ingredient) {
    if (_isGameOver || _plate.length >= 3) return; // Maksimum 3 malzeme
    setState(() {
      _plate.add(ingredient);
    });
  }

  void _clearPlate() {
    setState(() {
      _plate.clear();
    });
  }

  void _ringBell() {
    if (_isGameOver) return;
    
    final target = _allOrders[_currentOrderIndex].ingredients;
    
    // Malzeme sırası önemli değil, içerik tam eşleşmeli
    bool isMatch = _plate.length == target.length &&
        _plate.toSet().containsAll(target) &&
        target.toSet().containsAll(_plate);

    if (isMatch) {
      int earned = 100 + (_timeLeft * 2) + (_streak * 20);
      setState(() {
        _score += earned;
        _streak++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Perfect Plate! +$earned pts (Streak: $_streak)"), backgroundColor: Colors.green, duration: const Duration(milliseconds: 1000)),
      );
      _advanceOrder();
    } else {
      setState(() {
        _score = (_score - 20).clamp(0, 99999);
        _streak = 0;
        _plate.clear(); // Hatalı tabakta tabağı temizle
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong ingredients! (-20 pts)"), backgroundColor: Colors.orangeAccent, duration: const Duration(milliseconds: 1000)),
      );
    }
  }

  void _advanceOrder() {
    _plate.clear();
    if (_currentOrderIndex < _allOrders.length - 1) {
      setState(() {
        _currentOrderIndex++;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void _restartShift() {
    setState(() {
      _currentOrderIndex = 0;
      _plate.clear();
      _score = 0;
      _streak = 0;
      _isGameOver = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              const Text("Night Shift Ended!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
              const SizedBox(height: 8),
              Text("Total Michelin Score: $_score", style: const TextStyle(fontSize: 22, color: Colors.white)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _restartShift,
                icon: const Icon(Icons.refresh),
                label: const Text("Start New Shift"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                ),
              )
            ],
          ),
        ),
      );
    }

    final currentOrder = _allOrders[_currentOrderIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Canopy Cuisine", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
        backgroundColor: const Color(0xFF141915),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text("Score: $_score", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Üst Bilgi Barı
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF28362B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Table: ${_currentOrderIndex + 1} / ${_allOrders.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.amberAccent)),
                Row(
                  children: [
                    const Icon(Icons.hourglass_bottom, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 4),
                    Text("${_timeLeft}s", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _timeLeft <= 10 ? Colors.redAccent : Colors.white)),
                  ],
                ),
                Text("Streak: $_streak🔥", style: const TextStyle(fontSize: 16, color: Colors.orangeAccent)),
              ],
            ),
          ),
          
          // NPC ve Sipariş Kartı
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141915),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amber.shade800,
                  child: Icon(
                    currentOrder.npcName == "Elandor" ? Icons.nature_people : 
                    currentOrder.npcName == "Grom" ? Icons.fitness_center : Icons.diamond, 
                    size: 30, color: Colors.white
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(currentOrder.npcName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                          const SizedBox(width: 8),
                          Text("(${currentOrder.npcRole})", style: const TextStyle(fontSize: 12, color: Colors.white54)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(currentOrder.quote, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70, fontSize: 13)),
                      const Divider(color: Colors.white12, height: 16),
                      Text("Orders: ${currentOrder.dishName}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: currentOrder.ingredients.map((ing) => Text("• $ing", style: const TextStyle(fontSize: 11, color: Colors.white60))).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Şefin Tabağı (Plate)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Your Plate (Max 3):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                TextButton.icon(
                  onPressed: _clearPlate,
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                  label: const Text("Clear", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
          
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141915),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: _plate.isEmpty
                ? const Center(child: Text("Plate is empty. Add from pantry!", style: TextStyle(color: Colors.white38)))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _plate.map((ing) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.amber.shade900, borderRadius: BorderRadius.circular(20)),
                      child: Text(ing, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
          ),
          
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(alignment: Alignment.centerLeft, child: Text("Pantry Ingredients:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent))),
          ),
          
          // Malzeme Izgarası (Pantry)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _pantryItems.length,
              itemBuilder: (context, index) {
                final item = _pantryItems[index];
                return ElevatedButton(
                  onPressed: _plate.length < 3 ? () => _addToPlate(item) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28362B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  child: Text(item, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
          
          // Zil Çalma Butonu
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _plate.isNotEmpty ? _ringBell : null,
                icon: const Icon(Icons.notifications_active, color: Colors.black87),
                label: const Text("RING BELL (SERVE)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}