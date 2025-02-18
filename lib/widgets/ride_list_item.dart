import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/models/chat.dart';
import 'package:appcarona/screens/chat_screen.dart';

class RideListItem extends StatelessWidget {
  final Ride ride;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final VoidCallback? onCancelAccepted;
  final bool isCurrentUserRide;

  const RideListItem({
    super.key,
    required this.ride,
    required this.onAccept,
    required this.onCancel,
    this.onCancelAccepted,
    required this.isCurrentUserRide,
  });

  @override
  Widget build(BuildContext context) {
    final availableSeats = int.tryParse(ride.seats ?? '0') ?? 0;
    final isRideFull = availableSeats <= 0;
    final hasUserAccepted = ride.acceptedBy == FirebaseAuth.instance.currentUser?.uid;

    return ListTile(
      title: Text('Destino: ${ride.destination}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local de Saída: ${ride.departureLocation}'),
          Text('Horário de Saída: ${ride.departureTime}'),
          Text('Vagas: ${ride.seats}'),
          Text('Paradas: ${ride.stops}'),
          Text('Oferecido por: ${ride.userName}'),
          if (isRideFull)
            const Text(
              'Não há mais vagas disponíveis.',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCurrentUserRide)
            ElevatedButton(
              onPressed: onCancel,
              child: const Text('Cancelar Carona'),
            )
          else if (hasUserAccepted)
            ElevatedButton(
              onPressed: onCancelAccepted,
              child: const Text('Cancelar Carona Aceita'),
            )
          else
            ElevatedButton(
              onPressed: isRideFull ? null : onAccept,
              child: const Text('Aceitar Carona'),
            ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(rideId: ride.rideId!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}