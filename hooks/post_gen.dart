import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Running post-gen hook...');
  final includeBackend = context.vars['include_backend'];

  // Remove backend folder if user selects not to include it
  if (!includeBackend) {
    final apiServerDir = Directory('./api-server');
    if (await apiServerDir.exists()) {
      await apiServerDir.delete(recursive: true);
      context.logger.info('Deleted ./api-server directory');
    }
  }

  // Run formatter on the whole directory of dart files
  await Process.run('dart', ['format', '.']);

  progress.complete();
}
