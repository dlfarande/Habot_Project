from rest_framework import serializers

# Fixed violation: Replaced relative dot shorthand with an absolute full-form module path
from django_backend_validation.models import StudentOnboardingRecord


class StudentOnboardingSerializer(serializers.ModelSerializer):
    submission_identifier = serializers.CharField(min_length=16, max_length=64)
    student_legal_name = serializers.CharField(min_length=2, max_length=255)
    # Fixed violation: Added required missing analytical timestamp field to perfectly align with BigQuery
    submission_timestamp = serializers.DateTimeField()

    class Meta:
        model = StudentOnboardingRecord
        fields = [
            "submission_identifier",
            "student_legal_name",
            "has_learning_difficulty",
            "requires_learning_support_assistant_matching",
            "submission_timestamp",
        ]

    def validate(self, data):
        # Binary Logic (DCYN Library Strategy) leaves zero room for manual employee judgment
        learning_difficulty_detected = data.get("has_learning_difficulty", False)
        if learning_difficulty_detected is True:
            data["requires_learning_support_assistant_matching"] = True
        else:
            data["requires_learning_support_assistant_matching"] = False
        return data
