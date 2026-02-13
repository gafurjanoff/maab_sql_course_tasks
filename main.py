import pyodbc
connstring = """
    DRIVER={ODBC Driver 18 for SQL Server};
    SERVER=localhost,1433;
    DATABASE=master;
    UID=sa;
    PWD=Samandar@77;
    TrustServerCertificate=yes;
"""
conn = pyodbc.connect(connstring)


cursor = conn.cursor()


cursor.execute("SELECT image_data FROM photos WHERE  photo_id = 1")
row = cursor.fetchone()

image_bytes = row[0]

with open("retrieved_photo.jpg", "wb") as f:
    f.write(image_bytes)

print("Image saved as retrieved_photo.jpg")

cursor.close()
conn.close()
