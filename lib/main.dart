import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CFCA6 App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'CFCA6 App',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Educational Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Carbon Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Personalized Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Sustainability Challenge',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Main Page'));
      case 1:
        return EducationalContentPage();
      case 2:
        return CarbonCalculatorPage();
      case 3:
        return Center(child: Text('Personalized Reports Page'));
      case 4:
        return Center(child: Text('Sustainability Challenge Page'));
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}

class EducationalContentPage extends StatefulWidget {
  @override
  _EducationalContentPageState createState() => _EducationalContentPageState();
}

class _EducationalContentPageState extends State<EducationalContentPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildFlowBar(String title, bool isSelected, bool isAnswered) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 20.0,
            color: (isSelected || isAnswered) ? Colors.black : Colors.grey,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  color:
                      (isSelected || isAnswered) ? Colors.white : Colors.grey,
                  fontWeight: isSelected || isAnswered
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: <Widget>[
              EducationalContentItem(
                imageAsset: 'assets/image1.jpg',
                content:
                    'Sample Text Content for Page 1.\nYou can add more content here.',
              ),
              EducationalContentItem(
                imageAsset: 'assets/image2.jpg',
                content:
                    'Sample Text Content for Page 2.\nYou can add more content here.',
              ),
              // Add more pages if needed
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 2; i++)
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPageIndex ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class EducationalContentItem extends StatelessWidget {
  final String imageAsset;
  final String content;

  const EducationalContentItem({
    required this.imageAsset,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight) /
              2,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight) /
                2,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CarbonCalculatorPage extends StatefulWidget {
  @override
  _CarbonCalculatorPageState createState() => _CarbonCalculatorPageState();
}

class _CarbonCalculatorPageState extends State<CarbonCalculatorPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<bool> _isHouseholdAnswered = [false, false];
  List<bool> _isEnergyAnswered = [false, false];
  List<bool> _isTransportationAnswered = [false, false];
  List<bool> _isWasteAnswered = [false, false];
  List<int> _householdSelectedIndices = [
    -1,
    -1
  ]; // Store the selected indices for household questions
  List<int> _energySelectedIndices = [
    -1,
    -1
  ]; // Store the selected indices for energy questions
  List<int> _transportationSelectedIndices = [
    -1,
    -1
  ]; // Store the selected indices for transportation questions
  List<int> _wasteSelectedIndices = [
    -1,
    -1
  ]; // Store the selected indices for waste questions
  double _carbonFootprint = 0.0; // Store the calculated carbon footprint

  // Questions and Answers
  final List<String> _householdQuestions = [
    'How many people live in your household?',
    'Do you use LED bulbs in your home?'
  ];

  final List<List<String>> _householdOptions = [
    ['1', '2', '3', '4+'],
    ['Yes', 'No']
  ];

  final List<String> _energyQuestions = [
    'How do you heat your home?',
    'Do you have solar panels on your property?'
  ];

  final List<List<String>> _energyOptions = [
    ['Gas', 'Electricity', 'Wood', 'Other'],
    ['Yes', 'No']
  ];

  final List<String> _transportationQuestions = [
    'What type of vehicle do you drive most often?',
    'How many miles do you drive in a week?'
  ];

  final List<List<String>> _transportationOptions = [
    ['Car', 'Bicycle', 'Public Transit', 'Walk', 'Other'],
    ['Less than 50', '50-100', 'More than 100']
  ];

  final List<String> _wasteQuestions = [
    'Do you recycle paper and cardboard?',
    'Do you compost organic waste?'
  ];

  final List<List<String>> _wasteOptions = [
    ['Yes', 'No'],
    ['Yes', 'No']
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildFlowBar(String title, bool isSelected, bool isAnswered) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 20.0,
            color: (isSelected || isAnswered) ? Colors.black : Colors.grey,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  color:
                      (isSelected || isAnswered) ? Colors.white : Colors.grey,
                  fontWeight: isSelected || isAnswered
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceQuestions(List<String> questions,
      List<List<String>> options, List<int> selectedIndices) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFlowBar('Household', _currentPageIndex == 1,
                  _getAnsweredStatus(_isHouseholdAnswered)),
              _buildFlowBar('Energy', _currentPageIndex == 2,
                  _getAnsweredStatus(_isEnergyAnswered)),
              _buildFlowBar('Transportation', _currentPageIndex == 3,
                  _getAnsweredStatus(_isTransportationAnswered)),
              _buildFlowBar('Waste', _currentPageIndex == 4,
                  _getAnsweredStatus(_isWasteAnswered)),
            ],
          ),
        ),
        for (int i = 0; i < questions.length; i++)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  questions[i],
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                for (int j = 0; j < options[i].length; j++)
                  RadioListTile<int>(
                    value: j,
                    groupValue: selectedIndices[i],
                    onChanged: (value) {
                      setState(() {
                        selectedIndices[i] = value!;
                      });
                    },
                    title: Text(options[i][j]),
                  ),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: () {
            bool allQuestionsAnswered =
                selectedIndices.every((index) => index != -1);
            if (allQuestionsAnswered) {
              // Calculate the carbon footprint based on user selections
              double householdCarbonFootprint =
                  calculateHouseholdCarbonFootprint(
                _householdSelectedIndices[0], // Number of people
                _householdSelectedIndices[1], // LED bulbs
              );
              double energyCarbonFootprint = calculateEnergyCarbonFootprint(
                _energySelectedIndices[0], // Heating method
                _energySelectedIndices[1], // Solar panels
              );
              double transportationCarbonFootprint =
                  calculateTransportationCarbonFootprint(
                _transportationSelectedIndices[0], // Vehicle type
                _transportationSelectedIndices[1], // Miles driven
              );
              double wasteCarbonFootprint = calculateWasteCarbonFootprint(
                _wasteSelectedIndices[0], // Recycling
                _wasteSelectedIndices[1], // Composting
              );
              // Calculate the total carbon footprint
              double totalCarbonFootprint = householdCarbonFootprint +
                  energyCarbonFootprint +
                  transportationCarbonFootprint +
                  wasteCarbonFootprint;
              setState(() {
                _carbonFootprint = totalCarbonFootprint;
              });
              // Navigate to the next page (Carbon Footprint Emission Reports)
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else {
              // Show a message or take appropriate action when not all questions are answered
            }
          },
          child: Text('Next'),
        ),
      ],
    );
  }

  bool _getAnsweredStatus(List<bool> isAnswered) {
    return isAnswered.isNotEmpty && isAnswered.every((answered) => answered);
  }

  // Define functions to calculate carbon footprint for each category
  double calculateHouseholdCarbonFootprint(int people, int ledBulbs) {
    // Calculate and return the carbon footprint for the household category
    // You can implement your own calculation logic here
    // Example calculation:
    double householdCarbonFootprint =
        (people * 2.5) + (ledBulbs == 0 ? 50.0 : 0.0);
    return householdCarbonFootprint;
  }

  double calculateEnergyCarbonFootprint(int heatingMethod, int solarPanels) {
    // Calculate and return the carbon footprint for the energy category
    // You can implement your own calculation logic here
    // Example calculation:
    double energyCarbonFootprint =
        (heatingMethod == 0 ? 200.0 : 100.0) - (solarPanels == 1 ? 50.0 : 0.0);
    return energyCarbonFootprint;
  }

  double calculateTransportationCarbonFootprint(
      int vehicleType, int milesDriven) {
    // Calculate and return the carbon footprint for the transportation category
    // You can implement your own calculation logic here
    // Example calculation:
    double transportationCarbonFootprint =
        (vehicleType == 0 ? 300.0 : 0.0) + (milesDriven * 1.5);
    return transportationCarbonFootprint;
  }

  double calculateWasteCarbonFootprint(int recycling, int composting) {
    // Calculate and return the carbon footprint for the waste category
    // You can implement your own calculation logic here
    // Example calculation:
    double wasteCarbonFootprint =
        (recycling == 0 ? 50.0 : 0.0) + (composting == 0 ? 30.0 : 0.0);
    return wasteCarbonFootprint;
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      children: <Widget>[
        // Page 1 (Introduction)
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Short Summary of Text',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset('assets/image3.jpg', fit: BoxFit.cover),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Page 2 (Household)
                _pageController.animateToPage(
                  1, // Page 2 index (Household)
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: Text('Calculate My Footprint'),
            ),
          ],
        ),

        // Page 2 (Household)
        _buildMultipleChoiceQuestions(
          _householdQuestions,
          _householdOptions,
          _householdSelectedIndices,
        ),

        // Page 3 (Energy)
        _buildMultipleChoiceQuestions(
          _energyQuestions,
          _energyOptions,
          _energySelectedIndices,
        ),

        // Page 4 (Transportation)
        _buildMultipleChoiceQuestions(
          _transportationQuestions,
          _transportationOptions,
          _transportationSelectedIndices,
        ),

        // Page 5 (Waste)
        _buildMultipleChoiceQuestions(
          _wasteQuestions,
          _wasteOptions,
          _wasteSelectedIndices,
        ),

        // Page 6 (Carbon Footprint Emission Reports)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _pageController.animateToPage(
                      4, // Page 5 index (Waste)
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFlowBar('Household', _currentPageIndex == 1,
                      _getAnsweredStatus(_isHouseholdAnswered)),
                  _buildFlowBar('Energy', _currentPageIndex == 2,
                      _getAnsweredStatus(_isEnergyAnswered)),
                  _buildFlowBar('Transportation', _currentPageIndex == 3,
                      _getAnsweredStatus(_isTransportationAnswered)),
                  _buildFlowBar('Waste', _currentPageIndex == 4,
                      _getAnsweredStatus(_isWasteAnswered)),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Carbon Footprint Emission Reports',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Total Carbon Footprint: $_carbonFootprint tons CO2e',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
