from django.urls import path
from .views import index, login_view, logout_view, admin_dashboard, paciente_dashboard, doctor_dashboard
from mi_app import views
#from .views import CustomLoginView, CustomLogoutView


urlpatterns = [
    path("", index, name="index"),
    #path('login/', CustomLoginView.as_view(), name='login'),
    #path('logout/', CustomLogoutView.as_view(), name='logout'),
    
    path("login/",login_view, name="login"),
    path("logout/", logout_view, name="logout"),
    path("admin_dashboard/", admin_dashboard, name="admin_dashboard"),
    path("paciente_dashboard/", paciente_dashboard, name="paciente_dashboard"),
    path("doctor_dashboard/", doctor_dashboard, name="doctor_dashboard"),
]