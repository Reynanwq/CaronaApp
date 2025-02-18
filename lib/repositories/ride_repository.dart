import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/models/chat.dart';
import 'package:appcarona/models/message.dart';

class RideRepository {
  Future<List<Ride>> loadRides() async {
    final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    final DataSnapshot ridesSnapshot = await ridesRef.get();

    if (ridesSnapshot.exists) {
      final Map<dynamic, dynamic> ridesMap = ridesSnapshot.value as Map<dynamic, dynamic>;
      final List<Ride> loadedRides = [];

      for (var userId in ridesMap.keys) {
        final userRides = ridesMap[userId];
        if (userRides != null) {
          final Map<dynamic, dynamic> userRidesMap = userRides as Map<dynamic, dynamic>;

          final DataSnapshot userSnapshot = await usersRef.child(userId).get();
          final String userName = userSnapshot.child('name').value as String? ?? 'Usuário Desconhecido';

          for (var rideId in userRidesMap.keys) {
            final rideData = userRidesMap[rideId];
            final ride = Ride.fromJson(Map<String, dynamic>.from(rideData as Map));
            ride.userId = userId;
            ride.rideId = rideId;
            ride.userName = userName;
            loadedRides.add(ride);
          }
        }
      }

      return loadedRides;
    }

    return [];
  }

  Future<void> offerRide(Ride ride) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final DatabaseReference ridesRef =
        FirebaseDatabase.instance.ref().child('rides').child(user.uid);

    final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats');

    // Criar a carona
    final rideKey = ridesRef.push().key;
    await ridesRef.child(rideKey!).set({
      ...ride.toJson(),
      'chatId': rideKey, 
    });

    
    final Chat chat = Chat(
      rideId: rideKey,
      messages: [], 
    );

    await chatRef.child(rideKey).set(chat.toJson());
  }
}

  Future<void> acceptRide(Ride ride) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final DatabaseReference rideRef = FirebaseDatabase.instance
        .ref()
        .child('rides')
        .child(ride.userId!)
        .child(ride.rideId!);

    final DataSnapshot rideSnapshot = await rideRef.get();

    if (rideSnapshot.exists) {
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(rideSnapshot.value as Map);
      int availableSeats = int.tryParse(rideData['seats'] ?? '0') ?? 0;

      if (availableSeats > 0) {
        // Reduzir o número de vagas disponíveis
        availableSeats -= 1;

        // Atualizar o número de vagas no banco de dados
        await rideRef.update({
          'seats': availableSeats.toString(),
          'acceptedBy': user.uid, // Armazenar o ID do usuário que aceitou a carona
        });
      } else {
        throw Exception('Não há mais vagas disponíveis para esta carona.');
      }
    }
  }
}

  Future<void> cancelRide(Ride ride) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && ride.userId == user.uid) {
    final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
    final DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('history');

    // Adicionar a carona ao histórico do usuário que criou a carona
    await historyRef.child(ride.userId!).child(ride.rideId!).set({
      ...ride.toJson(),
      'status': 'canceled',
    });

    // Adicionar a carona ao histórico do usuário que aceitou a carona, se houver
    if (ride.acceptedBy != null) {
      await historyRef.child(ride.acceptedBy!).child(ride.rideId!).set({
        ...ride.toJson(),
        'status': 'canceled',
      });
    }

    // Remover a carona da lista de caronas disponíveis
    await ridesRef.child(ride.userId!).child(ride.rideId!).remove();
  }
}

  Future<void> cancelAcceptedRide(Ride ride) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final DatabaseReference rideRef = FirebaseDatabase.instance
        .ref()
        .child('rides')
        .child(ride.userId!)
        .child(ride.rideId!);

    final DataSnapshot rideSnapshot = await rideRef.get();

    if (rideSnapshot.exists) {
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(rideSnapshot.value as Map);
      int availableSeats = int.tryParse(rideData['seats'] ?? '0') ?? 0;

      // Aumentar o número de vagas em 1
      availableSeats += 1;

      // Atualizar o número de vagas no banco de dados e remover o ID do usuário que aceitou a carona
      await rideRef.update({
        'seats': availableSeats.toString(),
        'acceptedBy': null, // Remover o ID do usuário que aceitou a carona
      });

      // Adicionar a carona ao histórico do usuário que aceitou a carona
      final DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('history');
      await historyRef.child(user.uid).child(ride.rideId!).set({
        ...ride.toJson(),
        'status': 'canceled',
      });
    }
  }
}
}
