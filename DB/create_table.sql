DROP TABLE IF EXISTS Harga;
DROP TABLE IF EXISTS TransaksiSampah;
DROP TABLE IF EXISTS Sampah;
DROP TABLE IF EXISTS SUK;
DROP TABLE IF EXISTS JenisSampah;
DROP TABLE IF EXISTS Transaksi;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS IbuBS;
DROP TABLE IF EXISTS Pengguna;
DROP TABLE IF EXISTS BSPusat;
DROP TABLE IF EXISTS Kelurahan;
DROP TABLE IF EXISTS Kecamatan;


CREATE TABLE Kecamatan (
	idKec SERIAL PRIMARY KEY,
	namaKec varchar(20) NOT NULL
);

CREATE TABLE Kelurahan (
	idKel SERIAL PRIMARY KEY,
	namaKel varchar(50) NOT NULL,
	idKec int REFERENCES Kecamatan(idKec)
);

CREATE TABLE Pengguna
(
	idPengguna SERIAL PRIMARY KEY,
	nama varchar(30),
	username varchar(30)
);

CREATE TABLE IbuBS
(
	idPengguna int NOT NULL,
	password varchar(10),
	PRIMARY KEY (idPengguna),
	FOREIGN KEY (idPengguna) REFERENCES Pengguna(idPengguna)
);

CREATE TABLE Member
(
	idPengguna int NOT NULL,
	noHP varchar(20),
	alamat varchar(50),
	email varchar(30),
	idKel int NOT NULL,
	PRIMARY KEY (idPengguna),
	FOREIGN KEY (idPengguna) REFERENCES Pengguna(idPengguna),
	FOREIGN KEY (idKel) REFERENCES Kelurahan(idKel)
);

CREATE TABLE BSPusat
(
	idBSPusat int NOT NULL PRIMARY KEY,
	noTelp char(12) NOT NULL,
	alamat varchar(50) NOT NULL,
	idKel int REFERENCES Kelurahan
);


CREATE TABLE Transaksi
(
	idTransaksi SERIAL PRIMARY KEY,
	tanggal date NOT NULL,
	tipeTransaksi int NOT NULL,
	idPengguna int REFERENCES Pengguna,
	idBSPusat int REFERENCES BSPusat
);

CREATE TABLE JenisSampah
(
	idJenisSampah SERIAL PRIMARY KEY,
	namaJenis varchar(20)
);

CREATE TABLE SUK
(
	idSUK SERIAL PRIMARY KEY,
	namaSUK varchar(10)
);

CREATE TABLE Sampah
(
	idSampah SERIAL PRIMARY KEY,
	namaSampah varchar(40),
	idJenisSampah int NOT NULL,
	idSUK int NOT NULL,
	FOREIGN KEY (idJenisSampah) REFERENCES JenisSampah(idJenisSampah),
	FOREIGN KEY (idSUK) REFERENCES SUK(idSUK)
);

CREATE TABLE TransaksiSampah 
(
	idTransaksi INT NOT NULL,
	idSampah INT NOT NULL,
	jumlahSampah int NOT NULL,
	hargaTotal int NOT NULL,
	PRIMARY KEY (idTransaksi, idSampah),
	FOREIGN KEY (idTransaksi) REFERENCES Transaksi(idTransaksi),
	FOREIGN KEY (idSampah) REFERENCES Sampah(idSampah)
);

CREATE TABLE Harga
(
	idSampah INT NOT NULL,
	tanggalUbah date NOT NULL,
	hargaSampah int NOT NULL,
	PRIMARY KEY (idSampah, tanggalUbah),
	FOREIGN KEY (idSampah) REFERENCES Sampah(idSampah)
);

-- Tabel lama

-- DROP TABLE IF EXISTS Harga;
-- DROP TABLE IF EXISTS TransaksiSampah;
-- DROP TABLE IF EXISTS Sampah;
-- DROP TABLE IF EXISTS SUK;
-- DROP TABLE IF EXISTS JenisSampah;
-- DROP TABLE IF EXISTS Transaksi;
-- DROP TABLE IF EXISTS Member;
-- DROP TABLE IF EXISTS IbuBS;
-- DROP TABLE IF EXISTS Pengguna;
-- DROP TABLE IF EXISTS BSPusat;
-- DROP TABLE IF EXISTS Kelurahan;
-- DROP TABLE IF EXISTS Kecamatan;


-- CREATE TABLE Kecamatan (
-- 	idKec int NOT NULL PRIMARY KEY,
-- 	namaKec varchar(20) NOT NULL
-- );

-- CREATE TABLE Kelurahan (
-- 	idKel int NOT NULL PRIMARY KEY,
-- 	namaKel varchar(50) NOT NULL,
-- 	idKec int REFERENCES Kecamatan(idKec)
-- );

-- CREATE TABLE Pengguna
-- (
-- 	idPengguna int NOT NULL PRIMARY KEY,
-- 	nama varchar(30),
-- 	username varchar(30)
-- );

-- CREATE TABLE IbuBS
-- (
-- 	idPengguna int REFERENCES Pengguna,
-- 	password varchar(10)
-- 	-- PRIMARY KEY (idPengguna)
-- );

-- CREATE TABLE Member
-- (
-- 	idPengguna int REFERENCES Pengguna,
-- 	noHP varchar(20),
-- 	alamat varchar(50),
-- 	email varchar(30),
-- 	idKel int REFERENCES Kelurahan
-- 	-- PRIMARY KEY (idPengguna)
-- );

-- CREATE TABLE BSPusat
-- (
-- 	idBSPusat int NOT NULL PRIMARY KEY,
-- 	noTelp char(12) NOT NULL,
-- 	alamat varchar(50) NOT NULL,
-- 	idKel int REFERENCES Kelurahan
-- );


-- CREATE TABLE Transaksi
-- (
-- 	idTransaksi int NOT NULL PRIMARY KEY,
-- 	tanggal date NOT NULL,
-- 	tipeTransaksi int NOT NULL,
-- 	idPengguna int REFERENCES Pengguna,
-- 	idBSPusat int REFERENCES BSPusat
-- );

-- CREATE TABLE JenisSampah
-- (
-- 	idJenisSampah int NOT NULL PRIMARY KEY,
-- 	namaJenis varchar(20)
-- );

-- CREATE TABLE SUK
-- (
-- 	idSUK int NOT NULL PRIMARY KEY,
-- 	namaSUK varchar(10)
-- );

-- CREATE TABLE Sampah
-- (
-- 	idSampah int NOT NULL PRIMARY KEY,
-- 	namaSampah varchar(40),
-- 	idJenisSampah int REFERENCES JenisSampah,
-- 	idSUK int REFERENCES SUK
-- );

-- CREATE TABLE TransaksiSampah 
-- (
-- 	idTransaksi INT REFERENCES Transaksi,
-- 	idSampah INT REFERENCES Sampah,
-- 	jumlahSampah int NOT NULL,
-- 	hargaTotal int NOT NULL
-- 	-- PRIMARY KEY (idTransaksi, idSampah)
-- );

-- CREATE TABLE Harga
-- (
-- 	idSampah INT REFERENCES Sampah,
-- 	tanggalUbah date NOT NULL,
-- 	hargaSampah int NOT NULL
-- 	-- PRIMARY KEY (idSampah, tanggalUbah)
-- );

