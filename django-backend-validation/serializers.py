from rest_framework import serializers
from .models import StudentOnboardingRecord

class StudentOnboardingSerializer(serializers.ModelSerializer):
    submission_identifier = serializers.CharField(min_length=16, max_length=64)
    student_legal_name = serializers.CharField(min_length=2, max_length=255)

    class Meta:
        model = StudentOnboardingRecord
        fields = [
            'submission_identifier', 
            'student_legal_name', 
            'has_learning_difficulty', 
            'requires_learning_support_assistant_matching'
        ]

    def validate(self, data):
        learning_difficulty_detected = data.get('has_learning_difficulty', False)
        if learning_difficulty_detected is True:
            data['requires_learning_support_assistant_matching'] = True
        else:
            data['requires_learning_support_assistant_matching'] = False
        return data
