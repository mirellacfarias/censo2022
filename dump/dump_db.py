import os
import subprocess
from datetime import datetime

dump_dir = '/app/dumps'
timestamp = datetime.now().strftime('%d%m%Y%H%M%S')
dump_file = os.path.join(dump_dir, f'mydatabase_{timestamp}.sql')

command = [
        "pg_dump",
        "-U", "myuser",
        "-h", "db",
        # "-F", "c",
        # "-b",
        "-v",
        "-f", dump_file,
        "mydatabase"
    ]

try:
    subprocess.run(command, check=True, env={**os.environ, "PGPASSWORD": "mypassword"})
    print(f"Dump saved to {dump_file}")
except subprocess.CalledProcessError as e:
    print(f"Error during dump: {e}")
