## LAPORAN AKHIR PRAKTIKUM MODUL 5: THE SHADOW OF THE EAST

Kelompok: K14
Prefix IP Utama: 192.218.0.0/23

I. PEMBUATAN VLSM DAN STRUKTUR JARINGAN

1. Tabel Hasil VLSM

Pembagian alamat IP dilakukan menggunakan VLSM (Variable Length Subnet Mask) berdasarkan kebutuhan host terbesar ke terkecil, dimulai dari prefix utama 192.218.0.0/23.

<img width="968" height="296" alt="Screenshot 2025-12-03 220526" src="https://github.com/user-attachments/assets/02708599-a013-4f61-bc58-97b292c55bcc" />

2. Diagram Pohon Subnet

<img width="527" height="549" alt="Screenshot 2025-12-03 220600" src="https://github.com/user-attachments/assets/635ab794-ba30-445a-a12d-27c825cddc8b" />

# MISI 1: Routing & Konektivitas

Target: Membuktikan semua perangkat (Router & Client) sudah terhubung dan Client mendapatkan IP otomatis.

1. Cek IP Address Client (DHCP)

Pertanyaan Asisten: "Coba lihatkan IP Elendil dan Gilgalad, apakah sudah dapat IP yang benar?"

Perintah (di Node Elendil/Gilgalad):

ip a


Verifikasi:

eth0 harus punya IP.

Elendil: 192.218.0.x


<img width="802" height="369" alt="Screenshot 2025-12-03 221232" src="https://github.com/user-attachments/assets/03d15f9a-778f-4029-87d3-fed0eb1f09fd" />


2. Tes Ping Lintas Subnet (Routing)

Pertanyaan Asisten: "Buktikan kalau routing dari Kiri (Elendil) bisa sampai ke Kanan (Gilgalad)."

Perintah (di Node Elendil):

ping [IP_GILGALAD]
Contoh: ping 192.218.1.11


Hasil: Harus Reply (TTL=...).

<img width="721" height="226" alt="Screenshot 2025-12-03 195029" src="https://github.com/user-attachments/assets/bd5e9af9-916a-4dbe-82a5-8e8b438cfa0f" />

# MISI 2: Security Rules (Firewall)

Target: Membuktikan aturan keamanan IPTables berfungsi.

Soal 1: Akses Internet (SNAT)

Perintah (di Osgiliath/Client):

ping 8.8.8.8


Hasil: Reply. Membuktikan SNAT di Osgiliath jalan.

<img width="716" height="223" alt="Screenshot 2025-12-03 200358" src="https://github.com/user-attachments/assets/178c95f0-b87d-4b49-aab4-d6cb26f40332" />


Soal 2: No Ping ke Vilya

Pertanyaan: "Coba ping Vilya dari client, harusnya gak bisa."

Perintah (di Elendil):

ping 192.218.1.202

<img width="616" height="66" alt="Screenshot 2025-12-03 211702" src="https://github.com/user-attachments/assets/65f13de4-dbd4-4f3b-aa26-959a668c543d" />


Hasil: Request Timeout (Diam/Stuck). Tekan Ctrl+C untuk berhenti. Ini membuktikan Vilya menolak ping.

Soal 3: Akses DNS Narya (Hanya Vilya)

Skenario A (Gagal): Akses dari Elendil.

Node: Elendil

Perintah:

Pastikan netcat sudah diinstall di Elendil
nc -zv 192.218.1.203 53

<img width="666" height="43" alt="Screenshot 2025-12-03 211844" src="https://github.com/user-attachments/assets/0e6aed15-e3f4-40fe-96ab-e829f201c55d" />


Hasil: Connection timed out (atau tidak muncul "Open").

Skenario B (Sukses): Akses dari Vilya.

Node: Vilya

Perintah:

nc -zv 192.218.1.203 53


<img width="640" height="67" alt="Screenshot 2025-12-03 202648" src="https://github.com/user-attachments/assets/bdc8e845-3eb3-4adc-b7f7-1122c56754d7" />


Hasil: Connection to 192.218.1.203 53 port [tcp/domain] succeeded!

Soal 4: IronHills Weekend Only

Persiapan: Cek hari di server IronHills (date). Asumsikan hari ini Rabu (bukan weekend).

Node: Elendil

Perintah:

curl 192.218.1.238

<img width="494" height="60" alt="Screenshot 2025-12-03 211951" src="https://github.com/user-attachments/assets/617408b4-58cd-4040-acdf-125aa93ece45" />


Hasil: Gagal / Timeout (karena bukan hari Sabtu/Minggu).

