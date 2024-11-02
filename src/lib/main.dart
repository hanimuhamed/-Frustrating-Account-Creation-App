import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(PasswordGameApp());
}

class PasswordGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Game Sign-Up',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Adjust for text style
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[850],
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(179, 186, 186, 186)),
          hintStyle: TextStyle(color: Color.fromARGB(137, 148, 148, 148)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius:
                BorderRadius.all(Radius.circular(30.0)), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
            borderRadius:
                BorderRadius.all(Radius.circular(15.0)), // Rounded corners
          ),
        ),
      ),
      themeMode: ThemeMode.dark, // Use dark theme by default
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final List<Map<String, dynamic>> conditions = [
    {'message': 'The password is too short!', 'isMet': false},
    {'message': 'Must contain a lowercase letter', 'isMet': false},
    {'message': 'Must contain an uppercase letter', 'isMet': false},
    {'message': 'Must contain a number', 'isMet': false},
    {'message': 'Must contain a special character (e.g., !@#)', 'isMet': false},
    {'message': 'Must contain a month of the year', 'isMet': false},
    {'message': 'Cannot contain the letter E', 'isMet': false},
    {'message': 'The digits must add up to 25', 'isMet': false},
    {'message': 'Must contain a leap year', 'isMet': false},
    {'message': 'Must contain the length of your password', 'isMet': false},
    {
      'message': 'The length of your password must be a prime number',
      'isMet': false
    },
    {
      'message': 'Must contain the current year in Roman numerals',
      'isMet': false
    },
    {
      'message':
          'Must not include any vowels in the first half of the password',
      'isMet': false
    },
    {'message': 'Must contain the answer to Wordle #1232', 'isMet': false},
    {'message': 'The password is too long!', 'isMet': false},
  ];

  final GlobalKey<AnimatedListState> _metConditionsListKey =
      GlobalKey<AnimatedListState>();
  final List<Map<String, dynamic>> _metConditions = [];

  int _currentUnmetConditionIndex = 0; // Track the current unmet condition

  void _validatePassword(String password) {
    setState(() {
      // Reset the met conditions for this validation check
      List<Map<String, dynamic>> newMetConditions = [];
      _currentUnmetConditionIndex = -1; // Reset current unmet condition index

      // List of months
      List<String> months = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december'
      ];

      // Validate each condition
      conditions[0]['isMet'] = password.length >= 8;
      conditions[1]['isMet'] = password.split('').any(
          (char) => char.toLowerCase() == char && char.toUpperCase() != char);
      conditions[2]['isMet'] = password.split('').any(
          (char) => char.toUpperCase() == char && char.toLowerCase() != char);
      conditions[3]['isMet'] =
          password.split('').any((char) => '0123456789'.contains(char));
      conditions[4]['isMet'] = password.contains(RegExp(r'[!@#\$&*~]'));
      conditions[5]['isMet'] =
          months.any((month) => password.toLowerCase().contains(month));
      conditions[6]['isMet'] = !password.toLowerCase().contains('e');
      conditions[7]['isMet'] = _digitsAddTo25(password);
      conditions[8]['isMet'] = _containsLeapYear(password);
      conditions[9]['isMet'] = password.contains(password.length.toString());
      conditions[10]['isMet'] = _isPrime(password.length);
      conditions[11]['isMet'] = password.toUpperCase().contains('MMXXIV');
      conditions[12]['isMet'] = _noVowelsInFirstHalf(password);
      conditions[13]['isMet'] = password.toLowerCase().contains(wordle);
      conditions[14]['isMet'] = password.length < 25;

      // Collect met conditions
      for (var condition in conditions) {
        if (condition['isMet']) {
          newMetConditions.add(condition);
        }
      }

      // Update met conditions list with animations
      _updateMetConditions(newMetConditions);

      // Determine the current unmet condition index
      for (int i = 0; i < conditions.length; i++) {
        if (!conditions[i]['isMet']) {
          _currentUnmetConditionIndex = i;
          break;
        }
      }
    });
  }

  String wordle = 'snoop';
  bool _containsLeapYear(String password) {
    // Check for any four-digit sequence in the password
    for (int year = 1900; year <= 2024; year++) {
      if (password.contains(year.toString())) {
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
          return true; // Password contains a leap year
        }
      }
    }
    return false;
  }

  bool _digitsAddTo25(String password) {
    int sum = 0;

    // Loop through each character in the password
    for (var char in password.split('')) {
      // Check if the character is a digit
      if (int.tryParse(char) != null) {
        sum += int.parse(char); // Add the digit to the sum
      }
    }

    return sum == 25; // Return true if the sum equals 25
  }

  bool _isPrime(int number) {
    if (number <= 1) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  bool _noVowelsInFirstHalf(String password) {
    // Define a string of vowels
    const vowels = 'aeiouAEIOU';

    // Calculate the midpoint of the password
    int halfLength =
        (password.length / 2).ceil(); // Use ceil to account for odd lengths

    // Extract the first half of the password
    String firstHalf = password.substring(0, halfLength);

    // Check if any character in the first half is a vowel
    for (var char in firstHalf.split('')) {
      if (vowels.contains(char)) {
        return false; // Vowel found in the first half
      }
    }
    return true; // No vowels found
  }

  void _updateMetConditions(List<Map<String, dynamic>> newMetConditions) {
    // Remove any conditions that are not met anymore
    for (int i = 0; i < _metConditions.length; i++) {
      if (!newMetConditions.contains(_metConditions[i])) {
        _metConditionsListKey.currentState?.removeItem(
          i,
          (context, animation) =>
              _buildMetConditionItem(_metConditions[i], animation),
        );
        _metConditions.removeAt(i);
        i--; // Adjust index after removal
      }
    }

    // Add any new met conditions
    for (var condition in newMetConditions) {
      if (!_metConditions.contains(condition)) {
        _metConditions.add(condition);
        _metConditionsListKey.currentState
            ?.insertItem(_metConditions.length - 1);
      }
    }
  }

  void _loginClicked() {
    // If the current number is the target number
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oops...'),
          content: const Text(
              'Sorry! We forgot to store your account in the database. Please create a new account LOL.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Add this GestureDetector for clickable text
            GestureDetector(
              onTap: _loginClicked,
              //onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );*/
              //},
              child: Text(
                '   Already Registered? Click here to Login',
                style: TextStyle(
                  color: Colors.grey[600],
                  //decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              onChanged: _validatePassword,
              obscureText: !_isPasswordVisible,
            ),

            const SizedBox(height: 20),
            if (_currentUnmetConditionIndex >= 0)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<int>(_currentUnmetConditionIndex),
                  child: ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: Text(
                        conditions[_currentUnmetConditionIndex]['message']),
                    //style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedList(
                key: _metConditionsListKey,
                initialItemCount: _metConditions.length,
                itemBuilder: (context, index, animation) {
                  return _buildMetConditionItem(
                      _metConditions[index], animation);
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_usernameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                  } else if (!conditions
                      .every((condition) => condition['isMet'])) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please ensure your password meets all conditions')),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessPage()),
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetConditionItem(
      Map<String, dynamic> condition, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0), // Start off-screen to the left
        end: Offset.zero, // End at the original position
      ).animate(animation),
      child: ListTile(
        leading: const Icon(Icons.check_circle,
            color: Color.fromARGB(127, 179, 157, 219)),
        title: Text(
          condition['message'],
          style: const TextStyle(
            color: Color.fromARGB(127, 255, 255, 255),
            decoration:
                TextDecoration.lineThrough, // Replace with your desired color
            //fontSize: 16, // Optionally set font size
            //fontWeight: FontWeight.bold, // Optionally set font weight
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  int phoneNumber = 8500000000; // Initial phone number
  String message = ''; // Initial message
  bool askingComparison = false; // Flag for asking comparison
  int lowerBound = 7000000000; // Lower bound for binary search
  int upperBound = 10000000000; // Upper bound for binary search
  bool doubleCheck = false; // Flag to double-check if number is correct

  @override
  void initState() {
    super.initState();
    message = 'Is this your phone number?';
  }

  void _yesClicked() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmed!'),
          content: Text('Your phone number is confirmed as\n+91 $phoneNumber.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreaturePage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _noClicked() {
    setState(() {
      if (doubleCheck) {
        askingComparison = true;
        message = 'Is your phone number greater than this number?';
      } else {
        message = 'Are you really sure?\nOnce again is this your phone number?';
        doubleCheck = true;
      }
    });
  }

  void _comparisonResponse(bool isGreater) {
    if (isGreater) {
      lowerBound = phoneNumber + 1;
    } else {
      upperBound = phoneNumber - 1;
    }
    phoneNumber = (lowerBound + upperBound) ~/ 2;

    setState(() {
      askingComparison = false;
      doubleCheck = false;
      message = 'Is this your phone number?';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter your Phone number')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '+91 $phoneNumber',
                style: TextStyle(fontSize: 24, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 30),
            if (!askingComparison) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _yesClicked,
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: _noClicked,
                    child: const Text('No'),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _comparisonResponse(true),
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () => _comparisonResponse(false),
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CreaturePage extends StatefulWidget {
  @override
  _CreaturePageState createState() => _CreaturePageState();
}

class _CreaturePageState extends State<CreaturePage> {
  double _opacity = 0.0; // Initial opacity value

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 000), () {
      setState(() {
        _opacity = 1.0; // Set opacity to 1 to make it fully visible
      });
    });
  }

  int sorryClickCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CAPTCHA')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Please complete this CAPTCHA',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity, // Control opacity
              duration:
                  const Duration(seconds: 3), // Duration of the fade-in effect
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Adjust the radius as needed
                child: const Image(
                  image: AssetImage('images/toletole.jpeg'),
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover, // Ensures the image covers the box
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Do you like this creature?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show dialog with "Sorry" and "OK" options
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Account Deleted.'),
                          content: const Text(
                              'Your account will be deleted.\n(Or say sorry 10 times)'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                sorryClickCount++;

                                if (sorryClickCount >= 10) {
                                  Navigator.pop(
                                      context); // Close dialog after 10 clicks
                                  sorryClickCount = 0; // Reset count
                                } /*else {
                                  // Update dialog with remaining click count
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'I\'M SORRY (${10 - sorryClickCount} left)'),
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                }*/
                              },
                              child: const Text('I\'M SORRY'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop(); // Close the app
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('No'),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    // Show dialog with custom message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Thank You!'),
                          content: const Text(
                              'Thank you for letting us waste your time! :D'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
