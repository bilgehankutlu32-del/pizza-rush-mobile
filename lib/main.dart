import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CanopyCuisineApp());
}

class IngredientItem {
  final String name;
  final String symbol;
  final Color badgeColor;

  const IngredientItem({
    required this.name,
    required this.symbol,
    required this.badgeColor,
  });
}

class GourmetRecipe {
  final String npcName;
  final String npcRole;
  final String dishName;
  final List<String> ingredients;
  final String quote;
  final String assetName;

  GourmetRecipe({
    required this.npcName,
    required this.npcRole,
    required this.dishName,
    required this.ingredients,
    required this.quote,
    required this.assetName,
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
        scaffoldBackgroundColor: const Color(0xFF1B120C),
      ),
      home: const TreehouseKitchenScreen(),
    );
  }
}

class TreehouseKitchenScreen extends StatefulWidget {
  const TreehouseKitchenScreen({super.key});

  @override
  State<TreehouseKitchenScreen> createState() => _TreehouseKitchenScreenState();
}

class _TreehouseKitchenScreenState extends State<TreehouseKitchenScreen>
    with TickerProviderStateMixin {
  final Map<String, IngredientItem> _ingredientCatalog = const {
    "Truffle": IngredientItem(name: "Truffle", symbol: "🍄", badgeColor: Color(0xFF5D4037)),
    "Pine Nuts": IngredientItem(name: "Pine Nuts", symbol: "🌰", badgeColor: Color(0xFF8D6E63)),
    "Wild Berries": IngredientItem(name: "Wild Berries", symbol: "🫐", badgeColor: Color(0xFF4A148C)),
    "Venison": IngredientItem(name: "Venison", symbol: "🥩", badgeColor: Color(0xFF880E4F)),
    "Edible Flowers": IngredientItem(name: "Edible Flowers", symbol: "🌸", badgeColor: Color(0xFFAD1457)),
    "Quail Egg": IngredientItem(name: "Quail Egg", symbol: "🥚", badgeColor: Color(0xFF795548)),
    "Smoked Wood": IngredientItem(name: "Smoked Wood", symbol: "🪵", badgeColor: Color(0xFF4E342E)),
    "Honeycomb": IngredientItem(name: "Honeycomb", symbol: "🍯", badgeColor: Color(0xFFFF8F00)),
    "Artisan Cheese": IngredientItem(name: "Artisan Cheese", symbol: "🧀", badgeColor: Color(0xFFF9A825)),
    "Wild Boar": IngredientItem(name: "Wild Boar", symbol: "🍖", badgeColor: Color(0xFFBF360C)),
  };

  final List<GourmetRecipe> _allOrders = [
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Truffle Pine Risotto",
      ingredients: ["Truffle", "Pine Nuts", "Artisan Cheese"],
      quote: "\"I need a hearty treetop meal before my forest patrol.\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Smoked Venison Carpaccio",
      ingredients: ["Venison", "Smoked Wood", "Edible Flowers"],
      quote: "\"Surprise my palate, chef. Only the finest woodland cuts.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Hunter's Roost Plate",
      ingredients: ["Wild Boar", "Truffle", "Quail Egg"],
      quote: "\"Meat! Give Grom roasted boar and fresh eggs!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Wild Berry Forest Tart",
      ingredients: ["Wild Berries", "Honeycomb", "Edible Flowers"],
      quote: "\"Something sweet from the high branches today.\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Golden Honey Boar",
      ingredients: ["Wild Boar", "Honeycomb", "Pine Nuts"],
      quote: "\"A rich honey-glazed cut would suit this evening.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Smoked Boar Ribs",
      ingredients: ["Wild Boar", "Smoked Wood", "Wild Berries"],
      quote: "\"Make it smoky like a true campfire feast!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Truffle Cheese Board",
      ingredients: ["Truffle", "Artisan Cheese", "Honeycomb"],
      quote: "\"An exquisite pairing of earthy truffle and wild honey.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Ranger's Quail Skewer",
      ingredients: ["Quail Egg", "Venison", "Pine Nuts"],
      quote: "\"Light and energizing for the canopy trail ahead.\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Berry Cheese Mash",
      ingredients: ["Artisan Cheese", "Wild Berries", "Honeycomb"],
      quote: "\"Grom wants sweet sticky cheese with berries!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Royal Venison Roast",
      ingredients: ["Venison", "Truffle", "Smoked Wood"],
      quote: "\"Your signature wood-smoked venison, chef.\"",
      assetName: "assets/vesper.png",
    ),
  ];

  int _currentOrderIndex = 0;
  final List<String> _plate = [];
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 40;
  Timer? _timer;
  bool _isGameOver = false;
  bool _isDragging = false;
  double _chefLookOffset = 0.0;

  late AnimationController _npcWalkController;
  late AnimationController _chefHeadController;

  @override
  void initState() {
    super.initState();
    // Müşterinin kapıdan yürüyerek gelme animasyonu
    _npcWalkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Şefin kafasını hareket ettirme animasyonu
    _chefHeadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _triggerNewCustomerEntrance();
  }

  void _triggerNewCustomerEntrance() {
    _npcWalkController.forward(from: 0.0);
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
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Time out! Guest walked out of the treehouse. (-25 pts)"),
        backgroundColor: Colors.redAccent,
        duration: Duration(milliseconds: 900),
      ),
    );
    _advanceOrder();
  }

  void _onIngredientDropped(String ingredient) {
    if (_isGameOver || _plate.length >= 3) return;
    setState(() {
      _plate.add(ingredient);
      // Malzeme bırakıldığında şef kafasını sola/sağa sevinçle sallar
      _chefLookOffset = (_plate.length % 2 == 0) ? 0.22 : -0.22;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _chefLookOffset = 0.0);
    });
  }

  void _clearPlate() {
    setState(() {
      _plate.clear();
    });
  }

  void _ringBell() {
    if (_isGameOver || _plate.isEmpty) return;
    final target = _allOrders[_currentOrderIndex].ingredients;

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
        SnackBar(
          content: Text("Bell Rung! Perfect Dish! +$earned pts (Streak: $_streak)"),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(milliseconds: 900),
        ),
      );
      _advanceOrder();
    } else {
      setState(() {
        _score = (_score - 20).clamp(0, 99999);
        _streak = 0;
        _plate.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong recipe on the plate! (-20 pts)"),
          backgroundColor: Colors.deepOrange,
          duration: Duration(milliseconds: 900),
        ),
      );
    }
  }

  void _advanceOrder() {
    _plate.clear();
    if (_currentOrderIndex < _allOrders.length - 1) {
      setState(() {
        _currentOrderIndex++;
      });
      _triggerNewCustomerEntrance();
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
    _triggerNewCustomerEntrance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _npcWalkController.dispose();
    _chefHeadController.dispose();
    super.dispose();
  }

  // Oyma Ahşap Çerçeve Dekorasyonu
  BoxDecoration _carvedWoodDecoration({Color? fill, double radius = 14}) {
    return BoxDecoration(
      color: fill ?? const Color(0xFF3E2723),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFF8D6E63), width: 2.5),
      boxShadow: const [
        BoxShadow(color: Colors.black54, offset: Offset(0, 4), blurRadius: 6),
      ],
    );
  }

  // Kafasını Hareket Ettiren Şef Karakteri Widget'ı
  Widget _buildAnimatedChef() {
    return GestureDetector(
      onTap: () {
        // Üzerine tıklayınca şef selam verir
        setState(() => _chefLookOffset = _chefLookOffset == 0 ? 0.3 : 0.0);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _chefHeadController,
            builder: (context, child) {
              // Sürekli sağa sola hafif kafa sallama + sürükleme sırasında heyecanlanma
              double speedMultiplier = _isDragging ? 2.2 : 1.0;
              double angle = ((_chefHeadController.value - 0.5) * 0.25 * speedMultiplier) + _chefLookOffset;
              double verticalBob = sin(_chefHeadController.value * pi) * 3;

              return Transform.translate(
                offset: Offset(0, -verticalBob),
                child: Transform.rotate(
                  angle: angle,
                  child: Column(
                    children: [
                      // Şef Şapkası (Toque)
                      Container(
                        width: 44,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18), bottom: Radius.circular(4)),
                        ),
                        child: const Center(
                          child: Text("🌿", style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      // Şefin Kafası ve Yüzü
                      Container(
                        width: 40,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCCBC),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF5D4037), width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Gözler
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)),
                                Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            // Bıyık / Gülümseme
                            Container(
                              width: 18,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4E342E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Şef Ceketi (Gövde)
          Container(
            width: 54,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF2E4C34),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: Colors.amber.shade700, width: 1.5),
            ),
            child: const Center(
              child: Text("CHEF", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B3022), Color(0xFF2D1B12)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: _carvedWoodDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🌲🏮🌲", style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  const Text("Treehouse Shift Complete!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                  const SizedBox(height: 8),
                  Text("Final Michelin Score: $_score", style: const TextStyle(fontSize: 20, color: Colors.greenAccent)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _restartShift,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Open Treehouse Again"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentOrder = _allOrders[_currentOrderIndex];

    return Scaffold(
      body: SafeArea(
        child: Container(
          // Ağaç Tepesi Orman ve Ahşap Ambiyans Arka Planı
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F2617), // Ağaç tepesi yaprak gölgesi
                Color(0xFF261710), // Oyma ahşap gövde
                Color(0xFF1B110C), // Mutfak zemini
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // 1. AHŞap OYMA TAVAN KİRİŞİ (ÜST BAR)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF3E2723), radius: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("🌳 ", style: TextStyle(fontSize: 18)),
                        Text("Canopy Treehouse", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amberAccent)),
                      ],
                    ),
                    Text("Guest: ${_currentOrderIndex + 1}/10", style: const TextStyle(fontSize: 13, color: Colors.white70)),
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.orangeAccent, size: 16),
                        const SizedBox(width: 3),
                        Text("${_timeLeft}s", style: TextStyle(fontWeight: FontWeight.bold, color: _timeLeft <= 10 ? Colors.redAccent : Colors.white)),
                      ],
                    ),
                    Text("⭐ $_score", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.greenAccent)),
                  ],
                ),
              ),

              // 2. AĞAÇ EV AÇIK PENCERESİ VE KAPIDAN YÜRÜYEREK GİREN MÜŞTERİ ALANI
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                padding: const EdgeInsets.all(10),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF16261A)),
                child: Column(
                  children: [
                    // Üst Süsleme: Sarmaşıklar ve Fenerler
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("🌿🪵 Treehouse Archway Door", style: TextStyle(fontSize: 11, color: Colors.greenAccent)),
                        Text("Streak: $_streak 🔥", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 105,
                      child: Row(
                        children: [
                          // Sol: Ahşap Oyma Giriş Kapısı
                          Container(
                            width: 46,
                            height: 95,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4E342E),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              border: Border.all(color: Colors.amber.shade800, width: 2),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🚪", style: TextStyle(fontSize: 22)),
                                Text("DOOR", style: TextStyle(fontSize: 8, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Orta & Sağ: Kapıdan İçeri Yürüyen NPC ve Sipariş Balonu
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _npcWalkController,
                              builder: (context, child) {
                                // 0.0 (Kapıda) -> 1.0 (Tezgahta)
                                double progress = Curves.easeOut.transform(_npcWalkController.value);
                                // Yürürken yukarı-aşağı adım sallantısı
                                double walkBounce = _npcWalkController.isAnimating
                                    ? sin(_npcWalkController.value * pi * 8).abs() * 8
                                    : 0.0;

                                return Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    // Yürüyen Karakter Portresi
                                    Align(
                                      alignment: Alignment(-1.0 + (progress * 0.25), 0.0),
                                      child: Transform.translate(
                                        offset: Offset(0, -walkBounce),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFF3E2723),
                                                border: Border.all(color: Colors.amber, width: 2.5),
                                              ),
                                              child: ClipOval(
                                                child: Image.asset(
                                                  currentOrder.assetName,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      currentOrder.npcName == "Elandor"
                                                          ? Icons.forest
                                                          : currentOrder.npcName == "Grom"
                                                              ? Icons.hardware
                                                              : Icons.auto_awesome,
                                                      size: 32,
                                                      color: Colors.amberAccent,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _npcWalkController.isAnimating ? "Walking in..." : currentOrder.npcName,
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Karakter tezgaha yaklaşınca açılan sipariş balonu
                                    if (progress > 0.65)
                                      Positioned(
                                        left: 82,
                                        right: 0,
                                        child: Opacity(
                                          opacity: ((progress - 0.65) / 0.35).clamp(0.0, 1.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2D1B12),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.amber.withOpacity(0.5)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${currentOrder.dishName} (${currentOrder.npcRole})",
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.greenAccent),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  currentOrder.quote,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 10, color: Colors.white70),
                                                ),
                                                const SizedBox(height: 5),
                                                Wrap(
                                                  spacing: 6,
                                                  runSpacing: 2,
                                                  children: currentOrder.ingredients.map((ing) {
                                                    final item = _ingredientCatalog[ing]!;
                                                    return Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text("${item.symbol} $ing", style: const TextStyle(fontSize: 10, color: Colors.amberAccent)),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. AÇIK MUTFAK TEZGAHI: KAFASI HAREKET EDEN ŞEF + SÜRÜKLE-BIRAK AHŞAP TABAK + ZİL
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF4E342E)),
                child: Row(
                  children: [
                    // Sol: Kafasını Hareket Ettiren Şefimiz
                    _buildAnimatedChef(),
                    const SizedBox(width: 10),

                    // Orta: Sürükle-Bırak Hedef Tabağı (DragTarget)
                    Expanded(
                      child: DragTarget<String>(
                        onWillAcceptWithDetails: (details) => _plate.length < 3,
                        onAcceptWithDetails: (details) => _onIngredientDropped(details.data),
                        builder: (context, candidateData, rejectedData) {
                          bool isHovering = candidateData.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 82,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isHovering ? const Color(0xFF3E4E2E) : const Color(0xFF261710),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: isHovering ? Colors.greenAccent : Colors.amber.shade600,
                                width: isHovering ? 3 : 2,
                              ),
                              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, inset: false)],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("🍽️ Carved Wooden Plate ", style: TextStyle(fontSize: 10, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                    if (_plate.isNotEmpty)
                                      GestureDetector(
                                        onTap: _clearPlate,
                                        child: const Text("(Clear 🗑️)", style: TextStyle(fontSize: 10, color: Colors.redAccent)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _plate.isEmpty
                                    ? const Text(
                                        "Drag & drop 3 ingredients here!",
                                        style: TextStyle(fontSize: 11, color: Colors.white54, fontStyle: FontStyle.italic),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: _plate.map((ing) {
                                          final item = _ingredientCatalog[ing]!;
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: item.badgeColor,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: Colors.amberAccent, width: 1),
                                            ),
                                            child: Text(
                                              "${item.symbol} ${item.name}",
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Sağ: Tezgah Üstü Servis Zili
                    GestureDetector(
                      onTap: _plate.isNotEmpty ? _ringBell : null,
                      child: Container(
                        width: 66,
                        height: 82,
                        decoration: BoxDecoration(
                          color: _plate.isNotEmpty ? Colors.amber.shade600 : const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amberAccent, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              size: 28,
                              color: _plate.isNotEmpty ? Colors.black87 : Colors.white38,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "RING\nBELL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _plate.isNotEmpty ? Colors.black87 : Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. OYMA AHŞAP MUTFAK RAFI (SÜRÜKLENEBİLİR GÖRSEL MALZEMELER)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "🪵 Open Kitchen Pantry (Drag ingredients onto the plate):",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                  padding: const EdgeInsets.all(8),
                  decoration: _carvedWoodDecoration(fill: const Color(0xFF2C1B12)),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _ingredientCatalog.length,
                    itemBuilder: (context, index) {
                      final item = _ingredientCatalog.values.elementAt(index);

                      final tileWidget = Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF8D6E63), width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.symbol, style: const TextStyle(fontSize: 26)),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                item.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );

                      return Draggable<String>(
                        data: item.name,
                        onDragStarted: () => setState(() => _isDragging = true),
                        onDragEnd: (_) => setState(() => _isDragging = false),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: item.badgeColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.amberAccent, width: 3),
                              boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)],
                            ),
                            child: Center(
                              child: Text(item.symbol, style: const TextStyle(fontSize: 34)),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(opacity: 0.35, child: tileWidget),
                        child: tileWidget,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}