Cara Membuktikan Sukses (Opsional saat demo): Minta izin asisten ubah tanggal di IronHills.

Di IronHills: date -s "2025-12-06 12:00:00" (Sabtu).

<img width="686" height="65" alt="Screenshot 2025-12-03 212010" src="https://github.com/user-attachments/assets/136c8dc4-06db-4fa9-99c7-c3394fb66890" />


Coba curl lagi dari Elendil -> Harusnya muncul "Welcome to IronHills".

<img width="510" height="54" alt="Screenshot 2025-12-03 212020" src="https://github.com/user-attachments/assets/b06691c1-565d-4b2f-bd13-3b5c511b03db" />


Soal 5: Palantir Time Restriction (Ras)

Skenario: Elendil (Manusia) hanya boleh jam 17.00 - 23.00.

Test Gagal (Pagi Hari):

Di Palantir: date -s "2025-12-03 08:00:00"

<img width="640" height="61" alt="Screenshot 2025-12-03 212053" src="https://github.com/user-attachments/assets/60db9075-bfa5-4bc5-9b82-10b34c821a35" />

<img width="474" height="49" alt="Screenshot 2025-12-03 212109" src="https://github.com/user-attachments/assets/65377609-7234-4262-9a90-3fde5208dd1f" />

Dari Elendil: curl 192.218.1.218 -> Hasil: Timeout/Gagal.

Test Sukses (Malam Hari):

Di Palantir: date -s "2025-12-03 20:00:00"

<img width="546" height="64" alt="Screenshot 2025-12-03 212127" src="https://github.com/user-attachments/assets/7a9ed4ef-a256-433f-9fde-3f4e5e6f0dd4" />

<img width="581" height="60" alt="Screenshot 2025-12-03 212148" src="https://github.com/user-attachments/assets/9694d339-d155-4fa0-924e-94587f49633d" />

Dari Elendil: curl 192.218.1.218 -> Hasil: "Welcome to Palantir".

Soal 6: Port Scan Protection

Pertanyaan: "Coba scan Palantir, pastikan IP penyerang di-banned."

PENTING: Gunakan scan agresif agar terdeteksi oleh firewall.

Langkah (di Elendil):

Scan (Mode Insane/Cepat):

nmap -sS -T5 -p 1-1000 192.218.1.218


SEGERA setelah scan (atau di terminal lain secara bersamaan), coba ping ke Palantir.

ping 192.218.1.218

<img width="756" height="442" alt="Screenshot 2025-12-03 212438" src="https://github.com/user-attachments/assets/3aaf1fdc-57bc-4d08-942d-65b9a5247c32" />

Hasil: Ping akan RTO (Request Timeout) karena IP Elendil sudah masuk blacklist sementara.

Soal 7: IronHills Connection Limit

Node: Elendil

Perintah (Stress Test):

ab -n 100 -c 10 [http://192.218.1.238/](http://192.218.1.238/)

<img width="788" height="125" alt="Screenshot 2025-12-03 214010" src="https://github.com/user-attachments/assets/0f319fb9-2c41-4904-ab93-d3c9678e41fd" />

Soal 8: Redirect Traffic (Vilya -> Khamul belok ke IronHills)

Persiapan: Buka console IronHills, jalankan listener:

nc -l -p 80


<img width="474" height="58" alt="Screenshot 2025-12-03 214615" src="https://github.com/user-attachments/assets/d3836cab-03d9-4e73-9b38-2d7ba6c67f81" />

# MISI 3: Isolasi Sang Nazgûl (Khamul)

Tujuan: Membuktikan Khamul terisolasi total dari jaringan.

1. Test Keluar (Khamul -> Luar)

Node: Khamul

Perintah:

ping 192.218.0.10
(Ping ke Elendil)

<img width="466" height="70" alt="Screenshot 2025-12-03 215624" src="https://github.com/user-attachments/assets/ae6f5886-ae28-461f-982d-7e43e6bfbca4" />

Hasil: Request Timeout. Khamul tidak bisa menghubungi siapapun.

2. Test Masuk (Luar -> Khamul)

Node: Elendil

Perintah:

ping [IP_KHAMUL]

<img width="647" height="78" alt="Screenshot 2025-12-03 215617" src="https://github.com/user-attachments/assets/e16cb75f-0130-451f-b0fa-31431c23a6dd" />

Hasil: Request Timeout. Tidak ada yang bisa menghubungi Khamul.

Hasil: Reply/Berhasil. Durin aman, Khamul terisolasi.

Bukti (Screenshot): Reply (0% Packet Loss).
