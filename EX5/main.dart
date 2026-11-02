import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

// ---------------- PRODUCT MODEL ----------------

class Product {
  final String name;
  final double price;
  final String category;
  final String image;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}

// ---------------- PRODUCT DATA ----------------

final List<Product> products = [
  Product(
    name: "iPhone 15",
    price: 69999,
    category: "Electronics",
    image: "https://picsum.photos/200?1",
  ),
  Product(
    name: "Laptop",
    price: 59999,
    category: "Electronics",
    image: "https://picsum.photos/200?2",
  ),
  Product(
    name: "T-Shirt",
    price: 999,
    category: "Clothing",
    image: "https://picsum.photos/200?3",
  ),
  Product(
    name: "Shoes",
    price: 2499,
    category: "Clothing",
    image: "https://picsum.photos/200?4",
  ),
  Product(
    name: "Watch",
    price: 1999,
    category: "Accessories",
    image: "https://picsum.photos/200?5",
  ),
];

// ---------------- MAIN APP ----------------

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Shopping Application",

      // Named Routes
      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/products': (context) => const ProductListScreen(),
      },
    );
  }
}

// ---------------- HOME SCREEN ----------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeContent(),
    const ProductListScreen(),
    const ProfileScreen(),
  ];

  void onBottomNavigationTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping App"),
      ),

      // ---------------- DRAWER ----------------

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Shopping App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  selectedIndex = 0;
                });
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Products"),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  selectedIndex = 1;
                });
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),

      // ---------------- BODY ----------------

      body: pages[selectedIndex],

      // ---------------- BOTTOM NAVIGATION ----------------

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: onBottomNavigationTap,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// ---------------- HOME CONTENT ----------------

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
            size: 100,
            color: Colors.blue,
          ),

          const SizedBox(height: 20),

          const Text(
            "Welcome to Shopping App",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // Named navigation
              Navigator.pushNamed(context, '/products');
            },
            child: const Text("View Products"),
          ),
        ],
      ),
    );
  }
}

// ---------------- PRODUCT LIST ----------------

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Column(
        children: [
          // ---------------- TAB BAR ----------------

          const TabBar(
            tabs: [
              Tab(text: "Electronics"),
              Tab(text: "Clothing"),
              Tab(text: "Accessories"),
            ],
          ),

          // ---------------- TAB BAR VIEW ----------------

          Expanded(
            child: TabBarView(
              children: [
                ProductCategory(
                  category: "Electronics",
                ),

                ProductCategory(
                  category: "Clothing",
                ),

                ProductCategory(
                  category: "Accessories",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- PRODUCT CATEGORY ----------------

class ProductCategory extends StatelessWidget {
  final String category;

  const ProductCategory({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProducts = products
        .where((product) => product.category == category)
        .toList();

    return ListView.builder(
      itemCount: categoryProducts.length,

      itemBuilder: (context, index) {
        final product = categoryProducts[index];

        return GestureDetector(
          // ---------------- GESTURE ----------------

          onTap: () {
            // Passing product using route arguments
            Navigator.pushNamed(
              context,
              '/productDetails',
              arguments: product,
            );
          },

          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${product.name} added to favorites",
                ),
              ),
            );
          },

          child: Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              leading: Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),

              title: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                "₹${product.price}",
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- PRODUCT DETAILS ----------------

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Receive route argument
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Image.network(
              product.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            Text(
              product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Category: ${product.category}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Price: ₹${product.price}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Product added to cart"),
                    ),
                  );
                },

                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- PROFILE SCREEN ----------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          SizedBox(height: 20),

          Text(
            "Mohit",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "mohit@example.com",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}