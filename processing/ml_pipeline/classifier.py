"""
Spark ML pipeline for supervised sentiment classification
"""

from pyspark.ml import Pipeline
from pyspark.ml.feature import Tokenizer, HashingTF, IDF
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.evaluation import MulticlassClassificationEvaluator


class SentimentClassifier:
    """
    Supervised sentiment classifier using Spark MLlib
    """
    
    def __init__(self):
        """Initialize classifier components"""
        self.pipeline = None
        self.model = None
    
    def build_pipeline(self):
        """
        Build Spark ML pipeline: Tokenizer → HashingTF → IDF → Logistic Regression
        
        Returns:
            Configured Pipeline object
        """
        # Text processing stages
        tokenizer = Tokenizer(inputCol="cleaned_text", outputCol="words")
        hashingTF = HashingTF(inputCol="words", outputCol="raw_features", numFeatures=10000)
        idf = IDF(inputCol="raw_features", outputCol="features")
        
        # Classifier
        lr = LogisticRegression(maxIter=20, regParam=0.01, labelCol="label")
        
        # Build pipeline
        self.pipeline = Pipeline(stages=[tokenizer, hashingTF, idf, lr])
        
        return self.pipeline
    
    def train(self, training_data):
        """
        Train the model on labeled data
        
        Args:
            training_data: DataFrame with 'cleaned_text' and 'label' columns
        
        Returns:
            Trained PipelineModel
        """
        if not self.pipeline:
            self.build_pipeline()
        
        self.model = self.pipeline.fit(training_data)
        return self.model
    
    def evaluate(self, test_data):
        """
        Evaluate model on test data
        
        Args:
            test_data: DataFrame with 'cleaned_text' and 'label' columns
        
        Returns:
            Dictionary of evaluation metrics
        """
        predictions = self.model.transform(test_data)
        
        # Evaluators
        evaluator_f1 = MulticlassClassificationEvaluator(
            labelCol="label", predictionCol="prediction", metricName="f1"
        )
        evaluator_accuracy = MulticlassClassificationEvaluator(
            labelCol="label", predictionCol="prediction", metricName="accuracy"
        )
        
        metrics = {
            "f1_score": evaluator_f1.evaluate(predictions),
            "accuracy": evaluator_accuracy.evaluate(predictions)
        }
        
        return metrics
    
    def save_model(self, path: str):
        """Save trained model to path"""
        if self.model:
            self.model.save(path)
    
    def load_model(self, path: str):
        """Load model from path"""
        from pyspark.ml import PipelineModel
        self.model = PipelineModel.load(path)

