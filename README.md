# **BALLISTIC**

![Logo](images/logo.png)

## **Daftar Nama Anggota Kelompok**

* Jonathan Hans Emanuelle 2406414025 
* Alexius Christhoper Wijaya 2406496164 
* Jovian Felix Rustan 2406360016 
* Aufa Daffa' Satriatama 2406426321 
* Mirza Radithya Ramadhana 2406405563 
* Jovanus Irwan Susanto 2406434140

---

# **Deskripsi Aplikasi**

**Ballistic** adalah sebuah website e-commerce peralatan olahraga yang dirancang untuk mempermudah pengguna dalam membeli, menjual, dan berinteraksi seputar perlengkapan olahraga secara praktis dan personal. Platform ini ditujukan bagi pecinta olahraga maupun penjual perlengkapan olahraga yang ingin memiliki satu tempat untuk bertransaksi, berbagi pengalaman, serta mengelola akun dan produk dengan efisien.
Produk yang dijual meliputi baju olahraga, celana, bola, botol minum, dan kaus kaki, lengkap dengan informasi harga, stok, ukuran, dan ulasan pengguna lainnya.

Salah satu keunggulan **Ballistic** adalah adanya modul rekomendasi ukuran berbasis berat dan tinggi badan, di mana pengguna cukup memasukkan data tubuh mereka untuk mendapatkan rekomendasi ukuran yang sesuai (S, M, L, atau XL). Fitur ini membantu pengguna memilih produk dengan lebih akurat dan mengurangi risiko kesalahan ukuran saat berbelanja online. Selain itu, terdapat modul review produk yang memungkinkan pengguna memberikan komentar dan rating terhadap barang yang telah dibeli. Review dengan rating tertinggi akan muncul di bagian atas, sehingga calon pembeli dapat menilai kualitas produk dengan cepat dan objektif.

Proses transaksi di **Ballistic** didukung oleh modul pembelian produk yang mengatur seluruh tahapan pembelian mulai dari pemilihan produk, konfirmasi pembayaran melalui saldo internal, hingga proses verifikasi oleh admin. Transaksi akan masuk ke status pending sebelum disetujui oleh admin untuk memastikan keaslian dan keamanan pembelian. Setelah disetujui, saldo pembeli otomatis terpotong dan saldo penjual bertambah.

Di sisi manajemen, terdapat dua modul yang hanya dapat diakses oleh admin: modul News dan modul Voucher. Modul News digunakan untuk membuat dan mengelola berita seputar promosi, event olahraga, maupun pengumuman penting dari toko. Sedangkan modul Voucher digunakan untuk membuat, memperbarui, atau menghapus kode promo dan potongan harga yang berlaku. Kedua modul ini membantu admin menjaga informasi dan promosi toko agar selalu menarik dan relevan bagi pengguna.

Selain berfokus pada transaksi, **Ballistic** juga membangun sisi komunitas melalui modul Forum Diskusi, tempat pengguna dapat membuat postingan, berdiskusi, dan berbagi tips seputar olahraga atau pengalaman menggunakan produk. Forum ini menjadikan **Ballistic** bukan hanya platform jual beli, tetapi juga ruang interaktif bagi komunitas olahraga.

Dengan integrasi keenam modul tersebut — Admin News, Admin Voucher, Pembelian Produk, Review Produk, Berat Badan, dan Forum Diskusi — **Ballistic** menghadirkan pengalaman belanja yang lebih cerdas, efisien, dan interaktif. Platform ini tidak hanya membantu pengguna mendapatkan produk yang sesuai, tetapi juga membangun ekosistem olahraga digital yang aman, aktif, dan saling terhubung.

---

# **Daftar Modul & Pembagian Kerja**

### **1. Modul Review Produk — Aufa Daffa**

Modul ini menampilkan ulasan pengguna terhadap produk peralatan olahraga yang dijual di website. Setiap pengguna dapat memberikan komentar dan penilaian berupa bintang (1–5). Sistem akan otomatis mengurutkan ulasan berdasarkan nilai bintang tertinggi, sehingga review dengan rating 5 bintang akan tampil paling atas. Hal ini bertujuan agar pengguna lain dapat langsung melihat penilaian terbaik dari pelanggan sebelumnya dan meningkatkan kepercayaan terhadap produk. Admin atau penjual juga dapat melihat rata-rata rating untuk memantau kualitas produknya.

---

### **2. Modul Forum — Mirza**

Modul Forum berfungsi sebagai wadah interaksi antar pengguna untuk berdiskusi mengenai olahraga, produk, maupun tips penggunaan perlengkapan. Pengguna dapat membuat postingan baru, membaca diskusi dari pengguna lain, mengedit posting mereka, serta menghapus komentar atau topik yang tidak relevan. Pengguna juga dapat menghubungkan forum dengan produk yang dijual agar forum dapat terfokus pada pembahasan suatu produk. Forum ini juga dapat dimoderasi oleh admin untuk menjaga kenyamanan dan etika diskusi. Melalui fitur ini, Ballistic tidak hanya menjadi platform jual beli, tetapi juga komunitas bagi para pecinta olahraga.

