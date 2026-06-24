FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# System packages often needed by features (PDF/plots)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnuplot texlive-latex-base texlive-latex-extra lmodern pdf2svg \
    freecad curl \
 && rm -rf /var/lib/apt/lists/*

# Make FreeCAD Python modules discoverable
ENV PYTHONPATH=/usr/lib/freecad/lib:${PYTHONPATH}

# Copy only requirements first for better caching (context is WebBackend)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . /app/

EXPOSE 8000

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
