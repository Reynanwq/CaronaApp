import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/controllers/ride_list_controller.dart';
import 'package:appcarona/widgets/ride_list_item.dart';

class RideListPage extends StatefulWidget {
  const RideListPage({super.key});

  @override
  _RideListPageState createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  List<Ride> rides = [];
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final RideListController _controller = RideListController();

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    final loadedRides = await _controller.loadRides();
    setState(() {
      rides.clear();
      rides.addAll(loadedRides);
    });
  }

  Future<void> acceptRide(Ride ride) async {
    try {
      await _controller.acceptRide(ride);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você aceitou a carona para ${ride.destination}')),
      );
      loadRides(); // Recarregar a lista de caronas para refletir as mudanças
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())), // Exibir mensagem de erro
      );
    }
  }

  Future<void> cancelRide(Ride ride) async {
  await _controller.cancelRide(ride);
  setState(() {
    loadRides();
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Carona para ${ride.destination} cancelada com sucesso!')),
  );
}

Future<void> cancelAcceptedRide(Ride ride) async {
  try {
    await _controller.cancelAcceptedRide(ride);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você cancelou a aceitação da carona para ${ride.destination}')),
    );
    loadRides(); // Recarregar a lista de caronas para refletir as mudanças
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())), // Exibir mensagem de erro
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Caronas Disponíveis')),
    body: ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        final isCurrentUserRide = ride.userId == currentUser?.uid;
        return RideListItem(
          ride: ride,
          onAccept: () => acceptRide(ride),
          onCancel: () => cancelRide(ride),
          onCancelAccepted: () => cancelAcceptedRide(ride), // Nova função
          isCurrentUserRide: isCurrentUserRide,
        );
      },
    ),
  );
}
}
