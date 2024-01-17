import json
from django.urls import reverse
from rest_framework.test import APITestCase
from .models import Result

class TestResultView(APITestCase):
    def setUp(self):
        Result = Result(execution_id='abc001',
                        git_branch='main',
                        git_user='usr1@mail.com',
                        created_at='2024-01-15T20:57:51.996000-05:00',
                        vulnerabilities=[]
                        )
        Result.save()
        self.url = reverse("results-list")
        self.data = {
            'execution_id': 'abc002',
            'git_branch': 'main',
            'git_user': 'usr2@mail.com',
            'created_at': '2024-01-15T20:58:52-05:00',
            'vulnerabilities': [],
            'updated_at': '2024-01-16T12:39:20.917000-05:00',
            'is_remediated': True
            }

    def test_post(self):
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, 201)
        self.assertEqual(json.loads(response.content), {
            'id': 2,
            'execution_id': 'abc002',
            'git_branch': 'main',
            'git_user': 'usr2@mail.com',
            'created_at': '2024-01-15T20:58:52-05:00',
            'vulnerabilities': [],
            'updated_at': '2024-01-16T12:39:20.917000-05:00',
            'is_remediated': True
            })
        self.assertEqual(Result.objects.count(), 2)

    def test_get_list(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(json.loads(response.content)), 1)

    def test_get(self):
        response = self.client.get(self.url + '1/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(json.loads(response.content), {
            'id': 1,
            'execution_id': 'abc001',
            'git_branch': 'main',
            'git_user': 'usr1@mail.com',
            'created_at': '2024-01-15T20:58:52-05:00',
            'vulnerabilities': [],
            'updated_at': '2024-01-16T12:39:20.917000-05:00',
            'is_remediated': False
            })
