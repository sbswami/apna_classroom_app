import 'package:apna_classroom_app/app.dart';

track(String event, Map<String, dynamic> parameters) {
  // Filter Null values
  parameters = parameters.map((key, value) {
    var _value = value;

    if (value is List || value is Set || value is Iterable) {
      _value = value?.join(',');
    }

    if (_value == '' || _value == null) {
      _value = 'N/A';
    }

    return MapEntry(key, _value);
  });

  ApnaApp.analytics.logEvent(name: event, parameters: parameters);
}

trackScreen(String screen) {
  ApnaApp.analytics.setCurrentScreen(
    screenName: screen,
    screenClassOverride: screen,
  );
}

// Future<void> sendAnalyticsEvent() async {
//   await analytics.logEvent(
//     name: 'test_event',
//     parameters: <String, dynamic>{
//       'string': 'string',
//       'int': 42,
//       'long': 12345678910,
//       'double': 42.0,
//       'bool': true,
//     },
//   );
//   print('logEvent succeeded');
// }
//
// Future<void> testSetUserId() async {
//   await analytics.setUserId('some-user');
//   print('setUserId succeeded');
// }
//
// Future<void> testSetCurrentScreen() async {
//   await analytics.setCurrentScreen(
//     screenName: 'Analytics Demo',
//     screenClassOverride: 'AnalyticsDemo',
//   );
//   print('setCurrentScreen succeeded');
// }
//
// Future<void> testSetAnalyticsCollectionEnabled() async {
//   await analytics.setAnalyticsCollectionEnabled(false);
//   await analytics.setAnalyticsCollectionEnabled(true);
//   print('setAnalyticsCollectionEnabled succeeded');
// }
//
// Future<void> testSetSessionTimeoutDuration() async {
//   await analytics.android?.setSessionTimeoutDuration(2000000);
//   print('setSessionTimeoutDuration succeeded');
// }
//
// Future<void> testSetUserProperty() async {
//   await analytics.setUserProperty(name: 'regular', value: 'indeed');
//   print('setUserProperty succeeded');
// }
//
// Future<void> testAllEventTypes() async {
//   await analytics.logAddPaymentInfo();
//   await analytics.logAddToCart(
//     currency: 'USD',
//     value: 123.0,
//     itemId: 'test item id',
//     itemName: 'test item name',
//     itemCategory: 'test item category',
//     quantity: 5,
//     price: 24.0,
//     origin: 'test origin',
//     itemLocationId: 'test location id',
//     destination: 'test destination',
//     startDate: '2015-09-14',
//     endDate: '2015-09-17',
//   );
//   await analytics.logAddToWishlist(
//     itemId: 'test item id',
//     itemName: 'test item name',
//     itemCategory: 'test item category',
//     quantity: 5,
//     price: 24.0,
//     value: 123.0,
//     currency: 'USD',
//     itemLocationId: 'test location id',
//   );
//   await analytics.logAppOpen();
//   await analytics.logBeginCheckout(
//     value: 123.0,
//     currency: 'USD',
//     transactionId: 'test tx id',
//     numberOfNights: 2,
//     numberOfRooms: 3,
//     numberOfPassengers: 4,
//     origin: 'test origin',
//     destination: 'test destination',
//     startDate: '2015-09-14',
//     endDate: '2015-09-17',
//     travelClass: 'test travel class',
//   );
//   await analytics.logCampaignDetails(
//     source: 'test source',
//     medium: 'test medium',
//     campaign: 'test campaign',
//     term: 'test term',
//     content: 'test content',
//     aclid: 'test aclid',
//     cp1: 'test cp1',
//   );
//   await analytics.logEarnVirtualCurrency(
//     virtualCurrencyName: 'bitcoin',
//     value: 345.66,
//   );
//   await analytics.logEcommercePurchase(
//     currency: 'USD',
//     value: 432.45,
//     transactionId: 'test tx id',
//     tax: 3.45,
//     shipping: 5.67,
//     coupon: 'test coupon',
//     location: 'test location',
//     numberOfNights: 3,
//     numberOfRooms: 4,
//     numberOfPassengers: 5,
//     origin: 'test origin',
//     destination: 'test destination',
//     startDate: '2015-09-13',
//     endDate: '2015-09-14',
//     travelClass: 'test travel class',
//   );
//   await analytics.logGenerateLead(
//     currency: 'USD',
//     value: 123.45,
//   );
//   await analytics.logJoinGroup(
//     groupId: 'test group id',
//   );
//   await analytics.logLevelUp(
//     level: 5,
//     character: 'witch doctor',
//   );
//   await analytics.logLogin();
//   await analytics.logPostScore(
//     score: 1000000,
//     level: 70,
//     character: 'tiefling cleric',
//   );
//   await analytics.logPresentOffer(
//     itemId: 'test item id',
//     itemName: 'test item name',
//     itemCategory: 'test item category',
//     quantity: 6,
//     price: 3.45,
//     value: 67.8,
//     currency: 'USD',
//     itemLocationId: 'test item location id',
//   );
//   await analytics.logPurchaseRefund(
//     currency: 'USD',
//     value: 45.67,
//     transactionId: 'test tx id',
//   );
//   await analytics.logSearch(
//     searchTerm: 'hotel',
//     numberOfNights: 2,
//     numberOfRooms: 1,
//     numberOfPassengers: 3,
//     origin: 'test origin',
//     destination: 'test destination',
//     startDate: '2015-09-14',
//     endDate: '2015-09-16',
//     travelClass: 'test travel class',
//   );
//   await analytics.logSelectContent(
//     contentType: 'test content type',
//     itemId: 'test item id',
//   );
//   await analytics.logShare(
//       contentType: 'test content type',
//       itemId: 'test item id',
//       method: 'facebook');
//   await analytics.logSignUp(
//     signUpMethod: 'test sign up method',
//   );
//   await analytics.logSpendVirtualCurrency(
//     itemName: 'test item name',
//     virtualCurrencyName: 'bitcoin',
//     value: 34,
//   );
//   await analytics.logTutorialBegin();
//   await analytics.logTutorialComplete();
//   await analytics.logUnlockAchievement(id: 'all Firebase API covered');
//   await analytics.logViewItem(
//     itemId: 'test item id',
//     itemName: 'test item name',
//     itemCategory: 'test item category',
//     itemLocationId: 'test item location id',
//     price: 3.45,
//     quantity: 6,
//     currency: 'USD',
//     value: 67.8,
//     flightNumber: 'test flight number',
//     numberOfPassengers: 3,
//     numberOfRooms: 1,
//     numberOfNights: 2,
//     origin: 'test origin',
//     destination: 'test destination',
//     startDate: '2015-09-14',
//     endDate: '2015-09-15',
//     searchTerm: 'test search term',
//     travelClass: 'test travel class',
//   );
//   await analytics.logViewItemList(
//     itemCategory: 'test item category',
//   );
//   await analytics.logViewSearchResults(
//     searchTerm: 'test search term',
//   );
//   print('All standard events logged successfully');
// }
