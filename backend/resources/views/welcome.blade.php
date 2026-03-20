<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>BookMate Api</title>

           <!-- Bootstrap core CSS -->
    <link href="{{ asset('vendor/bootstrap/css/bootstrap.min.css') }}" rel="stylesheet">

{{-- added  --}}
    <link rel="canonical" href="https://v5.getbootstrap.com/docs/5.0/examples/dashboard/">



    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/5.0.0-alpha1/css/bootstrap.min.css"
      integrity="sha384-r4NyP46KrjDleawBgD5tp8Y7UzmLA05oM1iAEQ17CSuDqnUK2+k9luXQOfXJCJ4I" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
      integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
      crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.0.0-alpha1/js/bootstrap.min.js"
      integrity="sha384-oesi62hOLfzrys4LxRF63OJCXdXDipiYWBnvTl9Y9/TRlw5xlKIEHpNyvvDShgf/"
      crossorigin="anonymous"></script>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />


<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/all_dash.css">

    </head>
    <body class="font-sans antialiased bd dark:text-dark/50">

        @if(Session::has('success'))

        <div class=" flex justify-center" style="padding: 20px; background-color: #2b4257;" >
            <div class="text-white flex justify-center" >
                {{ Session::get('success') }}
            </div>
        </div>
        <div class="" style="background-image: url('/image/verification.gif'); height: 91vh; background-size: 100%; background-position: center;">

        </div>
        @else
                    <header class="hh border-bottom">
                        <div class="flex items-center well s">
                        <h1>My API</h1>
                        </div>

                        <div class="flex btn-s">
                            @if (Route::has('login'))

                            @auth
                                <a
                                    href="{{ url('/dashboard') }}"
                                    class="btn"
                                >
                                    Log in
                                </a>
                            @else
                                <a
                                    href="{{ route('login') }}"
                                    class="btn"
                                >
                                    Log in
                                </a>


                            @endauth

                    @endif
                        </div>

                    </header>






                                        <div class="left-content col-lg-12">


                                            <img src="/image/charging.gif" alt="">

                                        </div>




                                          @endif

                                        </body>
</html>
