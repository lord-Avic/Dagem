from django.db import models
from django.contrib.auth.models import AbstractUser,Group, Permission

# Create your models here.

#Modelo De Usuarios

class CustomUser(AbstractUser):
    USER_TYPES = [
        ('admin','Administrador'),
        ('paciente','Paciente'),
        ('doctor','Doctor'),
    ]
    tipo_usuario = models.CharField(max_length=10, choices=USER_TYPES)

    groups = models.ManyToManyField(Group, related_name="customuser_groups")
    user_permissions = models.ManyToManyField(Permission, related_name="customuser_permission")
    
    def __str__(self):
        return f"{self.username} ({self.tipo_usuario})"