-- Member 

-- login
SELECT
	-- return kalo ada
	username
FROM
	Pengguna 
	INNER JOIN Member
	ON Pengguna.idPengguna = Member.idPengguna
WHERE
	-- input berupa nama Member
	Pengguna.username = 'Joko'


-- Melihat daftar harga beli sampah
SELECT
	namaSampah, 
	hargaSampah
FROM
	Sampah
	INNER JOIN
	(
	SELECT
		idSampah,
		MAX (tanggalUbah) as updateTerbaru
	FROM
		Harga
	GROUP BY
		idSampah
	) AS Latest
	ON Sampah.idSampah = Latest.idSampah
	INNER JOIN Harga
	ON Sampah.idSampah = Harga.idSampah
WHERE
	Harga.tanggalUbah = Latest.updateTerbaru


-- Histori setoran sampah
SELECT
	Transaksi.tanggal,
	Sampah.namaSampah,
	TransaksiSampah.jumlahSampah,
	TransaksiSampah.hargaTotal
FROM
	Member
	INNER JOIN Transaksi
	ON Member.idPengguna = Transaksi.idPengguna
	INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN Sampah
	ON TransaksiSampah.idSampah = Sampah.idSampah
WHERE
	Member.idPengguna = 
	(
	SELECT
		idPengguna
	FROM
		Pengguna
	WHERE
		-- username berdasarkan member yang sedang log in (kasus ini joko)
		username = 'Joko'
	) AND
	tipeTransaksi = 1
ORDER BY
	tanggal

-- penghasilan setoran sampah dalam rentang waktu tertentu (semua)
SELECT
	tanggal,
	SUM (hargaTotal) AS 'total pendapatan'
FROM
	Transaksi
	INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN
	(
		SELECT idPengguna FROM Pengguna 
		-- username berdasarkan member yang sedang log in (kasus ini joko)
		WHERE username = 'Joko'
	) AS PengInput
	ON PengInput.idPengguna = Transaksi.idPengguna
WHERE
	-- tanggal mulai dan akhir berdasarkan input (maret 2024 - juni 2024)
	tanggal >= '20240301' AND 
	tanggal <= '20240630' AND
	tipeTransaksi = 1
GROUP BY
	tanggal

-- penghasilan setoran sampah dalam rentang waktu tertentu (tahun)

SELECT
	DATEPART (YEAR, tanggal) AS tahun,
	SUM (hargaTotal) AS 'total pendapatan'
FROM
	Transaksi
	INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN
	(
		SELECT
			idPengguna
		FROM
			Pengguna
		WHERE
			-- username berdasarkan member yang sedang log in (kasus ini joko)
			username = 'Joko'
	) AS PengInput
	ON PengInput.idPengguna = Transaksi.idPengguna
WHERE
	tipeTransaksi = 1
GROUP BY
	DATEPART (YEAR, tanggal)

-- penghasilan setoran sampah dalam rentang waktu tertentu (bulan)

SELECT
	DATEPART (MONTH, tanggal) AS bulan,
	SUM (hargaTotal) AS 'total pendapatan'
FROM
	Transaksi
	INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN
	(
		SELECT
			idPengguna
		FROM
			Pengguna
		WHERE
			-- username berdasarkan member yang sedang log in (kasus ini joko)
			username = 'Joko'
	) AS PengInput
	ON PengInput.idPengguna = Transaksi.idPengguna
WHERE
	tipeTransaksi = 1
GROUP BY
	DATEPART (MONTH, tanggal)
-- Ibu BS

-- Log in
SELECT
	-- return password
	password
FROM
	Pengguna 
	INNER JOIN IbuBS
	ON Pengguna.idPengguna = IbuBS.idPengguna
WHERE
	-- input berupa nama IbuBS
	Pengguna.username = 'Hani'

-- input sampah
-- sampah memiliki 2 Fk

-- lihat list jenis sampah
SELECT
	*
FROM
	JenisSampah

-- lihat list SUK sampah
SELECT
	*
FROM
	SUK

-- lihat id terakhir
SELECT TOP 1
	idSampah
FROM
	Sampah
ORDER BY
	idSampah DESC

-- insert sampah 
INSERT INTO Sampah (namaSampah, idJenisSampah, idSUK)
VALUES
	-- input berupa nama sampah, id jenis yang dipilih, id SUK yang dipilih
	('Botol Plastik 1500ml', 1, 2)

INSERT INTO Harga (tanggalUbah, hargaSampah)
VALUES
	-- input tanggal memasukkan informasai, harga sampah
	('20240605', 2200)

