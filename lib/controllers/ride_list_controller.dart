import 'package:appcarona/models/ride.dart';
import 'package:appcarona/repositories/ride_repository.dart';

class RideListController {
  final RideRepository _rideRepository = RideRepository();

  Future<List<Ride>> loadRides() async {
    return await _rideRepository.loadRides();
  }

  Future<void> acceptRide(Ride ride) async {
  try {
    await _rideRepository.acceptRide(ride);
  } catch (e) {
    throw e; // Repassar a exceção para ser tratada na UI
  }
}

  Future<void> cancelRide(Ride ride) async {
  await _rideRepository.cancelRide(ride);
}

Future<void> cancelAcceptedRide(Ride ride) async {
  try {
    await _rideRepository.cancelAcceptedRide(ride);
  } catch (e) {
    throw e; // Repassar a exceção para ser tratada na UI
  }
}
}