---

### **3. Modul Rekomendasi Ukuran (Baju dan Celana) — Jovian**

Modul ini digunakan untuk menyimpan data tinggi dan berat pengguna yang menjadi dasar bagi sistem rekomendasi ukuran. Setiap pengguna dapat menambahkan data berat badan mereka, memperbaruinya seiring waktu, atau menghapus data lama yang tidak relevan. Modul ini memiliki relasi one-to-many dengan pembelian atau produk, karena satu pengguna bisa memiliki beberapa data pengukuran yang digunakan untuk menyesuaikan rekomendasi ukuran pakaian (S, M, L, XL). Fitur ini membuat pengalaman belanja menjadi lebih personal dan akurat.

---

### **4. Modul Create News — Jovanus**

Modul News hanya dapat diakses oleh admin dan berfungsi untuk mengelola berita resmi yang berkaitan dengan promosi, event olahraga, maupun pengumuman penting dari Ballistic. Admin dapat membuat, membaca, memperbarui, dan menghapus (CRUD) berita sesuai kebutuhan. Setiap berita akan muncul di halaman utama atau menu informasi pengguna, membantu menjaga komunikasi antara pihak toko dan pelanggan. Dengan adanya modul ini, platform selalu menampilkan informasi terbaru, relevan, dan profesional. Selain fungsi utama di atas, Modul News juga dilengkapi dengan fitur integrasi produk: Saat berita memiliki keterkaitan atau pembahasan mengenai produk tertentu, halaman detail berita tidak hanya menampilkan konten artikel, tetapi juga akan menyajikan rekomendasi produk terkait. Contoh: Jika berita berisi liputan seputar botol minum, maka detail berita akan memunculkan isi news tersebut disertai dengan daftar produk botol minum yang relevan.

---

### **5. Modul Tampilan Produk & Pembelian — Jonathan Hans Emanuelle**

Modul ini menangani seluruh proses pembelian produk oleh pengguna. Ketika pengguna membeli barang dan saldo mencukupi, sistem akan mencatat transaksi baru dengan status “Pending” untuk diverifikasi oleh admin. Setelah disetujui, saldo pembeli otomatis terpotong dan saldo penjual bertambah. Modul ini juga menampilkan daftar riwayat pembelian, status transaksi, serta detail produk yang dibeli. Admin dan pengguna dapat memantau pembelian melalui dashboard yang aman dan transparan.

---

### **6. Modul Voucher — Alexius Christhoper Wijaya**

Modul Voucher juga bersifat eksklusif untuk admin dan digunakan untuk mengatur sistem diskon atau promo pembelian. Admin dapat membuat kode voucher baru, seperti potongan harga serta menentukan masa berlaku (aktif/tidak) . Admin juga dapat melihat daftar voucher aktif, memperbarui informasi voucher, dan menghapus voucher yang sudah tidak berlaku. Modul ini mendukung strategi pemasaran toko agar lebih menarik dan meningkatkan penjualan produk olahraga di platform.

---

# **Peran Pengguna (Aktor)**

### **Admin**

Admin memiliki tingkat akses tertinggi dalam sistem Ballistic. User dengan role ini bertanggung jawab untuk mengawasi, mengatur, dan memverifikasi seluruh aktivitas penting di platform, khususnya yang berkaitan dengan transaksi dan konten publik. Admin memiliki akses penuh terhadap dua modul khusus, yaitu modul News dan modul Voucher. Melalui modul News, admin dapat membuat, mengedit, dan menghapus berita atau pengumuman terkait promosi, event olahraga, maupun informasi penting lainnya. Sementara modul Voucher digunakan untuk mengatur kode promo, potongan harga, serta masa berlaku voucher yang dapat digunakan oleh pembeli. Selain itu, admin juga memiliki kemampuan untuk melihat data analitik sistem, seperti jumlah akun, total transaksi, transaksi gagal (karena saldo tidak cukup atau ditolak), dan produk paling populer. Admin juga berperan penting dalam verifikasi transaksi pembelian, di mana setiap pembelian dengan status pending harus disetujui (approve) agar transaksi dinyatakan berhasil. Batasan: User dengan role Admin tidak dapat memiliki role lain seperti Penjual atau Pembeli. Tujuan utama: menjaga transparansi, keamanan, dan kelancaran seluruh proses dalam sistem Ballistic.

### **Penjual**

