-- 1. Membuat stored procedure yang menampilkan seluruh data
DELIMITER $$
CREATE PROCEDURE GetAllData ()
BEGIN
	SELECT * FROM studentsperformance;
END $$
DELIMITER ;

-- Memanggil stored procedure
CALL GETALLData();

-- 2. Membuat stored procedure yang menampilkan data untuk grup ras tertentu
DELIMITER $$
CREATE PROCEDURE getDataStudents (IN grup_ras VARCHAR(50))
BEGIN
	SELECT * FROM studentsperformance WHERE grup_ras = race_or_ethnicity;
END $$
DELIMITER ;

-- Menampilkan data dengan grup ras "group B"
CALL getDataStudents("group B");

-- 3.a. Membuat stored procedure untuk memberikan nilai math rata-rata seluruh data!
DELIMITER $$
CREATE PROCEDURE getAVGMath (OUT rerata_math FLOAT)
BEGIN
	SELECT AVG(math_score) INTO rerata_math
    FROM studentsperformance;
END $$
DELIMITER ;

-- Menampilkan nilai rata-rata math dari seluruh data
CALL getAVGMath(@rerata_math);
SELECT @rerata_math;

-- 3.b. menampilkan seluruh data yang  memiliki nilai math lebih dari rata-rata menggunakan output jawaban 3.a.
SELECT * FROM studentsperformance WHERE math_score > @rerata_math;

-- 4. Membuat query yang menghasilkan rata-rata nilai matematika untuk input gender = "male"
DELIMITER $$
CREATE PROCEDURE get_gend_math_score_avg (IN get_gender VARCHAR(50), OUT mat_avg FLOAT)
BEGIN
	SELECT AVG(math_score) INTO mat_avg
    FROM studentsperformance
    WHERE gender = get_gender;
END $$
DELIMITER ;

-- Menampilkan rata-rata nilai matematikan untuk gender "male"
SET @jenis_gender = "male";
CALL get_gend_math_score_avg(@jenis_gender, @math_avg);
SELECT @jenis_gender, @math_avg;

-- 5. Membuat stored procedure dengan looping
DROP TABLE IF EXISTS id_buku;
DROP PROCEDURE IF EXISTS buatidbuku;

CREATE TABLE id_buku (id INT);

DELIMITER $$
CREATE PROCEDURE buatidbuku() 
BEGIN
	DECLARE Counter Int ;
	SET
		Counter = 0;
	WHILE Counter <= 5 DO
		INSERT INTO
			id_buku (id)
		VALUES
			(Counter);
		SET
			Counter = Counter + 1;
	END WHILE;
END $$ 
DELIMITER ;

-- Menampilkan output id buku yang telah dibuat
CALL buatidbuku();
SELECT * FROM id_buku;

-- 6. Mengitung luas segitiga dan persegi panjang
DROP PROCEDURE IF EXISTS hitung_luas;

DELIMITER $$
CREATE PROCEDURE hitung_luas(
	IN jenis_bangun_datar VARCHAR(100),
    IN x FLOAT,
    IN y FLOAT,
    OUT luas FLOAT,
    OUT keterangan VARCHAR(200)
    ) 
BEGIN
	CASE
		WHEN
			jenis_bangun_datar = "segitiga" THEN SET luas = 0.5 * x * y, keterangan = "Perhitungan berhasil!";
		WHEN
			jenis_bangun_datar = "persegi panjang" THEN SET luas = x * y, keterangan = "Perhitungan berhasil!";
		ELSE
			SET luas = NULL ; SET keterangan = "Perhitungan gagal. Bangun datar tidak didukung";
	END CASE;
END $$ 
DELIMITER ;

-- Skenario menghitung luas segitiga
SET @jenis_bangun_datar = "segitiga";
SET @x = 5;
SET @y = 7;
CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;

-- Skenario menghitung luas persegi panjang
SET @jenis_bangun_datar = "persegi panjang";
SET @x = 8;
SET @y = 19;
CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;

-- Skenario menghitung luas bangun datar yang tidak didukung
SET @jenis_bangun_datar = "trapesium";
SET @x = 2;
SET @y = 5;
CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;