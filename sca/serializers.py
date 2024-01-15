from rest_framework import serializers
from sca.models import Result, Vulnerability

class VulnerabilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Vulnerability
        fields = '__all__'

class ResultSerializer(serializers.ModelSerializer):
    vulnerabilities = VulnerabilitySerializer(many=True)
    
    class Meta:
        model = Result  
        fields = '__all__'
        depth = 1 # Depth for nested fields to deserialize