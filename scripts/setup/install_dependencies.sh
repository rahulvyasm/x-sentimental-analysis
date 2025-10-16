#!/bin/bash
# Install Python dependencies for Twitter Sentiment Analysis Pipeline

echo "==================================="
echo "Installing Python Dependencies"
echo "==================================="

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Download NLTK data
echo "Downloading NLTK VADER lexicon..."
python3 -c "import nltk; nltk.download('vader_lexicon', quiet=True); print('VADER lexicon downloaded successfully')"

echo "==================================="
echo "Dependencies installed successfully!"
echo "==================================="
echo ""
echo "To activate the virtual environment, run:"
echo "source .venv/bin/activate"

