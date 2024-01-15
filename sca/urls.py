from .views import *
from django.urls import path
from rest_framework import routers

router = routers.DefaultRouter()
# router.register('results/', ResulViewSet, 'results-list')

urlpatterns = [
    path('results/', ResultListView.as_view(), name='results-list'),
    path('results/<int:pk>/', ResultDetailView.as_view(), name='result-detail')
]