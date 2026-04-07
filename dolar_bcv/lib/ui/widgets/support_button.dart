import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  void _showSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Apóyame con un café ☕',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Tu apoyo me ayuda a seguir mejorando esta aplicación.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Botón Pago Móvil BDV
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                      const ClipboardData(text: '0102 04268947660 8033311'));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Datos copiados! Ábrelo en tu app del BDV o Mercantil'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.account_balance, color: Colors.blue),
                label: const Text('Copiar datos de Pago Móvil (BDV)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botón Pago Móvil Mercantil
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                      const ClipboardData(text: '0105 04268947660 8033311'));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Datos copiados! Ábrelo en tu app del BDV o Mercantil'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.account_balance, color: Colors.blueAccent),
                label: const Text('Copiar datos de Pago Móvil (Mercantil)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botón Binance Pay
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse('https://app.binance.com/uni-qr/89ymjEE7');
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se pudo abrir Binance Pay')),
                      );
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.currency_bitcoin, color: Colors.amber),
                label: const Text('Enviar por Binance Pay'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.amber.withOpacity(0.2), // Tonalidad Binance
                  foregroundColor: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.amberAccent 
                      : Colors.orange.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.coffee),
      tooltip: 'Apoyo económico',
      onPressed: () => _showSupportBottomSheet(context),
    );
  }
}
