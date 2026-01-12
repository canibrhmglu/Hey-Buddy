<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Hey Buddy!</title>

        <style>
            * {
                margin: 0;
                padding: 0;
                font-family: sans-serif;
                font-size: 13px;
                outline: 0;
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
            
            #SignUp {
                margin-top: 100px
            }
            
            #SignUp * {
                display: block;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 10px;
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

    </head>

    <body>

        <div id="title">Hey Buddy!</div>

        <form id="SignUp" method=post action = "">
            <input type="text" name="name" id="name" placeholder="Name" />
            <input type="text" name="lastname" id="lastname" placeholder="Lastname" />
            <input type="text" name="email" id="email" placeholder="Email" />
            <input type="text" name="username" id="username" placeholder="Username" />
            <input type="password" name="password" id="password" placeholder="Password" />
            <input type="password" name="password" id="rePassword" placeholder="Re-enter Password" />
            <button class="button" type="submit" onclick="signUp()">Sign Up</button>
        </form>

        <script>
        
            function signUp() {
                var name = document.getElementById("name");
                var lastname = document.getElementById("lastname");
                var email = document.getElementById("email");
                var username = document.getElementById("username");
                var password = document.getElementById("password");
                var rePassword = document.getElementById("rePassword");
                
                var isCreateNewUserOK = false;

                if (password.value != rePassword.value) {
                    alert("passwords must match!");
                    isCreateNewUserOK = false;
                }
                else {
                	isCreateNewUserOK = true;
                }

                if (name.value == "" || lastname.value == "" || email.value == "" || username.value == "" || password.value == "") {
                    alert("no field can be empty.");
                    isCreateNewUserOK = false;
                }
                else {
                	isCreateNewUserOK = true;
                }
                
                
                if(isCreateNewUserOK == true) {
                	var signUpForm = document.getElementById("SignUp");
                	signUpForm.setAttribute("action","/userService");
                	signUpForm.submit();
                }
            }
        </script>

    </body>

    </html>