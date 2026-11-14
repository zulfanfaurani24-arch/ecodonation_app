import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/donation_record.dart';
import '../models/drop_off_point.dart';

class AppState extends ChangeNotifier {
  // Profil Pengguna
  String _userName = 'Anna Kharisma';
  String _userEmail = 'anna.k@email.com';
  int _totalItemsDonated = 14;
  int _impactScore = 240;
  bool _isLoggedIn = true;

  String get userName => _userName;
  String get userEmail => _userEmail;
  int get totalItemsDonated => _totalItemsDonated;
  int get impactScore => _impactScore;
  bool get isLoggedIn => _isLoggedIn;

  // Daftar Kampanye
  final List<Campaign> _campaigns = [
    Campaign(
      id: '1',
      title: 'Pengumpulan Botol Plastik - Sekolah Lokal',
      organizer: 'Green Earth Initiative',
      location: 'SD Negeri 01, Jl. Merdeka No. 5',
      description:
          'Bantu kami mengumpulkan botol plastik untuk didaur ulang dan menjaga kebersihan lingkungan sekolah. Kami menargetkan 500 kg botol plastik. Setiap botol sangat berarti untuk masa depan yang lebih hijau!',
      imageUrl:
          'https://images.unsplash.com/photo-1530587191325-3db32d826c18?auto=format&fit=crop&w=600&q=80',
      imageEmoji: '🍾',
      imageColor: const Color(0xFF81C784),
      progress: 0.60,
      currentAmount: 300,
      goalAmount: 500,
      unit: 'kg',
      goal: '500 kg',
      category: 'Plastik',
    ),
    Campaign(
      id: '2',
      title: 'Donasi Buku - Pusat Komunitas',
      organizer: 'Green Earth Initiative',
      location: 'Perpustakaan Pusat, Lantai 1',
      description:
          'Bergabunglah bersama kami dalam mengumpulkan buku edukatif untuk anak-anak prasejahtera. Kami bertujuan menyediakan 1000 buku ke pusat komunitas setempat. Kontribusi Anda membawa perubahan besar!',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=600&q=80',
      imageEmoji: '📚',
      imageColor: const Color(0xFFFFB74D),
      progress: 0.85,
      currentAmount: 850,
      goalAmount: 1000,
      unit: 'buku',
      goal: '1000 buku',
      category: 'Buku',
    ),
    Campaign(
      id: '3',
      title: 'Daur Ulang Pakaian - Seluruh Kota',
      organizer: 'EcoCity Movement',
      location: 'Balai Kota, Lantai Dasar',
      description:
          'Donasikan pakaian lama Anda yang masih layak pakai untuk mengurangi limbah tekstil. Pakaian yang terkumpul akan disalurkan ke tempat penampungan dan pusat daur ulang di seluruh kota.',
      imageUrl:
          'https://images.unsplash.com/photo-1540221652346-e5dd6b50f3e7?auto=format&fit=crop&w=600&q=80',
      imageEmoji: '👕',
      imageColor: const Color(0xFF90CAF9),
      progress: 0.40,
      currentAmount: 80,
      goalAmount: 200,
      unit: 'kantong',
      goal: '200 kantong',
      category: 'Pakaian',
    ),
    Campaign(
      id: '4',
      title: 'Daur Ulang Elektronik & E-Waste',
      organizer: 'TechGreen Foundation',
      location: 'Mall Greenpark, Lantai 2',
      description:
          'Bawa barang elektronik bekas dan limbah gawai Anda untuk daur ulang yang aman dan tersertifikasi. Mencegah logam berat berbahaya mencemari tempat pembuangan akhir.',
      imageUrl:
          'https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&w=600&q=80',
      imageEmoji: '💻',
      imageColor: const Color(0xFF80DEEA),
      progress: 0.30,
      currentAmount: 30,
      goalAmount: 100,
      unit: 'unit',
      goal: '100 unit',
      category: 'Elektronik',
    ),
  ];

  List<Campaign> get campaigns => List.unmodifiable(_campaigns);

