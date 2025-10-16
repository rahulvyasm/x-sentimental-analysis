"""
Unit tests for VADER sentiment analyzer
"""

import pytest
from processing.sentiment.vader_analyzer import VaderSentimentAnalyzer


class TestVaderAnalyzer:
    """Test suite for VaderSentimentAnalyzer"""
    
    def setup_method(self):
        """Setup test fixtures"""
        self.analyzer = VaderSentimentAnalyzer()
    
    def test_positive_sentiment(self):
        """Test positive sentiment detection"""
        text = "This is absolutely wonderful and amazing!"
        neg, neu, pos, compound = self.analyzer.get_sentiment_scores(text)
        assert compound > 0.5, "Should detect strong positive sentiment"
        assert pos > neg, "Positive score should be higher than negative"
    
    def test_negative_sentiment(self):
        """Test negative sentiment detection"""
        text = "This is terrible and horrible. I hate it!"
        neg, neu, pos, compound = self.analyzer.get_sentiment_scores(text)
        assert compound < -0.5, "Should detect strong negative sentiment"
        assert neg > pos, "Negative score should be higher than positive"
    
    def test_neutral_sentiment(self):
        """Test neutral sentiment detection"""
        text = "This is a statement about something."
        neg, neu, pos, compound = self.analyzer.get_sentiment_scores(text)
        assert -0.05 < compound < 0.05, "Should detect neutral sentiment"
    
    def test_empty_text(self):
        """Test handling of empty text"""
        neg, neu, pos, compound = self.analyzer.get_sentiment_scores("")
        assert (neg, neu, pos, compound) == (0.0, 0.0, 0.0, 0.0)


# TODO: Add integration tests with Spark DataFrames

