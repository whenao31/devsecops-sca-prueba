#from django.db import models
from djongo import models


class Vulnerability(models.Model):
    osv_url = models.TextField()
    cvss = models.CharField(max_length=4)
    ecosystem = models.CharField(max_length=100)
    package = models.CharField(max_length=100)
    version = models.CharField(max_length=100)
    source = models.CharField(max_length=200)

    def __str__(self):
        return self.osv_url
    
    class Meta:
        abstract = True

class Result(models.Model):
    vulnerabilities = models.ArrayField(
        model_container=Vulnerability,
    )
    execution_id = models.CharField(max_length=100, )
    git_branch = models.CharField(max_length=100)
    git_user = models.EmailField(blank=True)
    created_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.execution_id
    
    objects = models.DjongoManager()
