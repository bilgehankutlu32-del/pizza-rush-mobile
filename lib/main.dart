import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PizzaRushApp());
}

class PizzaRecipe {
  final String name;
  final List<String> ingredients;
  final String description;

  PizzaRecipe({
    required this.name,
    required this.ingredients,
    required this.description,
  });
}

class PizzaRushApp extends StatelessWidget {
  const PizzaRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Rush Express',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),
      home: const PizzaGameScreen(),
    );
  }
}

class PizzaGameScreen extends StatefulWidget {
  const PizzaGameScreen({super.key});

  @override
  State<PizzaGameScreen> createState() => _PizzaGameScreenState();
}

class _PizzaGameScreenState extends State<PizzaGameScreen> {
  final List<PizzaRecipe> _allRecipes = [
    PizzaRecipe(name: "Classic Margherita", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Basil"], description: "Simple Italian classic"),
    PizzaRecipe(name: "Pepperoni Feast", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Pepperoni"], description: "Loaded with spicy pepperoni"),
    PizzaRecipe(name: "BBQ Chicken", ingredients: ["Dough", "BBQ Sauce", "Mozzarella", "Chicken", "Onions"], description: "Smoky grilled chicken flavor"),
    PizzaRecipe(name: "Veggie Garden", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Mushroom", "Bell Pepper", "Olives"], description: "Fresh garden vegetables"),
    PizzaRecipe(name: "Hawaiian Sunset", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Ham", "Pineapple"], description: "Sweet pineapple and savory ham"),
    PizzaRecipe(name: "Quattro Formaggi", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Parmesan", "Gorgonzola"], description: "Rich blend of 4 cheeses"),
    PizzaRecipe(name: "Meat Lover's", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Pepperoni", "Sausage", "Bacon"], description: "Hearty combo of premium meats"),
    PizzaRecipe(name: "Spicy Diavola", ingredients: ["Dough", "Tomato Sauce", "Mozzarella", "Hot Salami", "Chili Flakes"], description: "Fiery Italian kick"),
    PizzaRecipe(name: "Truffle Mushroom", ingredients: ["Dough", "White Sauce", "Mozzarella", "Mushroom", "Truffle Oil"], description: "Earthy luxury gourmet pizza"),
    PizzaRecipe(name: "Buffalo Kick", ingredients: ["Dough", "Buffalo Sauce", "Mozzarella", "Chicken", "Jalapeno"], description: "Tangy and spicy street-style"),
  ];

  final List<String> _availableIngredients = [
    "Dough", "Tomato Sauce", "BBQ Sauce", "White Sauce", "Buffalo Sauce",
    "Mozzarella", "Parmesan", "Gorgonzola", "Pepperoni", "Sausage",
    "Bacon", "Ham", "Chicken", "Hot Salami", "Mushroom",
    "Bell Pepper", "Olives", "Onions", "Pineapple", "Basil",
    "Chili Flakes", "Truffle Oil", "Jalapeno"
  ];

  int _currentRecipeIndex = 0;
  List<String> _selectedIngredients = [];
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 35;
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 35;
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
      const SnackBar(content: Text("Time out! Order missed (-25 pts)"), backgroundColor: Colors.redAccent, duration: Duration(milliseconds: 900)),
    );
  }

  void _addIngredient(String ingredient) {
    if (_isGameOver) return;
    setState(() {
      _selectedIngredients.add(ingredient);
    });
  }

  void _clearPizza() {
    setState(() {
      _selectedIngredients.clear();
    });
  }

  void _servePizza() {
    if (_isGameOver) return;
    final target = _allRecipes[_currentRecipeIndex].ingredients;
    
    bool isMatch = _selectedIngredients.length == target.length &&
        _selectedIngredients.toSet().containsAll(target) &&
        target.toSet().containsAll(_selectedIngredients);

    if (isMatch) {
      int earned = 100 + (_timeLeft * 2) + (_streak * 20);
      setState(() {
        _score += earned;
        _streak++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Perfect Serve! +$earned pts (Streak: $_streak)"), backgroundColor: Colors.green, duration: const Duration(milliseconds: 900)),
      );
      _advanceOrder();
    } else {
      setState(() {
        _score = (_score - 20).clamp(0, 99999);
        _streak = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect recipe! (-20 pts)"), backgroundColor: Colors.orangeAccent, duration: const Duration(milliseconds: 900)),
      );
    }
  }

  void _advanceOrder() {
    _selectedIngredients.clear();
    if (_currentRecipeIndex < _allRecipes.length - 1) {
      setState(() {
        _currentRecipeIndex++;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _currentRecipeIndex = 0;
      _selectedIngredients.clear();
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
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              const Text("Shift Completed!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Final Score: $_score Points", style: const TextStyle(fontSize: 22, color: Colors.greenAccent)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _restartGame,
                icon: const Icon(Icons.refresh),
                label: const Text("Play Again"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              )
            ],
          ),
        ),
      );
    }

    final currentRecipe = _allRecipes[_currentRecipeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pizza Rush Express", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange.shade800,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text("Score: $_score", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF2B2C40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order: ${_currentRecipeIndex + 1} / ${_allRecipes.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 4),
                    Text("${_timeLeft}s", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _timeLeft <= 10 ? Colors.redAccent : Colors.white)),
                  ],
                ),
                Text("Streak: $_streak🔥", style: const TextStyle(fontSize: 16, color: Colors.orangeAccent)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            color: const Color(0xFF32344A),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Request: ${currentRecipe.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent)),
                  const SizedBox(height: 4),
                  Text(currentRecipe.description, style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white24, height: 16),
                  const Text("Required Ingredients:", style: TextStyle(fontSize: 13, color: Colors.white54)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: currentRecipe.ingredients.map((ing) => Chip(
                      label: Text(ing, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.deepOrange.withOpacity(0.2),
                      side: const BorderSide(color: Colors.deepOrange),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Your Pizza Tray:", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _clearPizza,
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                  label: const Text("Clear", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF232435),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: _selectedIngredients.isEmpty
                ? const Center(child: Text("Tray is empty. Tap ingredients below!", style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedIngredients.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.teal.shade700, borderRadius: BorderRadius.circular(16)),
                      child: Text(_selectedIngredients[index], style: const TextStyle(fontSize: 12)),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(alignment: Alignment.centerLeft, child: Text("Pantry Shelf:", style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _availableIngredients.length,
              itemBuilder: (context, index) {
                final item = _availableIngredients[index];
                return ElevatedButton(
                  onPressed: () => _addIngredient(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F415D),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  child: Text(item, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _servePizza,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("SERVE PIZZA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              ),
            ),
          )
        ],
      ),
    );
  }
}
