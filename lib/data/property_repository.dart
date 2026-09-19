import 'package:flutter/foundation.dart';
import '../models/property.dart';
import '../models/notification_item.dart';
import 'mock_properties.dart';

class SearchFilterCriteria {
  final String query;
  final String? district;
  final PropertyType? type;
  final double minPrice;
  final double maxPrice;
  final int minBedrooms;
  final int minBathrooms;

  const SearchFilterCriteria({
    this.query = '',
    this.district,
    this.type,
    this.minPrice = 1000000,
    this.maxPrice = 10000000,
    this.minBedrooms = 0,
    this.minBathrooms = 0,
  });

  SearchFilterCriteria copyWith({
    String? query,
    String? district,
    PropertyType? type,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    bool clearDistrict = false,
    bool clearType = false,
  }) {
    return SearchFilterCriteria(
      query: query ?? this.query,
      district: clearDistrict ? null : (district ?? this.district),
      type: clearType ? null : (type ?? this.type),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      minBathrooms: minBathrooms ?? this.minBathrooms,
    );
  }

  bool get hasActiveFilters =>
      district != null ||
      type != null ||
      minPrice > 1000000 ||
      maxPrice < 10000000 ||
      minBedrooms > 0 ||
      minBathrooms > 0;
}

/// Reactive State Repository for properties, favorites, filters, and navigation
class PropertyRepository extends ChangeNotifier {
  static final PropertyRepository instance = PropertyRepository._internal();
  PropertyRepository._internal() {
    _properties = List.from(MockData.properties);
    _notifications = List.from(MockData.notifications);
  }

  late List<Property> _properties;
  late List<NotificationItem> _notifications;
  String _selectedCategoryId = 'all';
  SearchFilterCriteria _searchFilters = const SearchFilterCriteria();
  int _currentTabIndex = 0;

  // Getters
  List<Property> get allProperties => List.unmodifiable(_properties);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  String get selectedCategoryId => _selectedCategoryId;
  SearchFilterCriteria get searchFilters => _searchFilters;
  int get currentTabIndex => _currentTabIndex;

  List<Property> get featuredProperties =>
      _properties.where((p) => p.isFeatured).toList();

  List<Property> get savedProperties =>
      _properties.where((p) => p.isFavorite).toList();

  List<Property> get propertiesByCategory {
    if (_selectedCategoryId == 'all') {
      return _properties;
    }
    return _properties.where((p) {
      return p.type.name.toLowerCase() == _selectedCategoryId.toLowerCase();
    }).toList();
  }

  List<Property> get searchResults {
    return _properties.where((p) {
      // Query match
      if (_searchFilters.query.isNotEmpty) {
        final q = _searchFilters.query.toLowerCase();
        final matchTitle = p.title.toLowerCase().contains(q);
        final matchLoc = p.location.toLowerCase().contains(q);
        final matchDist = p.district.toLowerCase().contains(q);
        final matchType = p.type.label.toLowerCase().contains(q);
        if (!matchTitle && !matchLoc && !matchDist && !matchType) return false;
      }

      // District match
      if (_searchFilters.district != null && _searchFilters.district!.isNotEmpty) {
        if (!p.district.toLowerCase().contains(_searchFilters.district!.toLowerCase())) {
          return false;
        }
      }

      // Type match
      if (_searchFilters.type != null && p.type != _searchFilters.type) {
        return false;
      }

      // Price range match
      if (p.price < _searchFilters.minPrice || p.price > _searchFilters.maxPrice) {
        return false;
      }

      // Bedrooms match
      if (_searchFilters.minBedrooms > 0 && p.bedrooms < _searchFilters.minBedrooms) {
        return false;
      }

      // Bathrooms match
      if (_searchFilters.minBathrooms > 0 && p.bathrooms < _searchFilters.minBathrooms) {
        return false;
      }

      return true;
    }).toList();
  }

  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Navigation
  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // Category Selection
  void setCategory(String categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      notifyListeners();
    }
  }

  // Favorites
  void toggleFavorite(String propertyId) {
    final index = _properties.indexWhere((p) => p.id == propertyId);
    if (index != -1) {
      final current = _properties[index];
      _properties[index] = current.copyWith(isFavorite: !current.isFavorite);
      notifyListeners();
    }
  }

  // Search & Filter
  void updateSearchQuery(String query) {
    _searchFilters = _searchFilters.copyWith(query: query);
    notifyListeners();
  }

  void updateFilters(SearchFilterCriteria criteria) {
    _searchFilters = criteria;
    notifyListeners();
  }

  void resetFilters() {
    _searchFilters = const SearchFilterCriteria();
    notifyListeners();
  }

  // Notifications
  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      final n = _notifications[index];
      _notifications[index] = NotificationItem(
        id: n.id,
        title: n.title,
        description: n.description,
        time: n.time,
        group: n.group,
        icon: n.icon,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications
        .map((n) => NotificationItem(
              id: n.id,
              title: n.title,
              description: n.description,
              time: n.time,
              group: n.group,
              icon: n.icon,
              isRead: true,
            ))
        .toList();
    notifyListeners();
  }
}
