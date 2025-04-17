from django.shortcuts import render, redirect
from django.contrib.auth.views import LoginView, LogoutView
from django.urls import reverse_lazy
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from .forms import LoginForm

# Create your views here.

def index(request):
    return render(request, 'mi_app/index.html')

'''
    #login
    class CustomLoginView(LoginView):
        template_name = 'mi_app/Login.html'

    #logout
    class CustomLogoutView(LogoutView):
        next_page = reverse_lazy('index')
'''

#login vistas inicio de sesion
def login_view(request):
    if request.user.is_authenticated:
        return redirect_to_role(request.user)
    
    if request.method =="POST":
        form = LoginForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect_to_role(user)
    else:
        form = LoginForm()
    
    return render(request, "mi_app/Login.html", {"form": form})

def logout_view(request):
    logout(request)
    return redirect(login)

def redirect_to_role(user):
    if user.tipo_usuario == "admin":
        return redirect("admin_dashboard")
    elif user.tipo_usuario =="paciente":
        return redirect("paciente_dashboard")
    elif user.tipo_usuario =="doctor":
        return redirect("doctor_dashboard")
    else:
        return redirect(login) #caso de error
    
#Vistas para Cada Tipo de Usuario
@login_required

def admin_dashboard(request):
    return render(request,'mi_app/admin_dashboard.html') 
#(request,'aqui esta la vista')

@login_required

def paciente_dashboard(request):
    return render(request, "mi_app/paciente_dashboard.html")

@login_required

def doctor_dashboard(request):
    return render(request, "mi_app/doctor_dashboard.html")