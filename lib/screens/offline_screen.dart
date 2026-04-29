import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../widgets/state_views.dart';

class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline'), centerTitle: false),
      body: OfflineStateView(
        onRetry: () {
          ref.read(offlineModeProvider.notifier).state = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reconnected to cached places', style: GoogleFonts.poppins())),
          );
        },
      ),
    );
  }
}
