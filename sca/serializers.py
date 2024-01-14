from rest_framework import serializers
from sca.models import Result

class VulBaseSerializer(serializers.Serializer):
    osv_url = serializers.CharField()
    cvss = serializers.CharField()
    ecosystem = serializers.CharField()
    package = serializers.CharField()
    version = serializers.CharField()
    source = serializers.CharField()

    class Meta:
        fields = ['osv_url', 'cvss', 'ecosystem', 'package', 'version', 'source']

class ResultSerializer(serializers.ModelSerializer):
    vulnerabilities = VulBaseSerializer(many=True)
    
    class Meta:
        model = Result  
        fields = '__all__'
        depth = 1 # Depth for nested fields to deserialize