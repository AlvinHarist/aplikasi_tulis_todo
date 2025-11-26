# 📝 Tulis App - To Do List

**Tulis App** adalah aplikasi manajemen tugas berbasis Android yang dibangun menggunakan **Flutter**. Aplikasi ini dirancang dengan antarmuka yang bersih, modern, dan ramah pengguna untuk membantu mencatat kegiatan sehari-hari.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## ✨ Fitur Utama

Aplikasi ini memiliki fitur lengkap untuk manajemen tugas:

* **Tambah Tugas:** Menambahkan judul dan deskripsi tugas baru.
* **Edit Tugas:** Mengubah detail tugas jika ada kesalahan atau perubahan.
* **Hapus Tugas:** Menghapus tugas yang tidak diperlukan lagi.
* **Checklist Status:** Menandai tugas sebagai "Selesai" (akan dicoret dan dipindah ke bawah).
* **Penyimpanan Lokal:** Data tersimpan permanen di memori HP menggunakan `Shared Preferences`, sehingga tidak hilang saat aplikasi ditutup.
* **Smart Sorting:** Memisahkan tugas yang masih aktif dan yang sudah selesai secara otomatis.
* **Empty State Visualization:** Menampilkan ilustrasi menarik ketika tidak ada tugas aktif.

## 📱 Tampilan Antarmuka (UI)

Aplikasi ini didesain sesuai dengan *mockup* Figma dengan nuansa warna Earthy & Fresh Green.

| Halaman Utama (Kosong) | Form Tambah Tugas | Daftar Tugas |
|:----------------------:|:-----------------:|:------------:|
| ![Empty State](assets/screenshot_empty.png) | ![Form Input](assets/screenshot_form.png) | ![Task List](assets/screenshot_list.png) |

> *Catatan: Screenshot di atas hanyalah placeholder. Silakan ganti dengan screenshot asli aplikasi Anda.*

## 🛠️ Teknologi yang Digunakan

* **Framework:** Flutter (Dart)
* **Architecture:** MVC (Model-View-Controller) sederhana dalam Single File.
* **State Management:** `setState` (Native)
* **Local Storage:** `shared_preferences` package.
* **Assets:** Custom images & Icons.

## 🚀 Cara Menjalankan Aplikasi

Pastikan Anda sudah menginstal Flutter SDK.

1.  **Clone repositori ini** (jika ada) atau unduh zip file.
2.  Buka terminal di folder proyek.
3.  **Instal dependensi:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

## 📂 Struktur Proyek

Proyek ini menggunakan struktur sederhana untuk kemudahan pengembangan:

```text
lib/
└── main.dart          # Seluruh logika UI, Model, dan Controller ada di sini.
assets/
└── kertas.jpg         # Aset gambar untuk ilustrasi kosong.
pubspec.yaml           # Konfigurasi dependensi dan aset.
