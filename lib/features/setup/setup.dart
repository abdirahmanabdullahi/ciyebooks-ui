import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PageOne extends StatelessWidget {
  const PageOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s set up your account with accurate details to get started. This will help us provide you with a seamless experience!",
                  style: Theme.of(context).textTheme.bodyLarge,
                  // textAlign: TextAlign.center,
                ),
              ],
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Before You Begin:",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                ),
                const Gap(10),
                Text(
                  "Here are a few things to keep in mind before setting up your account:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb,
                          color: Colors.orange, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Prepare a list of your current cash balances.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb,
                          color: Colors.orange, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Note any foreign currency balances you have.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb,
                          color: Colors.orange, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Have details of your outstanding expenses.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb,
                          color: Colors.orange, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Review your entries carefully before submitting to avoid mistakes.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Steps to Complete Your Setup:",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "1. Enter your starting cash balances.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "2. Add any foreign currencies you may have.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "3. Include any outstanding expenses.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "4. Review and confirm your entries.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "5. Submit your setup details.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/setupForm'); // Navigate to setup form
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.prettyDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Start Setup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  SetupState createState() => SetupState();
}

class SetupState extends State<Setup> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        backgroundColor: AppColors.quinary,
        title: const Text("Account Setup"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  PageOne(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add your starting capital',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.prettyDark,
                          ),
                        ),
                        const Gap(20),
                        Text(
                          "Enter the amount of capital you currently have to start your account setup.",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        Gap(10),
                        Text(
                          "This will help us calculate your profits correctly.",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        const Gap(30),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Capital in KES',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Gap(30),
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.prettyDark,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Starting Capital", //
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.prettyDark,
                          ),
                        ),
                        const Gap(20),
                        Text(
                          "Enter the amount of capital you currently have to start your account setup.",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        const Gap(30),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Gap(30),
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.prettyDark,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildConfirmationPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Confirmation Page
  Widget _buildConfirmationPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Review Your Setup",
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.prettyDark,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(20),
        Text(
          "Please review all your entries. You can go back to make corrections if needed.",
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(30),
        ElevatedButton(
          onPressed: () {
            // Submit setup logic here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.prettyDark,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Submit Setup",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}