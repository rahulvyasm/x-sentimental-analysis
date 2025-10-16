"""
Unit tests for text cleaning functionality
"""

import pytest
from processing.normalization.text_cleaner import TextCleaner


class TestTextCleaner:
    """Test suite for TextCleaner class"""
    
    def setup_method(self):
        """Setup test fixtures"""
        self.cleaner = TextCleaner()
    
    def test_remove_urls(self):
        """Test URL removal"""
        text = "Check this out https://example.com cool stuff"
        expected = "Check this out  cool stuff"
        assert self.cleaner.remove_urls(text) == expected
    
    def test_remove_mentions(self):
        """Test @mention removal"""
        text = "Hey @user1 and @user2 how are you?"
        expected = "Hey  and  how are you?"
        assert self.cleaner.remove_mentions(text) == expected
    
    def test_remove_hashtags(self):
        """Test hashtag symbol removal"""
        text = "This is #awesome and #cool"
        expected = "This is awesome and cool"
        assert self.cleaner.remove_hashtags(text) == expected
    
    def test_remove_special_chars(self):
        """Test special character removal"""
        text = "Hello! This is great... $$$"
        expected = "Hello This is great "
        assert self.cleaner.remove_special_chars(text) == expected


# TODO: Add integration tests with actual Spark DataFrames

