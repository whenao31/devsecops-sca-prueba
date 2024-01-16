from rest_framework import viewsets, status
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.pagination import LimitOffsetPagination
from .serializers import ResultSerializer
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render, redirect
from .models import Result

# class ResulViewSet(viewsets.ModelViewSet):
#     serializer_class = ResultSerializer
#     queryset = Result.objects.all()

#     def list(self, request):
#         serializer = self.get_serializer(self.get_queryset(), many =True)
#         return Response(serializer.data)
    
#     def create(self, request):
#         data = request.data

#         if self.get_queryset().filter(execution_id=data.get('execution_id', '')).exists():
#             return Response({'detail': 'Result already exists'}, status=400)
        
#         serializer = self.get_serializer(data=data)
#         serializer.is_valid(raise_exception=True)
#         serializer.save()

#         return Response(serializer.data, status=201)

#--------------- API Views---------------

class ResultListView(ListCreateAPIView):
    authentication_classes = [SessionAuthentication, BasicAuthentication, TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    serializer_class = ResultSerializer
    queryset = Result.objects.all()
    pagination_class = LimitOffsetPagination

class ResultDetailView(RetrieveUpdateDestroyAPIView):
    authentication_classes = [SessionAuthentication, BasicAuthentication, TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    serializer_class = ResultSerializer
    queryset = Result.objects.all()

#--------------- API Views END---------------    

#--------------- Template Views---------------
    
def result_detail(request, pk):
    result = get_object_or_404(Result, pk=pk)
    context = {
        'result': result,
    }
    return render(request, 'result_detail.html', context)

def mark_as_remediated(request, pk):
    result = get_object_or_404(Result, pk=pk)
    result.is_remediated = not (result.is_remediated)
    result.save()
    return redirect(f'/results/{pk}/')