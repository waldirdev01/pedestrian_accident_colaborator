class ForwardProjection {
  int? id;
  final double pedestrianCGHeight;
  final double pedestrianMass;
  final double pedestrianFrictionCoefficientMin;
  final double pedestrianFrictionCoefficientMax;
  final double vehicleFrictionCoefficientMin;
  final double vehicleFrictionCoefficientMax;
  final double pedestrianProjectionSpeedMin;
  final double pedestrianProjectionSpeedMax;
  final double pedestrianProjectionDistance;
  final double slidingDistance;
  final double vehicleMass;
  final double vehicleSpeedNortwesternMin;
  final double vehicleSpeedNortwesternMax;
  final double toorSpeed;

  ForwardProjection({
    this.id,
    required this.pedestrianCGHeight,
    required this.pedestrianMass,
    required this.pedestrianFrictionCoefficientMin,
    required this.pedestrianFrictionCoefficientMax,
    required this.vehicleFrictionCoefficientMin,
    required this.vehicleFrictionCoefficientMax,
    required this.pedestrianProjectionSpeedMin,
    required this.pedestrianProjectionSpeedMax,
    required this.pedestrianProjectionDistance,
    required this.slidingDistance,
    required this.vehicleMass,
    required this.vehicleSpeedNortwesternMin,
    required this.vehicleSpeedNortwesternMax,
    required this.toorSpeed,
  });

  factory ForwardProjection.fromJson(Map<String, dynamic> json) {
    return ForwardProjection(
      id: json['id'],
      pedestrianCGHeight: json['pedestrianCGHeight'],
      pedestrianMass: json['pedestrianMass'],
      pedestrianFrictionCoefficientMin:
          json['pedestrianFrictionCoefficientMin'],
      pedestrianFrictionCoefficientMax:
          json['pedestrianFrictionCoefficientMax'],
      vehicleFrictionCoefficientMin: json['vehicleFrictionCoefficientMin'],
      vehicleFrictionCoefficientMax: json['vehicleFrictionCoefficientMax'],
      pedestrianProjectionSpeedMin: json['pedestrianProjectionSpeedMin'],
      pedestrianProjectionSpeedMax: json['pedestrianProjectionSpeedMax'],
      pedestrianProjectionDistance: json['pedestrianProjectionDistance'],
      slidingDistance: json['slidingDistance'],
      vehicleMass: json['vehicleMass'],
      vehicleSpeedNortwesternMin: json['vehicleSpeedNortwesternMin'],
      vehicleSpeedNortwesternMax: json['vehicleSpeedNortwesternMax'],
      toorSpeed: json['toorSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedestrianCGHeight': pedestrianCGHeight,
      'pedestrianMass': pedestrianMass,
      'pedestrianFrictionCoefficientMin': pedestrianFrictionCoefficientMin,
      'pedestrianFrictionCoefficientMax': pedestrianFrictionCoefficientMax,
      'vehicleFrictionCoefficientMin': vehicleFrictionCoefficientMin,
      'vehicleFrictionCoefficientMax': vehicleFrictionCoefficientMax,
      'pedestrianProjectionSpeedMin': pedestrianProjectionSpeedMin,
      'pedestrianProjectionSpeedMax': pedestrianProjectionSpeedMax,
      'pedestrianProjectionDistance': pedestrianProjectionDistance,
      'slidingDistance': slidingDistance,
      'vehicleMass': vehicleMass,
      'vehicleSpeedNortwesternMin': vehicleSpeedNortwesternMin,
      'vehicleSpeedNortwesternMax': vehicleSpeedNortwesternMax,
      'toorSpeed': toorSpeed,
    };
  }
}
