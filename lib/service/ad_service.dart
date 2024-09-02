import 'package:paradigm_mex/models/property.dart';

import '../models/ad.dart';
import 'database_service.dart';

class AdService {
  late Ad ad;
  late final DatabaseService databaseService;

  AdService() {
    this.databaseService = DatabaseService();
  }


  Future<Ad> getAd() async {
    return await databaseService.getAd();
  }

  Future<Ad> getAdById(String id) async {
    return await databaseService.getAdById(adId: id);
  }

  Future<bool> updateAd(Ad ad) async {
    return await databaseService.updateAd(ad: ad);
  }

  Future<bool> deleteAd(Ad ad) async {
    return await databaseService.deleteAd(ad: ad);
  }

  Future<String> addAd(Ad ad) async {
    return await databaseService.addAd(ad: ad);
  }


  Future<AdList> getAdsByStatus(bool active, AdType type) {
    return databaseService.getAdsByStatus(active, type);
  }

  Future<AdList> getAds() {
    return databaseService.getAds();
  }
}
