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
  final String greetingQuote;
  final String loreQuestion;
  final String loreAnswer;
  final String assetName;

  const GourmetRecipe({
    required this.npcName,
    required this.npcRole,
    required this.dishName,
    required this.ingredients,
    required this.greetingQuote,
    required this.loreQuestion,
    required this.loreAnswer,
    required this.assetName,
  });
}

enum SeatStatus { walkingToTable, seated, beingServed }

class ActiveCustomer {
  final int id;
  final GourmetRecipe recipe;
  final int tableIndex;
  SeatStatus status;
  int timeLeft;
  final int maxTime;
  bool loreUnlocked;
  bool choiceMade;

  ActiveCustomer({
    required this.id,
    required this.recipe,
    required this.tableIndex,
    this.status = SeatStatus.walkingToTable,
    this.timeLeft = 45,
    this.maxTime = 45,
    this.loreUnlocked = false,
    this.choiceMade = false,
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
      home: const TreehouseRestaurantScreen(),
    );
  }
}

class TreehouseRestaurantScreen extends StatefulWidget {
  const TreehouseRestaurantScreen({super.key});

  @override
  State<TreehouseRestaurantScreen> createState() =>
      _TreehouseRestaurantScreenState();
}

class _TreehouseRestaurantScreenState extends State<TreehouseRestaurantScreen>
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

  final List<GourmetRecipe> _allOrders = const [
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Truffle Pine Risotto",
      ingredients: ["Truffle", "Pine Nuts", "Artisan Cheese"],
      greetingQuote: "\"Greetings, Chef. Could you prepare a Truffle Pine Risotto?\"",
      loreQuestion: "What brings an Elven Ranger to the high canopy tonight?",
      loreAnswer: "\"Shadow wolves are migrating north. I'm scouting the ancient branches to keep trade roads safe.\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Smoked Venison Carpaccio",
      ingredients: ["Venison", "Smoked Wood", "Edible Flowers"],
      greetingQuote: "\"Good evening. I crave your famous Smoked Venison Carpaccio.\"",
      loreQuestion: "How did a noble lady cross the Whispering Woods alone?",
      loreAnswer: "\"Alone? Hardly! My royal carriage is hidden below, guarded by spells and mercenaries.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Hunter's Roost Plate",
      ingredients: ["Wild Boar", "Truffle", "Quail Egg"],
      greetingQuote: "\"Chef! Grom is starving! Make a Hunter's Roost Plate!\"",
      loreQuestion: "You look exhausted, Grom. What beast did you hunt today?",
      loreAnswer: "\"Chased a giant Iron-Tusk Boar across three rivers! It broke my axe!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Wild Berry Forest Tart",
      ingredients: ["Wild Berries", "Honeycomb", "Edible Flowers"],
      greetingQuote: "\"I need a Wild Berry Forest Tart before climbing the watchtower.\"",
      loreQuestion: "Do the high treetops remind you of your homeland?",
      loreAnswer: "\"Indeed. In Silverleaf Spire, our halls are woven into living oaks three times this height.\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Golden Honey Boar",
      ingredients: ["Wild Boar", "Honeycomb", "Pine Nuts"],
      greetingQuote: "\"Prepare the Golden Honey Boar for my table, if you please.\"",
      loreQuestion: "Why leave the High Castle for a rustic treehouse restaurant?",
      loreAnswer: "\"Court banquets are full of poison. Up here in the leaves, the only danger is overeating.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Smoked Boar Ribs",
      ingredients: ["Wild Boar", "Smoked Wood", "Wild Berries"],
      greetingQuote: "\"Grom smells campfire! Bring Smoked Boar Ribs to my table!\"",
      loreQuestion: "How did you climb all the way up the treehouse rope ladder?",
      loreAnswer: "\"Ladder? Ha! Grom grabbed a giant swinging vine and flew right onto your balcony!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Truffle Cheese Board",
      ingredients: ["Truffle", "Artisan Cheese", "Honeycomb"],
      greetingQuote: "\"A light Truffle Cheese Board while I read my maps, Chef.\"",
      loreQuestion: "Where does your secret map lead after you leave our woods?",
      loreAnswer: "\"To the Sunken Emerald Isles. Rumor says there is a spice merchant there who trades in starlight salt.\"",
      assetName: "assets/vesper.png",
    ),
    GourmetRecipe(
      npcName: "Elandor",
      npcRole: "Elven Ranger",
      dishName: "Ranger's Quail Skewer",
      ingredients: ["Quail Egg", "Venison", "Pine Nuts"],
      greetingQuote: "\"A quick Ranger's Quail Skewer, Chef. Dawn approaches.\"",
      loreQuestion: "Have you heard any strange whispers in the deep forest?",
      loreAnswer: "\"The ancient treants are waking up. The aroma from your kitchen actually puts them in a good mood!\"",
      assetName: "assets/elandor.png",
    ),
    GourmetRecipe(
      npcName: "Grom",
      npcRole: "Forest Barbarian",
      dishName: "Berry Cheese Mash",
      ingredients: ["Artisan Cheese", "Wild Berries", "Honeycomb"],
      greetingQuote: "\"Grom wants sweet sticky Berry Cheese Mash right now!\"",
      loreQuestion: "Since when does a mighty barbarian enjoy sweet cheese mash?",
      loreAnswer: "\"Grom's grandmother made it after winter battles! Sweet berries keep a warrior's heart warm!\"",
      assetName: "assets/grom.png",
    ),
    GourmetRecipe(
      npcName: "Lady Vesper",
      npcRole: "Noble Traveler",
      dishName: "Royal Venison Roast",
      ingredients: ["Venison", "Truffle", "Smoked Wood"],
      greetingQuote: "\"One final masterpiece: the Royal Venison Roast, please.\"",
      loreQuestion: "Will you recommend Canopy Cuisine to the Royal Court?",
      loreAnswer: "\"Never! If the King learns about this hidden gem, I'll never find an empty table here again!\"",
      assetName: "assets/vesper.png",
    ),
  ];

  final List<ActiveCustomer?> _tables = [null, null, null];
  int? _selectedTableIndex;
  int _nextOrderSpawnIndex = 0;
  int _completedCustomers = 0;
  final List<String> _plate = [];
  int _score = 0;
  int _streak = 0;
  bool _isGameOver = false;
  bool _isDragging = false;
  double _chefLookOffset = 0.0;

  bool _waiterBusy = false;
  int? _waiterTargetTable;

  Timer? _gameLoopTimer;
  int _secondsSinceLastSpawn = 0;

  late AnimationController _chefHeadController;
  late AnimationController _waiterController;

  @override
  void initState() {
    super.initState();
    _chefHeadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _waiterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _spawnNextCustomerIfPossible();
    _startMainGameLoop();
  }

  void _startMainGameLoop() {
    _gameLoopTimer?.cancel();
    _gameLoopTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameOver) return;
      _secondsSinceLastSpawn++;

      if (_secondsSinceLastSpawn >= 6 && _nextOrderSpawnIndex < _allOrders.length) {
        _spawnNextCustomerIfPossible();
      }

      for (int i = 0; i < _tables.length; i++) {
        final customer = _tables[i];
        if (customer != null && customer.status == SeatStatus.seated) {
          setState(() {
            customer.timeLeft--;
          });
          if (customer.timeLeft <= 0) {
            _handleCustomerWalkout(i);
          }
        }
      }
    });
  }

  void _spawnNextCustomerIfPossible() {
    if (_nextOrderSpawnIndex >= _allOrders.length) return;
    int emptyTable = _tables.indexWhere((t) => t == null);
    if (emptyTable == -1) return;

    final recipe = _allOrders[_nextOrderSpawnIndex];
    final newCustomer = ActiveCustomer(
      id: _nextOrderSpawnIndex,
      recipe: recipe,
      tableIndex: emptyTable,
      status: SeatStatus.walkingToTable,
    );

    setState(() {
      _tables[emptyTable] = newCustomer;
      _selectedTableIndex = emptyTable;
      _nextOrderSpawnIndex++;
      _secondsSinceLastSpawn = 0;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted && _tables[emptyTable]?.id == newCustomer.id) {
        setState(() {
          newCustomer.status = SeatStatus.seated;
        });
      }
    });
  }

  void _handleCustomerWalkout(int tableIdx) {
    final leavingCustomer = _tables[tableIdx];
    if (leavingCustomer == null) return;

    setState(() {
      _score = (_score - 25).clamp(0, 99999);
      _streak = 0;
      _tables[tableIdx] = null;
      _completedCustomers++;
      if (_selectedTableIndex == tableIdx) {
        _selectAnotherActiveTable();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${leavingCustomer.recipe.npcName} left Table ${tableIdx + 1} due to delay! (-25 pts)"),
        backgroundColor: Colors.redAccent,
        duration: const Duration(milliseconds: 1100),
      ),
    );
    _checkShiftFinished();
  }

  void _selectAnotherActiveTable() {
    final idx = _tables.indexWhere((t) => t != null);
    _selectedTableIndex = idx != -1 ? idx : null;
  }

  void _chooseQuickReply(ActiveCustomer customer) {
    if (customer.choiceMade) return;
    setState(() => customer.choiceMade = true);
  }

  void _chooseLoreQuestion(ActiveCustomer customer) {
    if (customer.loreUnlocked) return;
    setState(() {
      customer.loreUnlocked = true;
      customer.choiceMade = true;
      _score += 15;
      customer.timeLeft = (customer.timeLeft + 8).clamp(0, customer.maxTime);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Lore Unlocked! ${customer.recipe.npcName} chats (+15 pts & +8s patience)"),
        backgroundColor: Colors.teal.shade700,
        duration: const Duration(milliseconds: 1100),
      ),
    );
  }

  void _onIngredientDropped(String ingredient) {
    if (_isGameOver || _plate.length >= 3) return;
    setState(() {
      _plate.add(ingredient);
      _chefLookOffset = (_plate.length % 2 == 0) ? 0.22 : -0.22;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _chefLookOffset = 0.0);
    });
  }

  void _clearPlate() => setState(() => _plate.clear());

  void _ringBell() {
    if (_isGameOver || _plate.isEmpty || _waiterBusy) return;

    int? matchingTable;
    int lowestTime = 999;

    for (int i = 0; i < _tables.length; i++) {
      final cust = _tables[i];
      if (cust != null && cust.status != SeatStatus.beingServed) {
        final target = cust.recipe.ingredients;
        bool isMatch = _plate.length == target.length &&
            _plate.toSet().containsAll(target) &&
            target.toSet().containsAll(_plate);

        if (isMatch && cust.timeLeft < lowestTime) {
          lowestTime = cust.timeLeft;
          matchingTable = i;
        }
      }
    }

    if (matchingTable != null) {
      final servedCust = _tables[matchingTable]!;
      setState(() {
        _plate.clear();
        servedCust.status = SeatStatus.beingServed;
        _waiterBusy = true;
        _waiterTargetTable = matchingTable;
      });

      _waiterController.forward(from: 0.0).then((_) {
        if (!mounted) return;
        int earned = 100 + (servedCust.timeLeft * 2) + (_streak * 20);
        setState(() {
          _score += earned;
          _streak++;
          _tables[matchingTable!] = null;
          _waiterBusy = false;
          _waiterTargetTable = null;
          _completedCustomers++;
          if (_selectedTableIndex == matchingTable) {
            _selectAnotherActiveTable();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Waiter served ${servedCust.recipe.dishName} to Table ${matchingTable! + 1}! +$earned pts"),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(milliseconds: 1000),
          ),
        );
        _checkShiftFinished();
        _spawnNextCustomerIfPossible();
      });
    } else {
      setState(() {
        _score = (_score - 20).clamp(0, 99999);
        _streak = 0;
        _plate.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong dish! No seated guest ordered this (-20 pts)"),
          backgroundColor: Colors.deepOrange,
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _checkShiftFinished() {
    if (_completedCustomers >= _allOrders.length) {
      _gameLoopTimer?.cancel();
      setState(() => _isGameOver = true);
    }
  }

  void _restartShift() {
    setState(() {
      for (int i = 0; i < _tables.length; i++) {
        _tables[i] = null;
      }
      _selectedTableIndex = null;
      _nextOrderSpawnIndex = 0;
      _completedCustomers = 0;
      _plate.clear();
      _score = 0;
      _streak = 0;
      _isGameOver = false;
      _waiterBusy = false;
      _waiterTargetTable = null;
      _secondsSinceLastSpawn = 0;
    });
    _spawnNextCustomerIfPossible();
    _startMainGameLoop();
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _chefHeadController.dispose();
    _waiterController.dispose();
    super.dispose();
  }

  BoxDecoration _carvedWoodDecoration({Color? fill, double radius = 12}) {
    return BoxDecoration(
      color: fill ?? const Color(0xFF3E2723),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFF8D6E63), width: 2),
      boxShadow: const [
        BoxShadow(color: Colors.black54, offset: Offset(0, 3), blurRadius: 5),
      ],
    );
  }

  Widget _buildCustomerAvatar(GourmetRecipe recipe, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3E2723),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          recipe.assetName,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              recipe.npcName == "Elandor"
                  ? Icons.forest
                  : recipe.npcName == "Grom"
                      ? Icons.hardware
                      : Icons.auto_awesome,
              size: size * 0.55,
              color: Colors.amberAccent,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedChef() {
    return GestureDetector(
      onTap: () => setState(() => _chefLookOffset = _chefLookOffset == 0 ? 0.28 : 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _chefHeadController,
            builder: (context, child) {
              double speedMultiplier = _isDragging ? 2.2 : 1.0;
              double angle = ((_chefHeadController.value - 0.5) * 0.25 * speedMultiplier) + _chefLookOffset;
              double verticalBob = sin(_chefHeadController.value * pi) * 2.5;

              return Transform.translate(
                offset: Offset(0, -verticalBob),
                child: Transform.rotate(
                  angle: angle,
                  child: Column(
                    children: [
                      Container(
                        width: 38,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(14), bottom: Radius.circular(4)),
                        ),
                        child: const Center(child: Text("🌿", style: TextStyle(fontSize: 10))),
                      ),
                      Container(
                        width: 34,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCCBC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF5D4037), width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)),
                                Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Container(
                              width: 14,
                              height: 4,
                              decoration: BoxDecoration(color: const Color(0xFF4E342E), borderRadius: BorderRadius.circular(3)),
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
          Container(
            width: 46,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF2E4C34),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              border: Border.all(color: Colors.amber.shade700, width: 1.2),
            ),
            child: const Center(
              child: Text("CHEF", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
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
              colors: [Color(0xFF0F2617), Color(0xFF2D1B12)],
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
                  const Text("🌳🏮🍽️", style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  const Text("Treehouse Shift Complete!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                  const SizedBox(height: 8),
                  Text("Total Michelin Score: $_score", style: const TextStyle(fontSize: 19, color: Colors.greenAccent)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _restartShift,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Start New Shift"),
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

    final ActiveCustomer? activeDialogCustomer =
        (_selectedTableIndex != null) ? _tables[_selectedTableIndex!] : null;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2617), Color(0xFF261710), Color(0xFF1B110C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // 🌲 AĞAÇ EVİ KANOPİSİ VE ASMA LANTERNLER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF132E1B), Color(0xFF233D23)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border(bottom: BorderSide(color: Color(0xFF8D6E63), width: 2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("🌿🍃", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text("🏮 CANOPY TREEHOUSE FINE DINING 🏮", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amberAccent, letterSpacing: 1.1)),
                    SizedBox(width: 8),
                    Text("🍃🌿", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),

              // 1. ÜST DURUM ÇUBUĞU
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF3E2723), radius: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🌳 Treehouse", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amberAccent)),
                    Text("Guests: $_completedCustomers/${_allOrders.length}", style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    Text("Streak: $_streak🔥", style: const TextStyle(fontSize: 11, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                    Text("⭐ $_score", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.greenAccent)),
                  ],
                ),
              ),

              // 2. RESTORAN SALONU: KAPI + 3 MASA + GARSON
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                padding: const EdgeInsets.all(8),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF152418)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("🚪 Dining Hall (Tap any table to talk)", style: TextStyle(fontSize: 10, color: Colors.greenAccent)),
                        Text(
                          _waiterBusy ? "🤵 Waiter on duty!" : "🤵 Waiter ready",
                          style: const TextStyle(fontSize: 10, color: Colors.amberAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 112,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4E342E),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                  border: Border.all(color: Colors.amber.shade800, width: 1.5),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🚪", style: TextStyle(fontSize: 18)),
                                    Text("IN", style: TextStyle(fontSize: 8, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              ...List.generate(3, (tableIdx) {
                                final cust = _tables[tableIdx];
                                final isSelected = _selectedTableIndex == tableIdx && cust != null;

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: cust != null
                                        ? () => setState(() => _selectedTableIndex = tableIdx)
                                        : null,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: cust == null
                                            ? const Color(0xFF1E130D).withOpacity(0.6)
                                            : const Color(0xFF2D1B12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.amberAccent
                                              : (cust != null ? Colors.brown.shade400 : Colors.white12),
                                          width: isSelected ? 2.2 : 1.2,
                                        ),
                                      ),
                                      child: cust == null
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.table_restaurant, color: Colors.white24, size: 26),
                                                Text("Table ${tableIdx + 1}\n(Empty)", textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Colors.white30)),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("T${tableIdx + 1}: ${cust.recipe.npcName}", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                                                    Text(
                                                      "${cust.timeLeft}s",
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold,
                                                        color: cust.timeLeft <= 12 ? Colors.redAccent : Colors.greenAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                LinearProgressIndicator(
                                                  value: cust.timeLeft / cust.maxTime,
                                                  backgroundColor: Colors.black45,
                                                  color: cust.timeLeft <= 12 ? Colors.redAccent : Colors.amber,
                                                  minHeight: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    _buildCustomerAvatar(cust.recipe, size: 34),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        cust.status == SeatStatus.walkingToTable
                                                            ? "Walking..."
                                                            : cust.recipe.dishName,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontSize: 8.5, color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: cust.recipe.ingredients.map((ing) {
                                                    final item = _ingredientCatalog[ing]!;
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                                      child: Text(item.symbol, style: const TextStyle(fontSize: 12)),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          if (_waiterBusy && _waiterTargetTable != null)
                            AnimatedBuilder(
                              animation: _waiterController,
                              builder: (context, child) {
                                double t = Curves.easeInOut.transform(_waiterController.value);
                                double targetAlignX = -0.5 + (_waiterTargetTable! * 0.65);
                                double currentX = 0.9 + (targetAlignX - 0.9) * sin(t * pi);
                                double currentY = 0.8 - (sin(t * pi) * 0.7);

                                return Align(
                                  alignment: Alignment(currentX, currentY),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade800,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("🤵🍽️", style: TextStyle(fontSize: 16)),
                                        SizedBox(width: 4),
                                        Text("Serving!", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. ÖZEL KONUŞMA VE LORE SEKMESİ
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                padding: const EdgeInsets.all(8),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF281811)),
                child: activeDialogCustomer == null
                    ? const SizedBox(
                        height: 78,
                        child: Center(
                          child: Text(
                            "Waiting for guest at the treehouse door...",
                            style: TextStyle(fontSize: 11, color: Colors.white54, fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildCustomerAvatar(activeDialogCustomer.recipe, size: 36),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "💬 ${activeDialogCustomer.recipe.npcName} (Table ${activeDialogCustomer.tableIndex + 1})",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amberAccent),
                                        ),
                                        Text(
                                          "Needs: ${activeDialogCustomer.recipe.ingredients.map((e) => "${_ingredientCatalog[e]!.symbol} $e").join(" • ")}",
                                          style: const TextStyle(fontSize: 9.5, color: Colors.greenAccent, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      activeDialogCustomer.loreUnlocked
                                          ? "📖 Lore: ${activeDialogCustomer.recipe.loreAnswer}"
                                          : activeDialogCustomer.recipe.greetingQuote,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontStyle: FontStyle.italic,
                                        color: activeDialogCustomer.loreUnlocked ? Colors.cyanAccent : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: () => _chooseQuickReply(activeDialogCustomer),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: activeDialogCustomer.choiceMade && !activeDialogCustomer.loreUnlocked
                                          ? Colors.green.shade800
                                          : const Color(0xFF3E2723),
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                    ),
                                    child: const Text(
                                      "1. Right away! Cooking now.",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 9.5, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                flex: 6,
                                child: SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: activeDialogCustomer.loreUnlocked
                                        ? null
                                        : () => _chooseLoreQuestion(activeDialogCustomer),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E3F3B),
                                      disabledBackgroundColor: Colors.teal.shade900,
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                    ),
                                    child: Text(
                                      activeDialogCustomer.loreUnlocked
                                          ? "✓ Lore Learned (+15 pts)"
                                          : "2. ${activeDialogCustomer.recipe.loreQuestion}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 9.5, color: Colors.amberAccent),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),

              // 4. AÇIK MUTFAK TEZGAHI
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: _carvedWoodDecoration(fill: const Color(0xFF4E342E)),
                child: Row(
                  children: [
                    _buildAnimatedChef(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DragTarget<String>(
                        onWillAcceptWithDetails: (details) => _plate.length < 3,
                        onAcceptWithDetails: (details) => _onIngredientDropped(details.data),
                        builder: (context, candidateData, rejectedData) {
                          bool isHovering = candidateData.isNotEmpty;
                          return Container(
                            height: 68,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isHovering ? const Color(0xFF3E4E2E) : const Color(0xFF261710),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: isHovering ? Colors.greenAccent : Colors.amber.shade600,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("🍽️ Chef's Plate ", style: TextStyle(fontSize: 9.5, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                    if (_plate.isNotEmpty)
                                      GestureDetector(
                                        onTap: _clearPlate,
                                        child: const Text("(Clear 🗑️)", style: TextStyle(fontSize: 9.5, color: Colors.redAccent)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                _plate.isEmpty
                                    ? const Text("Drag 3 ingredients here!", style: TextStyle(fontSize: 10, color: Colors.white54))
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: _plate.map((ing) {
                                          final item = _ingredientCatalog[ing]!;
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 2),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: item.badgeColor,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Colors.amberAccent, width: 1),
                                            ),
                                            child: Text("${item.symbol} ${item.name}", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
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
                    GestureDetector(
                      onTap: (_plate.isNotEmpty && !_waiterBusy) ? _ringBell : null,
                      child: Container(
                        width: 64,
                        height: 68,
                        decoration: BoxDecoration(
                          color: (_plate.isNotEmpty && !_waiterBusy) ? Colors.amber.shade600 : const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amberAccent, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              size: 22,
                              color: (_plate.isNotEmpty && !_waiterBusy) ? Colors.black87 : Colors.white38,
                            ),
                            Text(
                              "CALL\nWAITER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: (_plate.isNotEmpty && !_waiterBusy) ? Colors.black87 : Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. MUTFAK RAFI (SÜRÜKLE-BIRAK)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 2, 8, 6),
                  padding: const EdgeInsets.all(6),
                  decoration: _carvedWoodDecoration(fill: const Color(0xFF2C1B12)),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: _ingredientCatalog.length,
                    itemBuilder: (context, index) {
                      final item = _ingredientCatalog.values.elementAt(index);

                      final tileWidget = Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF8D6E63), width: 1.2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.symbol, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 2),
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600, color: Colors.white),
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
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: item.badgeColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.amberAccent, width: 2.5),
                            ),
                            child: Center(child: Text(item.symbol, style: const TextStyle(fontSize: 30))),
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