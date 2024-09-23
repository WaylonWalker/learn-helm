# temperature_fetcher.py
import datetime
import os
import requests
import sqlite3

print("hey im running")

city = os.getenv("CITY")
api_key = os.getenv("API_KEY")
mount_path = os.getenv("MOUNT_PATH", "/data")

try:
    response = requests.get(
        f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=imperial"
    )
    response.raise_for_status()
    temp = response.json()["main"]["temp"]

    db_path = f"{mount_path}/temperature.db"
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(
        "CREATE TABLE IF NOT EXISTS temperatures (timestamp TEXT, temperature REAL)"
    )
    c.execute(
        "INSERT INTO temperatures VALUES (?, ?)",
        (datetime.datetime.now().isoformat(), temp),
    )
    conn.commit()
    conn.close()
    print(
        f"Successfully stored temperature {temp}°C for {city} at {datetime.datetime.now()}"
    )
except Exception as e:
    print(f"An error occurred: {e}")
