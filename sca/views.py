from rest_framework import viewsets, status
from rest_framework.response import Response
from .serializers import ResultSerializer
from .models import Result

class ResulViewSet(viewsets.ModelViewSet):
    serializer_class = ResultSerializer
    queryset = Result.objects.all()

    def list(self, request):
        serializer = self.get_serializer(self.get_queryset(), many =True)
        print(serializer.data)
        return Response(serializer.data)
    
    def create(self, request):
        data = request.data

        if self.get_queryset().filter(execution_id=data.get('execution_id', '')).exists():
            return Response({'detail': 'Result already exists'}, status=400)
        
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data, status=201)
