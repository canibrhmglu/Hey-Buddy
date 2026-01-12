<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <style>
        /* Common */

        * {
            margin: 0;
            padding: 0;
            font-family: sans-serif;
            font-size: 13px;
            outline: 0;
        }

        .error {
            color: #F04823;
            font-size: 12px;
        }

        input[type="text"],
        input[type="password"] {
            border-radius: 20px;
            padding: 10px;
            border: 2px solid gainsboro;
        }

        .button {
            border-radius: 20px;
            padding: 10px;
            background-color: rgb(121, 179, 233);
            color: #fff;
            width: 6em;
            border: 2px solid rgb(121, 179, 233);
        }

        .button:hover,
        .button:focus {
            background-color: rgb(121, 179, 233);
            border-color: rgb(121, 179, 233);
            cursor: pointer;
        }
        
        .signUpText {
        text-align: center;
        padding: 10px 2.5px 0px 2.5px;
        font-weight: normal;
        font-size: 13px;
        margin-top: 170px;
        }

        /* Authentication */

        #authentication {
            margin-top: 100px;
        }

        #authentication * {
            display: block;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 10px;
            text-align: center;
        }
        
        #authentication .error {
            text-align: center;
        }
        
        #signUp * {
            display: block;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 10px;
            
        }
        #signUp .button {
            background-color: #FF7E29;
            border: 2px solid #FF7E29;
            width: 9em;
        }


        /* Title Bar */

        #title {
            background-color: rgb(121, 179, 233);
            font-size: 20px;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px 10px 20px;
            color: #fff;
        }
</style>
<head>
<meta charset="ISO-8859-1">
<title>Hey Buddy!</title>
</head>
<body>
	<div id="title">Hey Buddy!</div>
	
	

    <form id="authentication" onsubmit="return false;">
        <a>If you have an account </a>
        <input type="text" name="username" id="username" placeholder="Username" autofocus />
        <input type="password" name="password" id="password" placeholder="Password"/>
        <input type="hidden" name="access-token" id="access-token"/>
        <button class="button" onclick="signIn()">Sign In</button>
        
        <span class="error" id="authentication-error"></span>
    </form>
    
    <form id="signUp" action ="/SignUp" onclick="signUp()">
    <a class="signUpText">Create new account</a>
    <button class="button">Sign Up</button>
    </form>
    
        <script>

        var socket;
        var currentUser;
        var contactUser;
        var allMessages = [];

        function signIn() {

            var credentials = {
                username: document.getElementById("username").value,
                password: document.getElementById("password").value
            };

            var request = new XMLHttpRequest();
            request.withCredentials = true;
            request.addEventListener("readystatechange", function () {
                if (request.readyState === XMLHttpRequest.DONE) {
                    switch (request.status) {
                        case 200:
                        	var webSocketAccessToken = JSON.parse(request.responseText);
                        	var accessToken = webSocketAccessToken.token;
                          	document.getElementById("access-token").value = accessToken;
                          	var form = document.getElementById("authentication");
                          	form.setAttribute("action","/Chat");
                          	form.method="post";
                            form.submit();
                            break;
                        case 403:
                            currentUser = null;
                            document.getElementById("authentication-error").innerHTML = "Oops... These credentials are invalid.";
                            break;
                        default:
                            document.getElementById("authentication-error").innerHTML = "Oops... Looks like something is broken.";
                    }
                }
            });
            request.open("POST", "/Authentication");
            request.setRequestHeader("content-type", "application/json");
            request.setRequestHeader("accept", "application/json");
            request.send(JSON.stringify(credentials));

        }
        
        
        function signUp() {

        }
        
        </script>
        
</body>
</html>