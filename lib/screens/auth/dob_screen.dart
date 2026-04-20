// 🔥 UPDATED DOB SCREEN (FIXED GAPS)

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/loader.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voxylive/screens/auth/edit_profile.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  bool isLoading = false;

  int selectedTab = 0;

  int? selectedDay;
  String? selectedMonth;
  int? selectedYear;

  final TextEditingController dobController = TextEditingController();

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final List<int> years = List.generate(35, (index) => 1990 + index);

  String _getDob() {
    if (dobController.text.isNotEmpty) {
      return dobController.text;
    }

    if (selectedDay != null && selectedMonth != null && selectedYear != null) {
      int monthIndex = months.indexOf(selectedMonth!) + 1;

      return "${selectedYear!}-${monthIndex.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}";
    }

    return "";
  }

  Future<void> _submitDob() async {
    final dob = _getDob();

    if (dob.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select DOB")));
      return;
    }

    try {
      setState(() => isLoading = true);

      Loader.show(context);

      await AuthService.saveDob(dob);

      Loader.hide(context);

      // Navigator.push(
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const FinishSetupScreen()),
        (route) => false,
      );
    } catch (e) {
      Loader.hide(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0E0F0B),
        elevation: 0,
        titleSpacing: 20,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Text(
            "Date of Birth",
            style: const TextStyle(
              fontFamily: "MuseoModerno",
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// INFO BOX
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFBF7C).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    color: Color(0xFFE98834),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Don’t worry your Date of birth will be private",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Add your date of birth.",
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: "Inter",
              ),
            ),

            const SizedBox(height: 20),

            /// INPUT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: dobController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "DD/MM/YYYY",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  selectedDay = null;
                  selectedMonth = null;
                  selectedYear = null;
                  setState(() {});
                },
              ),
            ),

            /// 🔥 FIXED GAP (INPUT → TABS)
            const SizedBox(height: 130),

            /// TABS
            Row(children: [_tab("Day", 0), _tab("Month", 1), _tab("Year", 2)]),

            const SizedBox(height: 20),

            /// CONTENT + BUTTON (FIXED STRUCTURE)
            Expanded(
              child: Column(
                children: [
                  /// GRID CONTENT
                  SizedBox(height: 250, child: _buildContent()),

                  /// 🔥 FIXED GAP (CONTENT → BUTTON)
                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isValid()
                            ? const Color(0xFFE98834)
                            : const Color(0xFF3A2713),

                        foregroundColor: _isValid() 
                            ? Colors.black
                            : Colors.white38,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (!_isValid() || isLoading) return;

                        if (dobController.text.isNotEmpty) {
                          _submitDob();
                        } else {
                          if (selectedTab < 2) {
                            setState(() => selectedTab++);
                          } else {
                            _submitDob();
                          }
                        }
                      },

                      // if (dobController.text.isNotEmpty) {
                      //   // direct dob enter case
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => const FinishSetupScreen(),
                      //     ),
                      //   );
                      // } else {
                      //   if (selectedTab < 2) {
                      //     setState(() => selectedTab++);
                      //   } else {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => const FinishSetupScreen(),
                      //       ),
                      //     );
                      //   }
                      // }
                      // },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              "Next",
                              style: TextStyle(
                                color: _isValid()
                                    ? Colors.black
                                    : Colors.white54,
                                fontFamily: "Inter",
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TAB
  Widget _tab(String text, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF361900) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? const Color.fromARGB(255, 246, 245, 245)
                : Colors.white70,
            fontFamily: "Inter",
          ),
        ),
      ),
    );
  }

  /// CONTENT (same as tera)
  Widget _buildContent() {
    if (selectedTab == 0) {
      return ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFFE98834)),
          trackColor: WidgetStateProperty.all(Colors.white10),
          thickness: WidgetStateProperty.all(3),
          radius: const Radius.circular(10),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 31,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              int day = index + 1;
              return _circleItem(
                text: day.toString(),
                selected: selectedDay == day,
                onTap: () {
                  setState(() {
                    selectedDay = day;
                    dobController.clear();
                  });
                },
              );
            },
          ),
        ),
      );
    }

    if (selectedTab == 1) {
      return ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFFE98834)),
          trackColor: WidgetStateProperty.all(Colors.white10),
          thickness: WidgetStateProperty.all(3),
          radius: const Radius.circular(10),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: months.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (_, index) {
              String month = months[index];
              return _pillItem(
                text: month,
                selected: selectedMonth == month,
                onTap: () {
                  setState(() {
                    selectedMonth = month;
                    dobController.clear();
                  });
                },
              );
            },
          ),
        ),
      );
    }

    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFE98834)),
        trackColor: WidgetStateProperty.all(Colors.white10),
        thickness: WidgetStateProperty.all(3),
        radius: const Radius.circular(10),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: years.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (_, index) {
            int year = years[index];
            return _pillItem(
              text: year.toString(),
              selected: selectedYear == year,
              onTap: () {
                setState(() {
                  selectedYear = year;
                  dobController.clear();
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _circleItem({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? const Color(0xFFE98834) : const Color(0xFF1A1B18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontFamily: "inter",
          ),
        ),
      ),
    );
  }

  Widget _pillItem({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE98834) : const Color(0xFF1A1B18),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontFamily: "Inter",
          ),
        ),
      ),
    );
  }

  bool _isValid() {
    if (dobController.text.isNotEmpty) return true;
    return selectedDay != null && selectedMonth != null && selectedYear != null;
  }
}
