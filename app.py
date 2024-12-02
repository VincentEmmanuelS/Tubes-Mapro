from flask import Flask, render_template
import psycopg2

app = Flask(__name__)

# Database connection settings
DB_CONFIG = {
    'host': 'localhost',          # Replace with your database host
    'database': 'Manpro',  # Replace with your database name
    'user': 'postgres',      # Replace with your PostgreSQL username
    'password': 'postgres',  # Replace with your PostgreSQL password
}

def get_query_results(query):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # Execute your SQL query
        cursor.execute(query)  # Replace with your query

        # Fetch all results
        results = cursor.fetchall()

        # Close the connection
        cursor.close()
        conn.close()
        
        return results
    except Exception as e:
        print(f"Error: {e}")
        return []

query = "SELECT * FROM ibubs"

queryDict = {
    "login" : "SELECT username FROM Pengguna INNER JOIN Member ON Pengguna.idPengguna = Member.idPengguna WHERE Pengguna.username = 'Joko'",
    "daftarHB" : "SELECT namaSampah, hargaSampah FROM Sampah INNER JOIN ( SELECT idSampah, MAX (tanggalUbah) as updateTerbaru FROM Harga GROUP BY idSampah ) AS Latest ON Sampah.idSampah = Latest.idSampah INNER JOIN Harga ON Sampah.idSampah = Harga.idSampah WHERE Harga.tanggalUbah = Latest.updateTerbaru",
    "historiSetor" : "SELECT Transaksi.tanggal, Sampah.namaSampah, TransaksiSampah.jumlahSampah, TransaksiSampah.hargaTotal FROM Member INNER JOIN Transaksi ON Member.idPengguna = Transaksi.idPengguna INNER JOIN  TransaksiSampah ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi INNER JOIN Sampah ON TransaksiSampah.idSampah = Sampah.idSampah WHERE Member.idPengguna = (SELECT idPengguna FROM Pengguna WHERE username = 'Joko') AND tipeTransaksi = 1 ORDER BY tanggal",
    "hasilSetorSemua" : "SELECT tanggal, SUM (hargaTotal) AS total_pendapatan FROM Transaksi INNER JOIN TransaksiSampah ON Transaksi.idTransaksi = TransaksiSampah.idTransaksi INNER JOIN (SELECT idPengguna FROM Pengguna WHERE username = 'Joko') AS PengInput ON PengInput.idPengguna = Transaksi.idPengguna WHERE tanggal >= '20240301' AND tanggal <= '20240630' AND tipeTransaksi = 1 GROUP BY tanggal",

}

# Print database results to terminal
if __name__ == "__main__":
    # Call the function and print the results
    results = get_query_results(query)
    print("Database Results:")
    for row in results:
        print(row)



# @app.route("/")
# def home():
#     query_results = get_query_results()
#     return render_template("index.html", results=query_results)

# if __name__ == "__main__":
#     app.run(debug=True)
