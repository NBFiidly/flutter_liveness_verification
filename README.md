# Flutter Liveness Verification

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11%2B-02569B?style=for-the-badge&logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11%2B-0175C2?style=for-the-badge&logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Camera-%20Enabled-4CAF50?style=for-the-badge" alt="Camera Enabled" />
  <img src="https://img.shields.io/badge/Face%20Detection-Google%20ML%20Kit-4285F4?style=for-the-badge" alt="Google ML Kit" />
</p>

<p align="center">
  <strong>Demo aplikasi verifikasi liveness wajah berbasis Flutter</strong>
</p>

Aplikasi ini dirancang untuk memeriksa apakah pengguna adalah manusia yang benar-benar berada di depan kamera, bukan hanya foto atau rekaman. Dengan memanfaatkan kamera depan dan deteksi wajah dari Google ML Kit, aplikasi ini menjalankan serangkaian instruksi liveness seperti melihat ke depan, berkedip, memiringkan kepala, dan tersenyum.

## ✨ Fitur Utama

- Kamera depan otomatis aktif saat aplikasi dibuka
- Deteksi wajah real-time menggunakan Google ML Kit
- Verifikasi liveness berdasarkan gerakan wajah:
  - melihat ke depan
  - berkedip
  - melihat ke atas dan bawah
  - memutar kepala ke kiri dan kanan
  - tersenyum
- Progress indicator yang menampilkan langkah aktif saat proses verifikasi berjalan
- UI yang sederhana, modern, dan siap digunakan untuk prototype atau integrasi produk

## 🧠 Cara Kerja

Proses verifikasi berjalan secara bertahap, di mana pengguna diminta mengikuti instruksi tertentu. Setiap langkah akan dicek berdasarkan posisi wajah, orientasi kepala, dan probabilitas mata/tersenyum yang terdeteksi oleh model ML Kit.

Jika wajah berada di frame dengan benar dan gerakan yang diminta terpenuhi, sistem akan melanjutkan ke langkah berikutnya hingga verifikasi selesai.

## 🛠️ Stack Teknologi

- Flutter
- Dart
- Camera Plugin
- Google ML Kit Face Detection

## 📁 Struktur Project

```bash
flutter_liveness_verification/
├── android/
├── ios/
├── lib/
│   ├── liveness_verification/
│   │   ├── constant/
│   │   ├── painter/
│   │   ├── utils/
│   │   ├── widget/
│   │   └── liveness_verification_page.dart
│   └── main.dart
├── assets/
├── test/
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
└── .gitignore
```

## 🚀 Persiapan

Pastikan Anda sudah memiliki:

- Flutter SDK versi 3.11+
- Android Studio / VS Code dengan plugin Flutter
- Emulator atau perangkat fisik

## ▶️ Menjalankan Aplikasi

1. Clone repository:

```bash
git clone https://github.com/NBFiidly/flutter_liveness_verification.git
cd flutter_liveness_verification
```

2. Install dependency:

```bash
flutter pub get
```

3. Jalankan aplikasi:

```bash
flutter run
```

## 📸 Alur Penggunaan

1. Buka aplikasi
2. Arahkan wajah ke area frame yang tersedia
3. Ikuti instruksi verifikasi satu per satu
4. Pastikan pencahayaan cukup dan wajah terlihat jelas
5. Tunggu hingga proses verifikasi selesai

## 💡 Catatan Penting

- Untuk validasi yang lebih stabil, gunakan pencahayaan yang cukup dan hindari bayangan di wajah.
- Aplikasi ini cocok untuk kebutuhan prototype, demo, atau integrasi ke sistem autentikasi berbasis biometrik.
- Untuk kebutuhan production, disarankan menambahkan integrasi backend, keamanan session, dan pemeriksaan lebih lanjut sesuai kebutuhan bisnis.

## 🧩 Ide Pengembangan Selanjutnya

- Menambahkan hasil verifikasi sukses/gagal
- Menyimpan log atau status autentikasi
- Integrasi API backend untuk validasi server-side
- Menambahkan theme dark mode
- Optimasi UX untuk berbagai ukuran layar

## 📌 Status Project

Project ini masih dalam tahap pengembangan dan fokus pada demonstrasi fitur liveness verification untuk Flutter.

---

<p align="center">
  <em>Dibuat untuk kebutuhan demo verifikasi wajah secara real-time dengan Flutter.</em>
</p>
