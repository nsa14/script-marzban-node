# welcome
<div dir="rtl">
<h2>
راه اندازی مرزبان نود در سرور به راحت ترین روش
</h2>

```bash
<tab><tab>bash <(curl -fsSL https://raw.githubusercontent.com/nsa14/script-marzban-node/master/install.sh)

 کد اجرای دستور در کامند لینوکس :

   ```
    bash <(curl -fsSL https://raw.githubusercontent.com/nsa14/script-marzban-node/master/install.sh)
   ```

   <br>
   <br>
   
* این اسکریپت دقیقا مطابق با راه اندازی نود در مرزبان که داکیومنت آن در لینک زیر می باشد استفاده میکند

   ```sh
     https://gozargah.github.io/marzban/fa/docs/marzban-node
  ```

[@آموزش مرزبان نود در گیت هاب خود مرزبان](https://gozargah.github.io/marzban/fa/docs/marzban-node)
<hr>


* سیستم عامل پیشنهادی : ubuntu 22
* لوکیشن : ترجیحا هر جایی بغیر از سرورهای داخلی

<hr>
 * بهتر است سرور خود را از قبل آپدیت و اپگرید و در انتها آنرا ریبوت نمایید
{البته اپدیت در اسکریپت هم انجام می شود}

   ```sh
      apt update && apt upgrade -y
      sudo reboot
   ```


 * بعد از اجرای دستور بالا و ریبوت سرور اقدام به اجرای اسکریپت تمایید. اگر خودتان دستور اپگرید را انجام داده اید ولی 
   اسکریپت سوال مبنی بر ریبوت داد میتوانید کلمه no بزنید تا ادامه کار انجام شود


### روش اجرا :
>1 -  اسکریپت شامل 6 مرحله می باشد که همه مراحل آن بصورت خودکار تنظیمات را انجام میدهد.

>2 -  در مرحله 5 شما باید کد سرتیفیکت مربوط به نود را از پنل مرزبان خود کپی کرده و در این مرحله paste نمایید. عکس 
> زیر نمونه می باشد
> 
> ![certificate_panel.png](certificate_panel.png)

>3 -  نکته: بعد از جایگذاری سرتیفیکت برای ادامه کار enter بزنید


>4 -  نکته اخر: بعد از اتمام مرحله 6 و پیغام FINISH
> ![finished.png](finished.png)
به پنل مرزبان خود برگشته و کلید آپدیت نود را بزنید تا به نود متصل گردد. اگر خطایی دریافت کردید چندبار دکمه آپدیت 
را بزنید چون ممکن است این اتصال کمی با تاخیر شناسایی شود.
> ![buttonUpdate.png](buttonUpdate.png)


<div dir="rtl">

> + میتواند محتویات فایل های نود(docker-compose.yml, ssl_client_cert.pem ) را در صورت نیاز ویرایش نمایید

</div>


</div>