Role Penjual memungkinkan user untuk menawarkan dan mengelola produk di platform melalui modul Pembelian (Produk). Penjual dapat membuat entri produk baru, melengkapi informasi seperti nama barang, deskripsi, kategori, stok, harga, dan gambar. Modul ini juga memungkinkan mereka untuk menghapus atau memperbarui data produk sesuai kebutuhan. Penjual dapat memantau status transaksi produk mereka, apakah sedang dalam proses, berhasil, atau dibatalkan oleh admin. Selain itu, penjual juga bisa menerima review produk dari pembeli sebagai bentuk umpan balik yang membantu meningkatkan kualitas produk. Hak akses utama: mengelola data produk dan memantau transaksi yang berkaitan dengan barang yang mereka jual. Tujuan utama: memberikan kesempatan bagi user untuk membuka toko olahraga secara digital dan memperluas jangkauan penjualan mereka.

### **Pembeli**

Role Pembeli berfungsi untuk memungkinkan user melakukan pencarian, pemilihan, dan pembelian produk olahraga yang dijual oleh para penjual di Ballistic. Melalui modul Pembelian Produk, pembeli dapat melakukan transaksi dengan saldo internal yang dimiliki, yang akan otomatis terpotong setelah admin menyetujui pembelian. Jika saldo tidak mencukupi, maka transaksi otomatis gagal. Pembeli juga dapat memberikan review dan rating produk melalui modul Review, membantu pengguna lain dalam menilai kualitas barang. Selain itu, terdapat modul Berat Badan, di mana pembeli dapat memasukkan tinggi dan berat badan mereka untuk memperoleh rekomendasi ukuran produk (S, M, L, XL) yang sesuai. Pembeli juga dapat berpartisipasi dalam modul Forum Diskusi, tempat berbagi pengalaman, bertanya seputar olahraga, dan berinteraksi dengan komunitas. Hak akses utama: melihat katalog produk, melakukan pembelian, memberikan ulasan, dan ikut serta dalam forum. Tujuan utama: memberikan pengalaman belanja yang mudah, akurat, dan interaktif bagi pengguna.

---
# **Alur Pengintegrasian Data Web ↔ Aplikasi**

## **Modul Shop**

Modul ini mengurus alur pembelian mulai dari setiap transaksi dicatat sebagai “Pending” dulu untuk diverifikasi admin, lalu saldo pembeli dipotong dan saldo penjual nambah setelah disetujui. Pengguna bisa lihat riwayat dan status pembelian, lengkap dengan detail produknya. Semua dapat dipantau lewat dashboard yang jelas dan aman.

### **Model Product**

1. Id = id setiap produk (UUIDField)
2. User = user yang membuat suatu produk (user)
3. Name = nama produk (CharField)
4. Price = harga produk (PositiveIntegerField)
5. Size = ukuran produk (CharField)
6. Brand = brand produk (CharField)
7. Description = deskripsi produk (TextField)
8. Category = kategori produk (CharField)
9. Thumbnail = link thumbnail produk (URLField)
10. Is_featured = status produk (BooleanField)

### **Model Transaction**

1. Id = id setiap transaksi (UUIDField)
2. User = user yang membuat transaksi (user)
3. Product = produk yang dibeli dalam transaksi (Product)
4. Voucher = voucher yang dipakai dalam transaksi (Voucher)
5. Used_voucher_code = kode voucher yang digunakan (CharField)
6. Quantity = kuantitas produk (PositiveIntegerField)
7. Original_product_price = harga produk sebelum diskon (PositiveIntegerField)
8. Applied_discount_percentage = persentase diskon yang digunakan (PositiveIntegerField)
9. Final_price = harga akhir (PositiveIntegerField)
10. Purchase_timestamp = timestamp transaksi (DateTimeField)

---

## **Modul Review**

Modul ini menampilkan komentar dan rating bintang untuk produk olahraga, lalu otomatis ngasih urutan dari rating tertinggi biar ulasan terbaik langsung kelihatan. Pengguna jadi gampang ngecek kualitas produk, sementara admin bisa mantau rata-rata rating buat evaluasi.

### **Model Review**

1. User = user yang melakukan review (user)
2. Id = id setiap review (UUIDField)
3. Product = product yang di review (product)
4. Comment = comment di review (TextField)
5. Star = rating review (IntegerField)

---

## **Modul Forum**

Modul ini jadi tempat pengguna ngobrol soal olahraga maupun produk lengkap dengan fitur bikin postingan, edit, dan hapus komentar/topik. Forum bisa dikaitkan ke produk tertentu dan tetap dijaga admin biar diskusinya rapi. Fungsinya bukan cuma jualan, tapi ngebangun komunitas pecinta olahraga.

### **Model Forum**

