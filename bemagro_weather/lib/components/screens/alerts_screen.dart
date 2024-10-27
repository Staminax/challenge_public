import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/shared/weather_data/alert/alert.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alert.event ?? 'Evento Desconhecido',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              alert.description ?? 'Nenhuma descrição disponível.',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              'Fonte: ${alert.senderName ?? 'N/A'}',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              'Início: ${formatDate(alert.start)}',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            Text(
              'Fim: ${formatDate(alert.end)}',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            buildTags(),
          ],
        ),
      ),
    );
  }

  Widget buildTags() {
    if (alert.tags == null || alert.tags!.isEmpty) {
      return const SizedBox();
    }
    return Wrap(
      spacing: 5.0,
      children: alert.tags!.map((tag) {
        return Chip(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          label: Text(tag),
        );
      }).toList(),
    );
  }

  String formatDate(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class AlertScreen extends StatelessWidget {
  final List<Alert> alerts;

  const AlertScreen({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HEARTBEAT ALERTS',
          style: TextStyle(
            fontFamily: 'Nothing',
          ),
        ),
        centerTitle: true,
      ),
      body: getAlertList(),
    );
  }

  Widget getAlertList() {
    if (alerts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: AutoSizeText(
            'Não existem alertas para a região selecionada no momento.',
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return AlertCard(alert: alerts[index]);
      },
    );
  }
}