  // Riwayat Donasi
  final List<DonationRecord> _history = [
    DonationRecord(
      id: 'h-1',
      campaignId: '1',
      title: 'Botol Plastik - Sekolah Lokal',
      dateText: 'Selesai, 20 Mei',
      timestamp: DateTime(2026, 5, 20),
      quantity: 5,
      unit: 'kg',
      impactPoints: 80,
      emoji: '🍾',
      imageUrl:
          'https://images.unsplash.com/photo-1530587191325-3db32d826c18?auto=format&fit=crop&w=600&q=80',
      color: const Color(0xFF81C784),
      status: 'Selesai',
    ),
    DonationRecord(
      id: 'h-2',
      campaignId: '2',
      title: 'Buku Anak - Pusat Komunitas',
      dateText: 'Selesai, 5 Mei',
      timestamp: DateTime(2026, 5, 5),
      quantity: 6,
      unit: 'buku',
      impactPoints: 100,
      emoji: '📚',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=600&q=80',
      color: const Color(0xFFFFB74D),
      status: 'Selesai',
    ),
    DonationRecord(
      id: 'h-3',
      campaignId: '3',
      title: 'Pakaian Hangat - Rumah Singgah',
      dateText: 'Selesai, 28 Apr',
      timestamp: DateTime(2026, 4, 28),
      quantity: 3,
      unit: 'kantong',
      impactPoints: 60,
      emoji: '👕',
      imageUrl:
          'https://images.unsplash.com/photo-1540221652346-e5dd6b50f3e7?auto=format&fit=crop&w=600&q=80',
      color: const Color(0xFF90CAF9),
      status: 'Selesai',
    ),
  ];

  List<DonationRecord> get history => List.unmodifiable(_history);

  // Titik Kumpul (Drop-off points) untuk tab Peta
  final List<DropOffPoint> _dropOffPoints = const [
    DropOffPoint(
      id: 'dp-1',
      name: 'Titik Kumpul Perpustakaan Pusat',
      address: 'Jl. Pemuda No. 12, Lobi Lantai Dasar',
      distance: '0.8 km',
      openingHours: '08.00 - 18.00 (Sen - Sab)',
      acceptedCategories: ['Buku', 'Plastik'],
      latitude: -6.2088,
      longitude: 106.8456,
      contact: '+62 21 555 0101',
    ),
    DropOffPoint(
      id: 'dp-2',
      name: 'Pusat Daur Ulang Balai Kota',
      address: 'Jl. Merdeka Barat No. 3',
      distance: '1.5 km',
      openingHours: '08.00 - 16.00 (Sen - Jum)',
      acceptedCategories: ['Plastik', 'Pakaian', 'Elektronik'],
      latitude: -6.1751,
      longitude: 106.8272,
      contact: '+62 21 555 0102',
    ),
    DropOffPoint(
      id: 'dp-3',
      name: 'Kotak Donasi SDN 01 Merdeka',
      address: 'Jl. Merdeka No. 5, Pos Gerbang Sekolah',
      distance: '2.1 km',
      openingHours: '07.00 - 15.00 (Sen - Jum)',
      acceptedCategories: ['Plastik', 'Buku'],
      latitude: -6.1912,
      longitude: 106.8335,
      contact: '+62 21 555 0103',
    ),
    DropOffPoint(
      id: 'dp-4',
      name: 'Eco Center Mall Greenpark',
      address: 'Mall Greenpark Lantai P1, Loading Bay A',
      distance: '3.4 km',
      openingHours: '10.00 - 21.00 (Setiap Hari)',
      acceptedCategories: ['Elektronik', 'Pakaian', 'Plastik'],
      latitude: -6.2255,
      longitude: 106.8002,
      contact: '+62 21 555 0104',
    ),
  ];

  List<DropOffPoint> get dropOffPoints => _dropOffPoints;

  // Aksi Donasi
  bool donate({
    required String campaignId,
    required int quantity,
    required String method,
    String? note,
  }) {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index == -1 || quantity <= 0) return false;

    final campaign = _campaigns[index];
    final double newAmount = campaign.currentAmount + quantity;
    final double newProgress = (newAmount / campaign.goalAmount).clamp(0.0, 1.0);

    _campaigns[index] = campaign.copyWith(
      currentAmount: newAmount,
      progress: newProgress,
    );

    final pointsGained = quantity * 15;
    _totalItemsDonated += quantity;
    _impactScore += pointsGained;

    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final dateStr = 'Selesai, ${now.day} ${months[now.month - 1]}';

    final newRecord = DonationRecord(
      id: 'h-${now.millisecondsSinceEpoch}',
      campaignId: campaignId,
      title: campaign.title,
      dateText: dateStr,
      timestamp: now,
      quantity: quantity,
      unit: campaign.unit,
      impactPoints: pointsGained,
      emoji: campaign.imageEmoji,
      imageUrl: campaign.imageUrl,
      color: campaign.imageColor,
      status: 'Selesai',
      pickupMethod: method,
    );

    _history.insert(0, newRecord);
    notifyListeners();
    return true;
  }

  void updateProfile({required String name, required String email}) {
    _userName = name.trim();
    _userEmail = email.trim();
    notifyListeners();
  }

  void login({required String email, required String password}) {
    _isLoggedIn = true;
    _userEmail = email.trim();
    notifyListeners();
  }

  void register({required String name, required String email, required String password}) {
    _userName = name.trim();
    _userEmail = email.trim();
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
