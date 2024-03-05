import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String username;

  User(this.username);
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class Cart {
  final List<Product> products = [];
}

class AppState {
  User? _user;
  List<Product> _products = [
    Product("Product 1", 20.0),
    Product("Product 2", 15.0),
    Product("Product 3", 30.0),
  ];
  Cart _cart = Cart();

  User? get user => _user;

  List<Product> get products => _products;

  Cart get cart => _cart;

  void login(String username) {
    _user = User(username);
  }

  void logout() {
    _user = null;
  }

  void addToCart(Product product) {
    _cart.products.add(product);
  }
}

class MyApp extends StatelessWidget {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(appState: appState),
        '/home': (context) => ProductHomePage(appState: appState),
        '/cart': (context) => CartPage(appState: appState),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final AppState appState;

  LoginPage({required this.appState});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate username and password here
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  widget.appState.login(usernameController.text);
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Show an error message or handle the invalid login
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductHomePage extends StatelessWidget {
  final AppState appState;

  ProductHomePage({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Home'),
        actions: [
          IconButton(
            onPressed: () {
              appState.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: appState.products.length,
        itemBuilder: (context, index) {
          final product = appState.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                appState.addToCart(product);
              },
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final AppState appState;

  CartPage({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: appState.cart.products.isEmpty
          ? Center(
        child: Text('Your cart is empty.'),
      )
          : ListView.builder(
        itemCount: appState.cart.products.length,
        itemBuilder: (context, index) {
          final product = appState.cart.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toString()}'),
          );
        },
      ),
    );
  }
}