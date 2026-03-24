import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import timedelta
import razorpay

from flask_mail import Mail, Message
import random
import datetime

app = Flask(__name__)
CORS(app)



# ================= EMAIL CONFIG =================

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = "chjithu23@gmail.com"
app.config['MAIL_PASSWORD'] = "clqnofuyhkdfpges"   # your app password
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False

mail = Mail(app)

# ================= OTP STORAGE =================
otp_storage = {}

# ================= ROOT ROUTE =================
@app.route("/")
def home():
    return "Backend Running Successfully!"



# ================= SEND OTP =================

@app.route("/send_otp", methods=["POST"])
def send_otp():

    data = request.json
    email = data.get("email")

    otp = str(random.randint(1000, 9999))

    otp_storage[email] = otp

    print(f"OTP for {email} is {otp}")
    print("OTP STORE:", otp_storage)

    try:
        msg = Message(
            subject="Your OTP Code",
            sender=app.config["MAIL_USERNAME"],
            recipients=[email]
        )

        msg.body = f"Your OTP is: {otp}"

        mail.send(msg)

        return jsonify({"message": "OTP sent successfully"}), 200

    except Exception as e:
        print("EMAIL ERROR:", e)
        return jsonify({"error": "Failed to send OTP"}), 500

    # ================= VERIFY OTP =================
@app.route("/verify_otp", methods=["POST"])
def verify_otp():

    data = request.json

    email = data.get("email")
    otp = str(data.get("otp")).strip()

    print("VERIFY EMAIL:", email)
    print("ENTERED OTP:", otp)
    print("OTP STORAGE:", otp_storage)

    if not email:
        return jsonify({"message": "Email missing"}), 400

    email = email.strip().lower()

    if email in otp_storage and otp_storage[email] == otp:
        del otp_storage[email]
        return jsonify({"message": "OTP verified"}), 200
    else:
        return jsonify({"message": "Invalid OTP"}), 400
# ================= DATABASE CONFIG =================
db_config = {
    "host": os.getenv("DB_HOST", "localhost"),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "flask_db"),
    "port": int(os.getenv("DB_PORT", 3306))
}

def get_connection():
    return mysql.connector.connect(**db_config)

# ================= RAZORPAY CONFIG =================
razorpay_client = razorpay.Client(
    auth=("rzp_test_SNrDZRnmpJrON9", "qPZSZUiizwhRHJFh0W42PaQ7")
)

# ================= REGISTER =================
@app.route('/register', methods=['POST'])
def register():

    data = request.get_json()

    name = data.get("name")
    email = data.get("email")
    phone = data.get("phone")
    grade_level = data.get("grade_level")
    password = data.get("password")
    role = data.get("role")

    if not email or not password or not role:
        return jsonify({"message": "Missing fields"}), 400

    hashed_password = generate_password_hash(password)

    conn = get_connection()
    cursor = conn.cursor()

    try:

        cursor.execute("SELECT id FROM users WHERE email=%s", (email,))
        user_exists = cursor.fetchone()
        if user_exists:
            return jsonify({"message": "User already exists"}), 400

        cursor.execute("""
            INSERT INTO users
            (name,email,phone,grade_level,password,role)
            VALUES (%s,%s,%s,%s,%s,%s)
        """,(name,email,phone,grade_level,hashed_password,role))

        conn.commit()

        return jsonify({"message":"User registered successfully"}),200

    except Exception as e:
        return jsonify({"error":str(e)}),500

    finally:
        cursor.close()
        conn.close()

