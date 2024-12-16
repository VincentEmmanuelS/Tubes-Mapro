from flask import Flask, render_template, request, redirect, url_for, flash, session
import psycopg2

app = Flask(__name__)
app.secret_key = "secret_key_12345"

DB_CONFIG = {
    'host': 'localhost',
    'database': 'Manpro',
    'user': 'postgres',
    'password': 'postgres',
}


# Admin
def validasiLoginAdmin(username, password):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        query = "select idpengguna from pengguna where username = %s"
        cursor.execute(query, (username,))

        idUser = cursor.fetchone()

        if idUser is None:
            cursor.close()
            conn.close()
            return False

        query = "select password from ibubs where idpengguna = %s"
        cursor.execute(query, (idUser[0],))

        passwordDb = cursor.fetchone()
        passwordDb = passwordDb[0]

        if password != passwordDb:
            cursor.close()
            conn.close()
            return False
        else:
            cursor.close()
            conn.close()
            return True

    except Exception as e:
        print(f"Database error: {e}")
        return False

@app.route("/admin", methods=["GET", "POST"])
def adminView():
    if "username" in session:
        return redirect(url_for("dashboardAdminView"))

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        
        if validasiLoginAdmin(username, password):
            session['username'] = username
            return redirect(url_for("dashboardAdminView"))
        else:
            flash("Invalid username or password. Please try again.")
            return render_template("LoginAdmin.html")
        
    return render_template("LoginAdmin.html")

@app.route("/admin/dashboard")
def dashboardAdminView():
    if "username" not in session:
        return redirect(url_for("adminView"))
    
    return render_template("BuBS.html")

@app.route("/admin/logout")
def logoutAdmin():
    session.clear()
    return redirect(url_for("adminView"))



# Member
def validasiLoginMember(username):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        query = "select idpengguna from pengguna where username = %s"
        cursor.execute(query, (username,))

        idUser = cursor.fetchone()

        if idUser is None:
            cursor.close()
            conn.close()
            return False
        else:
            cursor.close()
            conn.close()
            return idUser[0]

    except Exception as e:
        print(f"Database error: {e}")
        return False

@app.route("/member", methods=["GET", "POST"])
def memberView():
    if "username" in session:
        return redirect(url_for("dashboardMemberView"))

    if request.method == "POST":
        username = request.form["username"]

        idUser = validasiLoginMember(username)
        if idUser is not None:
            session['username'] = username
            session['id'] = idUser
            return redirect(url_for("dashboardMemberView"))
        else:
            flash("Invalid username. Please try again.")
            return render_template("LoginMember.html")
        
    return render_template("LoginMember.html")

@app.route("/member/dashboard")
def dashboardMemberView():
    if "username" not in session:
        return redirect(url_for("memberView"))
    
    return render_template("Member.html")

@app.route("/member/logout")
def logoutMember():
    session.clear()
    return redirect(url_for("memberView"))

@app.route("/member/hargaSampah")
def lihatHarga():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # Query to fetch data for the table
        query = """
                    select distinct on (sampah.namasampah) 
                        sampah.namasampah, 
                        harga.hargasampah, 
                        harga.tanggalubah,
                        jenissampah.namajenis, 
                        suk.namasuk
                    from 
                        sampah
                        inner join harga on sampah.idsampah = harga.idsampah
                        inner join jenissampah on sampah.idjenissampah = jenissampah.idjenissampah
                        inner join suk on sampah.idsuk = suk.idsuk
                    order by sampah.namasampah, harga.tanggalubah desc;
                """
        cursor.execute(query)
        results = cursor.fetchall()

        cursor.close()
        conn.close()

        # Render the table with the query results
        return render_template('lihatHarga.html', data=results)

    except Exception as e:
        print(f"Database error: {e}")
        return "Error fetching data from the database."
    
@app.route("/member/historyTransaksi")
def lihatHistory():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # Query to fetch data for the table
        query = """
                    select 
                        transaksi.tanggal,
                        sampah.namasampah,
                        transaksisampah.jumlahsampah,
                        suk.namasuk,
                        transaksisampah.hargatotal
                    from 
                        transaksi 
                        inner join transaksisampah on transaksi.idtransaksi = transaksisampah.idtransaksi
                        inner join sampah on transaksisampah.idsampah = sampah.idsampah
                        inner join suk on sampah.idsuk = suk.idsuk
                    where idpengguna = %s
                """
        idPengguna = session.get('id')
        print(idPengguna)

        cursor.execute(query, (idPengguna,))
        transactions = cursor.fetchall()

        cursor.close()
        conn.close()

        # Render the table with the query results
        return render_template('historyTransaksi.html', transactions=transactions)

    except Exception as e:
        print(f"Database error: {e}")
        return "Error fetching data from the database."
    
@app.route('/member/laporanPendapatan', methods=['GET', 'POST'])
def laporanPendapatan():
    if request.method == 'POST':
        # Get the dates from the form
        starting_date = request.form.get('startingDate')
        ending_date = request.form.get('endingDate')

        # Validate the input dates
        if not starting_date or not ending_date:
            return render_template('laporanPendapatan.html', message="Harap pilih tanggal yang valid.")

        try:
            conn = psycopg2.connect(**DB_CONFIG)
            cursor = conn.cursor()

            # Query transactions between the given dates
            query = """
            select 
                transaksi.tanggal,
                sampah.namasampah,
                transaksisampah.jumlahsampah,
                suk.namasuk,
                transaksisampah.hargatotal
            from 
                transaksi 
                inner join transaksisampah on transaksi.idtransaksi = transaksisampah.idtransaksi
                inner join sampah on transaksisampah.idsampah = sampah.idsampah
                inner join suk on sampah.idsuk = suk.idsuk
            where idpengguna = %s AND transaksi.tanggal >= %s AND transaksi.tanggal <= %s 
            """

            idPengguna = session.get('id')
            cursor.execute(query, (idPengguna, starting_date, ending_date,))
            transactions = cursor.fetchall()

            total_pendapatan = sum(transaction[4] for transaction in transactions)

            cursor.close()
            conn.close()

            if not transactions:
                return render_template(
                    'laporanPendapatan.html',
                    message="Tidak ada transaksi dalam rentang tanggal yang dipilih."
                )

            return render_template('laporanPendapatan.html', transactions=transactions, total_pendapatan=total_pendapatan)

        except Exception as e:
            print(f"Database error: {e}")
            return render_template(
                'laporan_pendapatan.html',
                message="Terjadi kesalahan saat mengambil data. Silakan coba lagi."
            )
    else:
        return render_template('laporanPendapatan.html')

if __name__ == "__main__":
    app.run(debug=True)
