from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def home(request):
    return HttpResponse(
        '''
        <html><body style="font-family:Arial;padding:40px;
        background:#0D1B3E;color:white">
        <h1 style="color:#C9A84C">Restaurant </h1>
        <p>welcome to our web page</p>
        <p> <a href="/menu" style="color:#C9A84C">Menu</a></p> 
            <p><a href="/about" style="color:#C9A84C">About Me</a></p> 
           <a href="/contacts" style="color:#C9A84C">Contact</a></p> 
         
           
        </body></html>'''
    )
    
def menu(request):
    return HttpResponse(
            '''
            <html><body style="font-family:Arial;padding:40px;
            background:#0D1B3E;color:white">
            <h1 style="color:#C9A84C">Menu</h1>
            <p>availabale dishes</p>
            
            <table styles= 'border: 1px solid black; border-collapse: collapse; padding 8px;  width: 100%;'>
            <tr>
            <th style= 'border: 1px solid black; border-collapse: collapse; padding 8px; text-align: left;
  padding: 8px;'>Dish</th>
            <th style= 'border: 1px solid black; border-collapse: collapse; padding 8px; text-align: left;
  padding: 8px;'>Amount</th>
            <tr>
            
            <tr>
              <td>soda</td>
             <td>KES 40</td>
            </tr>
             <tr>
                <td>Chapati</td>
                <td>KES 50</td>
                </tr>
             <tr>
                <td>beaf</td>
                <td>KES 200</td>
                </tr>
            <tr>
                <td>chicken</td>
                 <td>KES 500</td>
                </tr>
            <tr>
                <td>Piza</td>
                <td>KES 1000</td>
                </tr>

            </table>
            
              <p><a href= "/" style= "color: white;">Home page</a></p>
            
           
            </body></html>'''
        )
    
def about(request):
     return HttpResponse(
                 '''
                 <html><body style="font-family:Arial;padding:40px;
                 background:#0D1B3E;color:white">
                 <h1 style="color:#C9A84C">About</h1>
                 <p>We are dedicated to serve you the best meal with top flavours that will nourish you</p>
                 
                   <p><a href= "/" style= "color: white;" >Home page</a></p>
                 
                 </body></html>'''
             )
     
def contacts(request):
    return HttpResponse(
                     '''
                     <html><body style="font-family:Arial;padding:40px;
                     background:#0D1B3E;color:white">
                     <h1 style="color:#C9A84C">About</h1>
                     <h3>Phone : 0793345557 </h3>
                     <h3>Addres : Nairobi</h3>
                     <h3>Map : <a href = 'https://www.google.com/maps/place/Lavington+Mall/@-1.2681216,36.749312,14z/data=!3m1!5s0x182f1725556a946b:0xd4710e3bcc367e87!4m6!3m5!1s0x182f19f7fd53fbfd:0x40b8907600d98711!8m2!3d-1.2799559!4d36.7702275!16s%2Fg%2F1vzxh5sc?entry=ttu&g_ep=EgoyMDI2MDcyNy4wIKXMDSoASAFQAw%3D%3D' >Haile sellasie</a> </h3>
                     
                       <p><a href= "/" style= "color: white;">Home page</a></p>
                     
                     </body></html>'''
                 )