-- output list sampah
SELECT
	idSampah,
	namaSampah
FROM	
	Sampah

-- update harga
INSERT INTO Harga (idSampah, tanggalUbah, hargaSampah)
VALUES	
	(14, '20240606', 2300)

-- input transaksi masuk
-- input member, transaksi, transaksi sampah

INSERT INTO Transaksi (tanggal, tipeTransaksi, idPengguna, idBSPusat)
VALUES
	('20240607', 1, 
	(SELECT
		idPengguna
	FROM
		Pengguna
	WHERE
		-- insert username
		username = 'Joko'),
	null)

-- tunjukkan daftar sampah
SELECT
	idSampah, namaSampah, namaSUK
FROM
	Sampah INNER JOIN SUK
	ON Sampah.idSUK = SUK.idSUK
-- loop sebanyak jenis sampah
INSERT INTO TransaksiSampah (idTransaksi, idSampah, jumlahSampah, hargaTotal)
VALUES 
	((SELECT TOP 1
		idTransaksi
	FROM
		Transaksi
	ORDER BY
		idTransaksi DESC), 
	-- input id dan jumlah sampah tersebut
	-- 4 * -> juga jumlah sampah jadi jangan lupa diisi
	1, 4, 4 * 
			(
			SELECT TOP 1
				hargaSampah
			FROM
				Sampah
				INNER JOIN Harga
				ON Sampah.idSampah = Harga.idSampah,
				Transaksi
			WHERE
				Sampah.idSampah = 1 AND
				Transaksi.idTransaksi = 
				(SELECT TOP 1
					idTransaksi
				FROM
					Transaksi
				ORDER BY
					idTransaksi DESC) AND
				Harga.tanggalUbah <= Transaksi.tanggal
			ORDER BY
				Harga.tanggalUbah DESC
			))


-- input transaksi keluar
-- tunjukkin list BS Pusat berdasarkan kelurahannya
SELECT
	idBSPusat, namaKel
FROM
	BSPusat 
	INNER JOIN Kelurahan
	ON BSPusat.idKel = Kelurahan.idKel

INSERT INTO Transaksi (tanggal, tipeTransaksi, idPengguna, idBSPusat)
VALUES
	-- input tanggal
	('20240607', 2, 
	null, 
	-- input id BS Pusat
	1)

-- loop tergantung jumlah jenis sampah
INSERT INTO TransaksiSampah (idTransaksi, idSampah, jumlahSampah, hargaTotal)
VALUES 
	((SELECT TOP 1
		idTransaksi
	FROM
		Transaksi
	ORDER BY
		idTransaksi DESC), 
	-- input id dan jumlah sampah tersebut
	-- 4 * -> juga jumlah sampah jadi jangan lupa diisi
	1, 4, 4 * 
			(
			SELECT TOP 1
				hargaSampah
			FROM
				Sampah
				INNER JOIN Harga
				ON Sampah.idSampah = Harga.idSampah,
				Transaksi
			WHERE
				Sampah.idSampah = 1 AND
				Transaksi.idTransaksi = 
				(SELECT TOP 1
					idTransaksi
				FROM
					Transaksi
				ORDER BY
					idTransaksi DESC) AND
				Harga.tanggalUbah <= Transaksi.tanggal
			ORDER BY
				Harga.tanggalUbah DESC
			))

-- transaksi masuk (member)
SELECT
	tanggal, nama, namaSampah, hargaTotal
FROM
	Transaksi INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN Member
	ON Transaksi.idPengguna = Member.idPengguna
	INNER JOIN Pengguna
	ON Pengguna.idPengguna = Member.idPengguna
	INNER JOIN Sampah
	ON TransaksiSampah.idSampah = Sampah.idSampah

-- transaksi keluar (BS pusat)
SELECT
	tanggal, namaKel, namaSampah, hargaTotal
FROM
	Transaksi INNER JOIN TransaksiSampah
	ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi
	INNER JOIN Sampah
	ON TransaksiSampah.idSampah = Sampah.idSampah
	INNER JOIN BSPusat
	ON Transaksi.idBSPusat = BSPusat.idBSPusat
	INNER JOIN Kelurahan
	ON BSPusat.idKel = Kelurahan.idKel

-- get member
SELECT 
		p.nama, 
		p.username, 
		m.email, 
		m.noHP, 
		m.alamat, 
		k.namaKel
	FROM 
		Pengguna p
	INNER JOIN 
		Member m ON p.idPengguna = m.idPengguna
	INNER JOIN 
		Kelurahan k ON m.idKel = k.idKel;