1. Id = id sebuah forum (UUIDField)
2. Author = pembuat forum (user)
3. Title = judul forum (CharField)
4. Created_at = timestamp dibuatnya forum (DateTimeField)
5. Forum_views = jumlah views forum (IntegerField)
6. Content = isi konten forum (TextField)
7. Updated_at = timestamp update terakhir forum (DateTimeField)

### **Model Comment**

1. id = id setiap comment (UUIDField)
2. Author = pembuat comment (user)
3. Forum = forum tempat comment dibuat (forum)
4. Created_at = timestamp dibuatnya comment (DateTimeField)
5. Updated_at = timestamp update terakhir comment (DateTimeField)
6. Content = isi comment (TextField)

---

## **Modul UserMeasurement**

Modul ini menyimpan data ukuran pengguna sebagai dasar rekomendasi ukuran baju dan celana. Pengguna bisa nambah, update, atau hapus data, dan satu pengguna bisa punya banyak riwayat pengukuran yang nyambung ke beberapa pembelian. Tujuannya biar rekomendasi ukuran lebih personal dan akurat.

### **Model UserMeasurement**

1. User : user yang sedang diukur (user)
2. Height = tinggi user (FloatField)
3. Weight = berat user (FloatField)
4. Waist = lingkar pinggang (FloatField)
5. Hip = lingkar pinggul (FloatField)
6. Chest = lingkar dada (FloatField)
7. Head_circumference = lingkar kepala (FloatField)
8. Clothes_size = data ukuran pakaian (CharField)
9. Helmet_size = data ukuran helm (CharField)

---

## **Modul Voucher**

Modul ini khusus admin untuk mengatur kode diskon sampai bikin voucher baru, atur masa berlaku, update info, atau hapus yang udah expired. Daftar voucher aktif juga bisa dipantau biar promo tetap relevan.

### **Model Voucher**

1. Id = id voucher (UUIDField)
2. Kode = Kode dari voucher (CharField)
3. Deskripsi = deskripsi dari voucher (TextField)
4. Persentase_diskon = persentase diskon voucher (DecimalField)
5. Is_active = status voucher (BooleanField)

---

## **Modul Create News**

Modul ini khusus admin untuk mengelola berita promosi, event, atau pengumuman penting, mulai dari bikin sampai hapus (CRUD). Berita muncul di halaman utama agar user selalu dapat info terbaru dan profesional. Kalau ada berita yang nyambung ke produk tertentu, halaman detailnya akan tampilin rekomendasi produk terkait.

### **Model Create News**

1. Id = id news (UUIDField)
2. Title = Judul news (CharField)
3. Author = pembuat news (CharField)
4. Content = konten news (TextField)
5. Category = kategori news (CharField)
6. Thumbnail = link thumbnail news (URLField)
7. News_views = jumlah views news (PositiveIntegerField)
8. Is_featured = status news (BooleanField)
9. Created_at = timestamp dibuatnya news (DateTimeField)
10. Updated_at = timestamp update news (DateTimeField)

---

Untuk proses integrasi data antara web dengan aplikasi, Flutter menggunakan API untuk akses backend Django.

### **Bagian Backend Django**

1. Untuk setiap modul di yang sudah ada, buat sebuah endpoint di views.py untuk mengembalikan data dalam format JSON.
2. Endpoint ini bisa diakses lewat request http seperti POST, GET, DELETE, dan lain-lain.
3. Jika ada request dari Flutter, Django membacanya dan handle request tersebut dengan proses (DB query, auth, business logic).
4. Hasil data yang sudah siap bisa dikembalikan ke Flutter.

### **Bagian Flutter**

1. Atur konfigurasi di Flutter agar bisa berkomunikasi dengan backend Django.
2. Gunakan package http untuk mengirimkan request ke backend Django.
3. Buat model terpisah di Flutter agar bisa diparsing dari JSON.
4. Setelah Flutter mendapat response dari Django, dia akan melakukan parse JSON.
5. Data yang sudah ready akan ditampilkan sesuai design UI masing-masing.

Alur tersebut adalah alur umum yang berlaku untuk semua modul di aplikasi kita.

---

# **Dataset**

[https://www.kaggle.com/datasets/larysa21/retail-data-american-football-gear-sales](https://www.kaggle.com/datasets/larysa21/retail-data-american-football-gear-sales)

---

# **Link Design Figma**

[https://www.figma.com/design/rHpMYLPtteWHwq94USKdcJ/PBP-PAS?node-id=0-1&p=f&t=h8mZUdwtHy265SjL-0](https://www.figma.com/design/rHpMYLPtteWHwq94USKdcJ/PBP-PAS?node-id=0-1&p=f&t=h8mZUdwtHy265SjL-0)

---

# **PWS**

[https://jovian-felix-ballistic.pbp.cs.ui.ac.id/](https://jovian-felix-ballistic.pbp.cs.ui.ac.id/)

---
