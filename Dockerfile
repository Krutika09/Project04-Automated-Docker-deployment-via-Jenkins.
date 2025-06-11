# 1. Use base image
FROM python:3.10-slim

# 2. Set working directory
WORKDIR /app

# 3. Copy files
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# 4. Expose app port
EXPOSE 5000

# 5. Command to run the app
CMD ["python", "app.py"]
