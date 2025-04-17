from django import forms
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import authenticate

class LoginForm(AuthenticationForm):
    username = forms.CharField(label="Usuario", max_length=150)
    password = forms.CharField(label="Contraseñas",widget=forms.PasswordInput)

    def clean(self):
        username = self.cleaned_data.get("username")
        password = self.cleaned_data.get("password")
        user = authenticate(username=username, password=password)
        if not user:
            raise forms.ValidationError("Usuario o contraseña incorrectos")
        return self.cleaned_data


    