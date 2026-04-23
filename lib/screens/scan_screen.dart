// ============================================================
// FILE: screens/scan_screen.dart
// PURPOSE: Fake leaf scan screen with predefined disease detection
// CONCEPT: StatefulWidget, if-else logic, Navigator, Lists, OOP
// ============================================================

import 'package:flutter/material.dart';
import 'dart:async'; // for Future.delayed (simulate loading)
import '../models/disease.dart';
import 'result_screen.dart';

/// ScanScreen — Lets user "scan" a leaf by tapping an image card.
/// Uses StatefulWidget because we need to manage loading state.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // ---- State Variables ----
  bool isAnalyzing = false;      // Controls loading spinner visibility
  int? selectedCardIndex;        // Tracks which card was tapped (-1 = none)

  // ---- Leaf Sample Data (List of Maps) ----
  // Each entry maps to a Disease in diseaseList by index
  final List<Map<String, dynamic>> leafSamples = [
    {
      'title': 'Sample Leaf 1',
      'subtitle': 'Wheat Leaf',
      'emoji': '🌾',
      'color': const Color(0xFFD4521A),
      'bgColor': const Color(0xFFFBE9E7),
      'diseaseIndex': 0, // → Wheat Rust
    },
    {
      'title': 'Sample Leaf 2',
      'subtitle': 'Healthy Leaf',
      'emoji': '🌱',
      'color': const Color(0xFF2E7D32),
      'bgColor': const Color(0xFFE8F5E9),
      'diseaseIndex': 4, // → Healthy Leaf
    },
    {
      'title': 'Sample Leaf 3',
      'subtitle': 'Brown Leaf',
      'emoji': '🍂',
      'color': const Color(0xFF8B4513),
      'bgColor': const Color(0xFFFFF3E0),
      'diseaseIndex': 1, // → Leaf Blight
    },
    {
      'title': 'Sample Leaf 4',
      'subtitle': 'Yellow Leaf',
      'emoji': '🍋',
      'color': const Color(0xFFF57F17),
      'bgColor': const Color(0xFFFFFDE7),
      'diseaseIndex': 5, // → Yellow Mosaic Virus
    },
  ];

  // ----------------------------------------------------------------
  // METHOD: Handle leaf card tap — simulate analysis with delay
  // CONCEPT: if-else conditional logic, setState, async/await
  // ----------------------------------------------------------------
  Future<void> _onLeafTapped(int cardIndex) async {
    // Prevent double-tap during analysis
    if (isAnalyzing) return;

    // Update state: show loading spinner for selected card
    setState(() {
      isAnalyzing = true;
      selectedCardIndex = cardIndex;
    });

    // Simulate AI analysis delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // ---- PREDEFINED LOGIC (if-else) ----
    // Based on which card was tapped, select the corresponding disease
    Disease detectedDisease;

    if (cardIndex == 0) {
      detectedDisease = diseaseList[0]; // Wheat Rust
    } else if (cardIndex == 1) {
      detectedDisease = diseaseList[4]; // Healthy Leaf
    } else if (cardIndex == 2) {
      detectedDisease = diseaseList[1]; // Leaf Blight
    } else {
      detectedDisease = diseaseList[5]; // Yellow Mosaic Virus
    }

    // Reset loading state
    setState(() {
      isAnalyzing = false;
      selectedCardIndex = null;
    });

    // Navigate to Result Screen, passing the detected disease object
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(disease: detectedDisease),
        ),
      );
    }
  }

  // ----------------------------------------------------------------
  // BUILD METHOD
  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Leaf 📸'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Instruction Banner ----
            _buildInstructionBanner(),

            const SizedBox(height: 24),

            // ---- Section Title ----
            const Text(
              'Select a Leaf Sample:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 14),

            // ---- Leaf Cards Grid ----
            // Using GridView with 2 columns
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leafSamples.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return _buildLeafCard(index);
              },
            ),

            const SizedBox(height: 24),

            // ---- How it Works Section ----
            _buildHowItWorksSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: Instruction banner at the top
  // ----------------------------------------------------------------
  Widget _buildInstructionBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tap a Leaf to Analyze',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our system will identify the disease and suggest solutions.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: Individual leaf card
  // ----------------------------------------------------------------
  Widget _buildLeafCard(int index) {
    // Get the data for this card from the list
    final Map<String, dynamic> sample = leafSamples[index];

    // Check if THIS card is currently being analyzed
    bool isThisCardLoading = isAnalyzing && selectedCardIndex == index;

    return GestureDetector(
      onTap: () => _onLeafTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: sample['bgColor'] as Color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isThisCardLoading
                ? (sample['color'] as Color)
                : (sample['color'] as Color).withOpacity(0.3),
            width: isThisCardLoading ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (sample['color'] as Color).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isThisCardLoading
            // ---- Loading state UI ----
            ? _buildLoadingCard(sample)
            // ---- Normal card UI ----
            : _buildNormalCard(sample),
      ),
    );
  }

  // ---- Normal leaf card content ----
  Widget _buildNormalCard(Map<String, dynamic> sample) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Large emoji icon
        Text(
          sample['emoji'] as String,
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 12),
        Text(
          sample['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: sample['color'] as Color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          sample['subtitle'] as String,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        // Tap to analyze label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: (sample['color'] as Color).withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 13,
                color: sample['color'] as Color,
              ),
              const SizedBox(width: 4),
              Text(
                'Tap to Scan',
                style: TextStyle(
                  fontSize: 11,
                  color: sample['color'] as Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Loading state card content ----
  Widget _buildLoadingCard(Map<String, dynamic> sample) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular progress indicator
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              sample['color'] as Color,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Analyzing...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: sample['color'] as Color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please wait',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: How it works section
  // ----------------------------------------------------------------
  Widget _buildHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Text(
                'How Detection Works',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStep('1', 'Select a leaf sample from above'),
          _buildStep('2', 'System analyzes the leaf pattern'),
          _buildStep('3', 'Disease is identified using predefined logic'),
          _buildStep('4', 'Solution and tips are displayed'),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}