# ================= LOGIN =================
@app.route('/login', methods=['POST'])
def login():
    print("=== LOGIN REQUEST RECEIVED ===")
    data = request.get_json()

    if not data:
        return jsonify({"message": "Request body missing"}), 400

    email = data.get("email", "").strip().lower()
    password = data.get("password")
    print(f"LOGIN ATTEMPT: Email='{email}'")

    if not email or not password:
        return jsonify({"message": "Email and password required"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({"message": "Email not registered"}), 404

        if not check_password_hash(user["password"], password):
            return jsonify({"message": "Incorrect password"}), 401

        return jsonify({
            "message": "Login successful",
            "user_id": user["id"],
            "email": user["email"],
            "role": user["role"]
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

# ================= CREATE COURSE =================
@app.route('/create_course', methods=['POST'])
def create_course():

    data = request.get_json()

    conn = get_connection()
    cursor = conn.cursor()

    try:

        tutor_id = data.get("user_id")

        # Check if tutor has added bank details
        cursor.execute(
            "SELECT id FROM tutor_bank_details WHERE tutor_id = %s",
            (tutor_id,)
        )
        bank_details = cursor.fetchone()

        if not bank_details:
            return jsonify({
                "error": "Bank details required before creating a course. Please complete your payout verification."
            }), 403

        # Insert course
        cursor.execute("""
            INSERT INTO courses
            (user_id, title, subject, start_date, start_time,
             duration_minutes, meeting_url,
             class_type, frequency, price,
             curriculum, professor_message, tutor_email)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            data.get("user_id"),
            data.get("title"),
            data.get("subject"),
            data.get("date"),
            data.get("time"),
            data.get("duration"),
            data.get("meeting_url"),
            data.get("class_type"),
            data.get("frequency"),
            data.get("price"),
            data.get("curriculum"),
            data.get("professor_message"),
            data.get("tutor_email")
        ))

        # Save tutor subject
        tutor_id = data.get("user_id")
        subject = data.get("subject")

        cursor.execute("""
            INSERT INTO tutor_subjects (tutor_id, subject)
            VALUES (%s,%s)
        """, (tutor_id, subject))

        conn.commit()

        return jsonify({
            "message": "Course deployed successfully",
            "course_id": cursor.lastrowid
        }), 200

    except Exception as e:

        return jsonify({
            "error": str(e)
        }), 500

    finally:

        cursor.close()
        conn.close()
        

# ================= GET ALL COURSES =================
@app.route('/get_all_courses', methods=['GET'])
def get_all_courses():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT 
                *,
                (SELECT COUNT(*) FROM enrollments WHERE enrollments.course_id = courses.id) AS enrolled_count
            FROM courses
        """)
        courses = cursor.fetchall()

        for course in courses:
            for key, value in course.items():
                if isinstance(value, timedelta):
                    course[key] = str(value)

        return jsonify({"courses": courses}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

# ================= DELETE COURSE =================
@app.route('/delete_course/<int:course_id>', methods=['DELETE'])
def delete_course(course_id):

    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("DELETE FROM courses WHERE id=%s", (course_id,))
        conn.commit()

        return jsonify({"message": "Course deleted successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

# ================= EDIT COURSE =================
@app.route('/edit_course', methods=['PUT'])
def edit_course():

    data = request.get_json()

    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            UPDATE courses
            SET title=%s, subject=%s, start_date=%s, start_time=%s,
                duration_minutes=%s, meeting_url=%s, class_type=%s,
                frequency=%s, price=%s, curriculum=%s, professor_message=%s
            WHERE id=%s
        """, (
            data.get("title"),
            data.get("subject"),
            data.get("start_date"),
            data.get("start_time"),
            data.get("duration_minutes"),
            data.get("meeting_url"),
            data.get("class_type"),
            data.get("frequency"),
            data.get("price"),
            data.get("curriculum"),
            data.get("professor_message"),
            data.get("id")
        ))

        conn.commit()

        return jsonify({"message": "Course updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

# ================= CREATE PAYMENT ORDER =================
@app.route('/create_payment_order', methods=['POST'])
def create_payment_order():

    data = request.get_json()
    amount = int(data.get("amount"))

    try:
        order = razorpay_client.order.create({
            "amount": amount * 100,
            "currency": "INR",
            "payment_capture": 1
        })

        return jsonify({
            "order_id": order["id"],
            "amount": amount,
            "student_id": data.get("student_id"),
            "course_id": data.get("course_id")
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ================= VERIFY PAYMENT =================
@app.route('/verify_payment', methods=['POST'])
def verify_payment():

    data = request.get_json()

    try:
        student_id = int(data.get("student_id"))
        course_id = int(data.get("course_id"))
    except:
        return jsonify({"error": "Invalid student_id or course_id"}), 400

    print("=== VERIFY PAYMENT CALLED ===")
    print("student_id:", student_id)
    print("course_id:", course_id)

    conn = get_connection()
    cursor = conn.cursor(buffered=True)

    try:

        # Get course tutor and price
        cursor.execute(
            "SELECT user_id, price FROM courses WHERE id = %s",
            (course_id,)
        )

        course = cursor.fetchone()

        if not course:
            return jsonify({"error": "Course not found"}), 404

        tutor_id = course[0]
        amount = float(course[1])

        print("tutor_id:", tutor_id)
        print("course price:", amount)

        # Check enrollment exists
        cursor.execute(
            "SELECT id FROM enrollments WHERE student_id=%s AND course_id=%s",
            (student_id, course_id)
        )

        enrollment = cursor.fetchone()

        if not enrollment:
            return jsonify({"error": "Enrollment not found"}), 404

        # Update enrollment payment status
        cursor.execute("""
            UPDATE enrollments
            SET payment_status = 'PAID',
                tutor_id = %s
            WHERE student_id = %s AND course_id = %s
        """, (tutor_id, student_id, course_id))


        # Prevent duplicate earnings
        cursor.execute("""
            SELECT id FROM tutor_earnings
            WHERE student_id=%s AND course_id=%s
        """, (student_id, course_id))

        existing = cursor.fetchone()

        if existing:
            conn.commit()  # Commit the enrollment UPDATE
            return jsonify({
                "message": "Payment already verified"
            }), 200


        # Insert tutor earnings
        platform_fee = 0
        tutor_earning = amount

        cursor.execute("""
            INSERT INTO tutor_earnings
            (tutor_id, course_id, student_id, amount, platform_fee, tutor_earning)
            VALUES (%s,%s,%s,%s,%s,%s)
        """, (
            tutor_id,
            course_id,
            student_id,
            amount,
            platform_fee,
            tutor_earning
        ))

        conn.commit()

        print("Payment verified successfully")

        return jsonify({
            "message": "Payment verified successfully",
            "course_id": course_id,
            "amount": amount
        }), 200


    except Exception as e:
        print("ERROR:", str(e))
        conn.rollback()
        return jsonify({"error": str(e)}), 500


    finally:
        cursor.close()
        conn.close()
        # ================= TUTOR STUDENTS =================
@app.route('/tutor_students/<int:tutor_id>', methods=['GET'])
def tutor_students(tutor_id):

    conn = None
    cursor = None

    try:

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT 
                users.email AS student_email,
                courses.title AS course_title,
                enrollments.payment_status,
                enrollments.completion_status
            FROM enrollments
            JOIN courses ON enrollments.course_id = courses.id
            JOIN users ON enrollments.student_id = users.id
            WHERE enrollments.tutor_id = %s
        """, (tutor_id,))

        students = cursor.fetchall()

        return jsonify({"students": students}), 200

    except Exception as e:

        return jsonify({"error": str(e)}), 500

    finally:

        if cursor: cursor.close()
        if conn: conn.close()



        # ================= TUTOR EARNINGS =================
@app.route('/tutor_earnings/<int:tutor_id>', methods=['GET'])
def tutor_earnings(tutor_id):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        cursor.execute("""
        SELECT SUM(tutor_earning) AS total_earnings
        FROM tutor_earnings
        WHERE tutor_id = %s
        """, (tutor_id,))
        
        total = cursor.fetchone()

        cursor.execute("""
        SELECT course_id, student_id, amount, platform_fee, tutor_earning, created_at
        FROM tutor_earnings
        WHERE tutor_id = %s
        ORDER BY created_at DESC
        """, (tutor_id,))
        
        transactions = cursor.fetchall()

        return jsonify({
            "total_earnings": total["total_earnings"] if total["total_earnings"] else 0,
            "transactions": transactions
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


        # ================= JOIN CLASS =================
@app.route('/join_class/<int:student_id>/<int:course_id>', methods=['GET'])
def join_class(student_id, course_id):

    conn = None
    cursor = None

    try:

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        # Check if student paid for course
        cursor.execute("""
            SELECT payment_status
            FROM enrollments
            WHERE student_id=%s AND course_id=%s
        """, (student_id, course_id))

        enrollment = cursor.fetchone()

        if not enrollment:
            return jsonify({"message": "You are not enrolled in this course"}), 403

        if enrollment["payment_status"] != "PAID":
            return jsonify({"message": "Payment required to join class"}), 403

        # Get class time
        cursor.execute("""
            SELECT meeting_url, start_date, start_time
            FROM courses
            WHERE id=%s
        """, (course_id,))

        course = cursor.fetchone()

        if not course:
            return jsonify({"message": "Course not found"}), 404

        return jsonify({
            "meeting_url": course["meeting_url"],
            "start_date": str(course["start_date"]),
            "start_time": str(course["start_time"]),
            "message": "You can join the class when it starts"
        }), 200

    except Exception as e:

        return jsonify({"error": str(e)}), 500

    finally:

        if cursor: cursor.close()
        if conn: conn.close()

# ================= EXPLORE COURSES =================
@app.route('/explore_courses/<int:student_id>', methods=['GET'])
def explore_courses(student_id):

    conn = None
    cursor = None

    try:

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT 
                courses.*,
                users.name AS tutor_name,
                (SELECT COUNT(*) FROM enrollments WHERE enrollments.course_id = courses.id) AS enrolled_count
            FROM courses
            JOIN users ON courses.user_id = users.id
            WHERE courses.id NOT IN (
                SELECT course_id 
                FROM enrollments 
                WHERE student_id = %s
            )
        """, (student_id,))

        courses = cursor.fetchall()

        for course in courses:
            for key, value in course.items():
                if isinstance(value, timedelta):
                    course[key] = str(value)
            
            if course.get("start_time"):
                course["start_time"] = str(course["start_time"])

            if course.get("start_date"):
                course["start_date"] = str(course["start_date"])

        return jsonify({"courses": courses}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# ================= avaliable  COURSES =================

@app.route('/available_courses/<int:student_id>', methods=['GET'])
def available_courses(student_id):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        cursor.execute("""
        SELECT 
            courses.*,
            users.name AS tutor_name,
            (SELECT COUNT(*) FROM enrollments WHERE enrollments.course_id = courses.id) AS enrolled_count
        FROM enrollments
        JOIN courses ON enrollments.course_id = courses.id
        JOIN users ON courses.user_id = users.id
        WHERE enrollments.student_id = %s
        """, (student_id,))

        courses = cursor.fetchall()

        # Convert non-JSON fields
        for course in courses:
            for key, value in course.items():
                if isinstance(value, timedelta):
                    course[key] = str(value)
            
            if course.get("start_time"):
                course["start_time"] = str(course["start_time"])

            if course.get("start_date"):
                course["start_date"] = str(course["start_date"])

        return jsonify({"courses": courses})

    except Exception as e:
        return jsonify({"error": str(e)})

    finally:
        cursor.close()
        conn.close()


   # ================= COURSE history =================


@app.route('/course_history/<int:student_id>', methods=['GET'])
def course_history(student_id):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        cursor.execute("""
        SELECT 
            courses.id,
            courses.title,
            courses.subject,
            courses.start_date,
            courses.start_time,
            courses.duration_minutes,
            users.name AS tutor_name,
            (SELECT COUNT(*) FROM enrollments WHERE enrollments.course_id = courses.id) AS enrolled_count
        FROM enrollments
        JOIN courses ON enrollments.course_id = courses.id
        JOIN users ON courses.user_id = users.id
        WHERE enrollments.student_id = %s
        """, (student_id,))

        courses = cursor.fetchall()

        # convert non JSON fields
        for course in courses:
            course["start_date"] = str(course["start_date"])
            course["start_time"] = str(course["start_time"])
            course["duration_minutes"] = str(course["duration_minutes"])

        return jsonify({"history": courses})

    except Exception as e:
        return jsonify({"error": str(e)})

    finally:
        cursor.close()
        conn.close()

   # ================= add bank details =================


@app.route('/add_bank_details', methods=['POST'])
def add_bank_details():

    data = request.get_json()

    tutor_id = data.get("tutor_id")
    account_holder_name = data.get("account_holder_name")
    bank_name = data.get("bank_name")
    account_number = data.get("account_number")
    ifsc_code = data.get("ifsc_code")
    upi_id = data.get("upi_id")

    if not tutor_id:
        return jsonify({"error": "tutor_id is required"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        # Check if tutor already added bank details
        cursor.execute(
            "SELECT id FROM tutor_bank_details WHERE tutor_id = %s",
            (tutor_id,)
        )

        existing = cursor.fetchone()

        if existing:
            return jsonify({"message": "Bank details already exist for this tutor"}), 400

        cursor.execute("""
            INSERT INTO tutor_bank_details
            (tutor_id, account_holder_name, bank_name, account_number, ifsc_code, upi_id)
            VALUES (%s,%s,%s,%s,%s,%s)
        """, (
            tutor_id,
            account_holder_name,
            bank_name,
            account_number,
            ifsc_code,
            upi_id
        ))

        conn.commit()

        return jsonify({
            "message": "Bank details saved successfully"
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


   # ================= get bank details =================


@app.route('/get_bank_details/<int:tutor_id>', methods=['GET'])
def get_bank_details(tutor_id):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
        SELECT account_holder_name, account_number, ifsc_code, pan_number
        FROM tutor_bank_details
        WHERE tutor_id = %s
        """

        cursor.execute(query, (tutor_id,))
        details = cursor.fetchone()

        if details:
            return jsonify(details), 200
        else:
            return jsonify({"message": "No bank details found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

   # ================= update bank details =================



@app.route('/update_bank_details', methods=['PUT'])
def update_bank_details():

    data = request.get_json()

    tutor_id = data.get("tutor_id")
    account_holder_name = data.get("account_holder_name")
    account_number = data.get("account_number")
    ifsc_code = data.get("ifsc_code")
    pan_number = data.get("pan_number")

    conn = get_connection()
    cursor = conn.cursor()

    try:

        cursor.execute("""
        UPDATE tutor_bank_details
        SET account_holder_name=%s,
            account_number=%s,
            ifsc_code=%s,
            pan_number=%s
        WHERE tutor_id=%s
        """, (
            account_holder_name,
            account_number,
            ifsc_code,
            pan_number,
            tutor_id
        ))

        conn.commit()

        return jsonify({"message": "Bank details updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()



# ================= enroll student =================


@app.route('/enroll_student', methods=['POST'])
def enroll_student():

    data = request.json

    student_id = data.get("student_id")
    course_id = data.get("course_id")

    if not student_id or not course_id:
        return jsonify({"error": "student_id and course_id are required"}), 400

    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(buffered=True)

    try:
        # Check if enrollment already exists
        cursor.execute("""
            SELECT id FROM enrollments WHERE student_id = %s AND course_id = %s
        """, (student_id, course_id))

        existing = cursor.fetchone()
        if existing:
            return jsonify({"message": "Already enrolled", "enrollment_id": existing[0]}), 200

        cursor.execute("""
            INSERT INTO enrollments (student_id, course_id)
            VALUES (%s,%s)
        """, (student_id, course_id))

        conn.commit()

        enrollment_id = cursor.lastrowid
        return jsonify({"message": "Student enrolled successfully", "enrollment_id": enrollment_id}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

 


 # ================= GET TUTOR COURSES =================

@app.route('/get_tutor_courses/<string:tutor_email>', methods=['GET'])
def get_tutor_courses(tutor_email):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        cursor.execute("""
            SELECT *
            FROM courses
            WHERE tutor_email = %s
            ORDER BY id DESC
        """, (tutor_email,))

        courses = cursor.fetchall()

        # FIX timedelta / time serialization
        for course in courses:
            for key, value in course.items():
                if isinstance(value, timedelta):
                    course[key] = str(value)

        return jsonify({"courses": courses}), 200

    except Exception as e:

        return jsonify({"error": str(e)}), 500

    finally:

        cursor.close()
        conn.close()



 # ================= save bank details =================

@app.route('/save_bank_details', methods=['POST'])
def save_bank_details():

    data = request.json

    tutor_id = data.get("tutor_id")
    name = data.get("account_holder_name")
    account = data.get("account_number")
    ifsc = data.get("ifsc_code")

    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE tutor_bank_details
        SET account_holder_name=%s,
            account_number=%s,
            ifsc_code=%s
        WHERE tutor_id=%s
    """, (name, account, ifsc, tutor_id))

    conn.commit()

    return jsonify({"message": "Bank details updated"})



# ================= RUN SERVER =================
if __name__ == "__main__":
   app.run(host="0.0.0.0", port=5050, debug=False)