FROM apache/airflow:2.10.5

# Set environment variables
ENV CHROME_VERSION=134.0.6998.88

# Install dependencies
USER root
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libasound2 \
    libpango1.0-0 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libxss1 \
    libxt6 \
    libxinerama1 \
    libgtk-3-0 \
    libgbm1 \
    libxshmfence1 \
    xdg-utils \
    wget \
    unzip

# Download and install Chrome
RUN wget -O /tmp/chrome-linux64.zip https://storage.googleapis.com/chrome-for-testing/${CHROME_VERSION}/linux64/chrome-linux64.zip && \
    unzip /tmp/chrome-linux64.zip -d /opt/chrome && \
    rm /tmp/chrome-linux64.zip && \
    ln -s /opt/chrome/chrome-linux64/chrome /usr/bin/chrome

# Download and install ChromeDriver
RUN wget -O /tmp/chromedriver-linux64.zip https://storage.googleapis.com/chrome-for-testing/${CHROME_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver-linux64.zip -d /opt/chromedriver && \
    rm /tmp/chromedriver-linux64.zip && \
    ln -s /opt/chromedriver/chromedriver-linux64/chromedriver /usr/bin/chromedriver

# Switch back to airflow user
USER ${AIRFLOW_UID:-50000}

# Set working directory
WORKDIR /opt/airflow

# Copy requirements.txt into container
COPY ./requirements.txt requirements.txt

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt
