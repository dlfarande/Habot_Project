from django.db import models

class StudentOnboardingRecord(models.Model):
    submission_identifier = models.CharField(max_length=64, unique=True, help_text="Unique SHA256 hashed tracking index.")
    student_legal_name = models.CharField(max_length=255, help_text="Full legal name of the registering child.")
    has_learning_difficulty = models.BooleanField(default=False, help_text="System-evaluated classification.")
    requires_learning_support_assistant_matching = models.BooleanField(default=False, help_text="Automated assignment signal mapping.")
    submission_timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.student_legal_name} - Requires Assistant Matching: {self.requires_learning_support_assistant_matching}"
