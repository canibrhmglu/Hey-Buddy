<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="description" content="Chat application">
<title>Hey Buddy!</title>

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

input[type="text"], input[type="password"] {
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

/* .button:hover {
            background-color: rgb(121, 179, 233);
            border-color: rgb(121, 179, 233);
            cursor: pointer;
        } */

/* Title Bar */
#title {
    background-color: rgb(121, 179, 233);
    font-size: 20px;
    font-weight: bold;
    text-align: center;
    padding: 10px 20px 10px 20px;
    color: #fff;
}

.currentUserToTitle {
    float: right;
    font-size: 13px;
    font-weight: normal;
    padding: 4px 5px 4px 5px;
    margin-top: -23px;
    border-radius: 10px;
    background-color: rgb(154, 212, 231);
}

.signOut {
    float: right;
    font-size: 9px;
    background-color: rgb(214, 86, 69);
    border-radius: 20px;
    padding: 5px;
    margin-left: 5px;
    margin-top: -23px;
    color: #fff;
}

.signOut:focus, .signOut:hover {
    background-color: rgb(121, 179, 233);
    cursor: pointer;
}

/* Contact list */
#contacts {
    float: left;
    width: 160px;
    background-color: aliceblue;
    min-height: calc(100vh - 43px);
    max-height: calc(100vh - 43px);
    display: none;
}

#contacts .contacts-title {
    margin-bottom: 10px;
    padding-top: 15px;
    height: 40px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
    color: #fff;
    background-color: rgb(154, 212, 231);
}

#contacts .contact {
    background-color: rgb(121, 179, 233);
    text-align: center;
    width: 140px;
    border-radius: 10px;
    margin-left: 10px;
    margin-bottom: 10px;
}

#contacts .contact .unread {
    background-color: rgb(168, 218, 235);
    width: 15px;
    height: 15px;
    border-radius: 50%;
    display: inline-block;
    margin-right: -15px;
    margin-bottom: 2px;
}

.contact:focus, .contact:hover {
    background-color: rgb(168, 218, 235);
    cursor: pointer;
}

#contacts .contact .name {
    line-height: 40px;
    vertical-align: super;
    font-size: 15px;
    color: #fff;
    padding: 5px;
}

/* Chat */
#chat {
    float: right;
    width: calc(100% - 160px);
    min-height: calc(100vh - 43px);
    max-height: calc(100vh - 43px);
    display: block;
    text-align: center;
}

#messages {
    min-height: calc(100vh - 130px);
    max-height: calc(100vh - 130px);
    padding: 20px 20px 0 20px;
    overflow-y: auto;
}

#messages .message {
    margin-bottom: 3px;
}

#messages .message .content {
    min-width: 20px;
    max-width: 250px;
    border-radius: 20px;
    padding: 5px 10px 5px 10px;
    display: table;
    margin-bottom: 5px;
}

#messages .message #content {
    min-width: 20px;
    max-width: 250px;
    border-radius: 0px;
    padding: 4px 4px 1px 4px;
    display: table;
    margin-bottom: 5px;
}

#messages .message .time {
    background-color: aliceblue;
    color: rgba(10, 134, 143, 0.932);
    padding-left: 5px;
    padding-right: 5px;
    height: 20px;
    border-radius: 5px;
    font-size: 10px;
    opacity: 0.5;
}

#messages .message.received {
    left: 0;
    text-align: left;
}

#messages .day .content {
    background-color: #FF7E29;
    color: #fff;
    border-radius: 10px;
    margin-left: auto;
    margin-right: auto;
    font-size: 10px;
    padding: 3px;
}

#messages .message.received .content {
    background-color: rgb(121, 179, 233);
    color: aliceblue;
    border-radius: 0 20px 20px;
}

#messages .message.received #content {
    background-color: rgb(121, 179, 233);
    color: aliceblue;
    border-radius: 0px;
}

#messages .message.received .sender {
    color: aliceblue;
    font-size: 10px;
}

#messages .message.sent {
    right: 0;
    text-align: right;
}

#messages .message.sent .content {
    background-color: rgb(121, 179, 233);
    margin-left: auto;
    margin-right: 0;
    color: aliceblue;
    text-align: right;
    border-radius: 20px 0 20px 20px;
}

#messages .message.sent #content {
    background-color: rgb(121, 179, 233);
    margin-left: auto;
    margin-right: 0;
    color: aliceblue;
    text-align: right;
    border-radius: 0px;
}

img.imgContent {
    height: auto;
    width: auto;
    max-height: 250px;
    max-width: 250px;
}

#chat-controls {
    height: 40px;
    padding: 20px 10px 7px 10px;
}

#chat-controls button {
    float: right;
    min-width: 50px;
    max-width: 100px;
    width: calc(8%);
}

#chat-controls input[type="text"] {
    width: calc(90% - 65px);
    min-width: 200px;
    max-width: 1100px;
    padding: 10px 0px 10px 5px;
}

.inputfile {
    width: 0.1px;
    height: 0.1px;
    opacity: 0;
    overflow: hidden;
    position: absolute;
    z-index: -1;
}

.inputfile+label {
    font-size: 13px;
    font-weight: 700;
    float: left;
    min-width: 25px;
    max-width: 50px;
    width: calc(5%);
    color: white;
    background-color: rgb(121, 179, 233);
    cursor: pointer;
    padding-bottom: 10px;
    padding-top: 10px;
    border-radius: 20px;
}

#messages .message.sent.same-sender-previous-message .sender, #messages .message.received.same-sender-previous-message .sender
    {
    display: none;
}

#messages .message:not (.same-sender-previous-message ) {
    margin-top: 10px;
}
</style>


</head>
<body>

    <div id="title">Hey Buddy!</div>

    <div id="contacts"></div>

    <div id="chat" style="background-image: url(${pageContext.request.contextPath}/sand.jpg)"></div>

    <script type="text/javascript">
  var socket;
  var currentUser;
  var contactUser = "";
  var initialLoadOK = false;
  var allMessages = [];
  var lastMessageDate = "";
  var lastMessageTime = "";
  var lastMessageSender = "";
  
  var accessToken = "<%=request.getParameter("access-token")%>";
  openSocket(accessToken);
  
  
  function openSocket(accessToken) {

      if (socket) {
          socket.close();
      }

      currentUser = "<%=request.getParameter("username")%>";

      if(location.host.includes("localhost"))
          socket = new WebSocket("ws://" + location.host + "/ws?access-token=" + accessToken);
      else
          socket = new WebSocket("wss://" + location.host + "/ws?access-token=" + accessToken);


      socket.onopen = function (event) {
          setInterval(ping, 30000);
          document.getElementById("contacts").style.display = "block";

          var title = document.getElementById("title");
          
          var buttonForm = document.createElement("form");
          buttonForm.setAttribute("action","/Auth");
          buttonForm.method="post";
          var signOut = document.createElement("button");
          signOut.setAttribute("class", "signOut");
          buttonForm.appendChild(signOut);
          signOut.onclick = function() {
              socket.close();
              buttonForm.submit();
          }
          
          signOut.innerHTML = "Sign Out";

          title.appendChild(buttonForm);

          var currentUserToTitle = document.createElement("span");
          currentUserToTitle.setAttribute("class", "currentUserToTitle");
          currentUserToTitle.innerHTML = currentUser;


          title.appendChild(currentUserToTitle);

          var allUserNames;
          var request = new XMLHttpRequest();
          request.open("GET", "/userService");
          request.setRequestHeader("accept", "application/json");
          request.addEventListener("readystatechange", function () {
                if (request.readyState === XMLHttpRequest.DONE) {
                    if(request.status == 200) {
                        allUserNames = JSON.parse(request.responseText);
                        
                        allUserNames.forEach(function (username) {
                            
                            addUserToContact(username);

                        });
                    }
                    else {
                        console.log("All Usernames could not fetch from DB!");
                    }
                        
                }
            });
            request.send();
          
          
          

          addConnectedUser(currentUser);
      };


      socket.onmessage = function (event) {

          if (typeof event.data === "string") {
              var webSocketMessage = JSON.parse(event.data);
              var webSocketMessagePayload = webSocketMessage.payload;
              switch (webSocketMessage.type) {
                  case "message":
                      addMessageToAllMessages(webSocketMessagePayload.sender, webSocketMessagePayload.receiver, webSocketMessagePayload.contentType, webSocketMessagePayload.content, webSocketMessagePayload.receivedDate);
                      if (contactUser != "" && (webSocketMessagePayload.sender == currentUser || webSocketMessagePayload.sender == contactUser))
                          displayMessage(webSocketMessagePayload.sender, webSocketMessagePayload.receiver, webSocketMessagePayload.contentType, webSocketMessagePayload.content, webSocketMessagePayload.receivedDate);
                      else if(initialLoadOK == true)
                          addAlertToContact(webSocketMessagePayload.sender);
                      break;
                  case "connectedUser":
                      addUserToContact(webSocketMessagePayload.username);
                      break;
                  case "disconnectedUser":
                      //removeUserFromContact(webSocketMessagePayload.username);
                      break;
                  case "initialLoadOK":
                      initialLoadOK = true;
                      break;
                  case "pingPong":
                      pong();
                      break;
              }
          }
      };
  }
  
  function ping() {
      socket.send("__ping__");
      tm = setTimeout(function () {

         /// ---connection closed ///


     }, 5000);
  }

  function pong() {
     clearTimeout(tm);
  }
  

  function sendMessage() {

      var textContent;
      var imageContent;
      var contentType;
      var text = document.getElementById("message").value;
      var fileInput = document.getElementById("file");

      if (fileInput.files.length > 0) {
          contentType = "img";

          var reader = new FileReader();
          reader.readAsArrayBuffer(fileInput.files[0]);
          reader.onload = function (event) {
              imageContent = event.target.result;
              var imageToArray = new Uint8Array(imageContent);

              var date = new Date();
              var currentDate = date.getFullYear() + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + ("0" + date.getDate()).slice(-2) + ' ' + ("0" + date.getHours()).slice(-2) + ':' + ("0" + date.getMinutes()).slice(-2);
              var webSocketMessage = {
                  type: "message",
                  contentType: contentType,
                  content: imageToArray,
                  sender: currentUser,
                  receiver: contactUser,
                  receivedDate: currentDate
              };
              if (text != "" || fileInput.files.length > 0) {
                  socket.send(JSON.stringify(webSocketMessage));
              }
          };
      }
      else {// text 
          contentType = "txt";
          textContent = text;
          document.getElementById("message").value = "";
          var date = new Date();
          var currentDate = date.getFullYear() + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + ("0" + date.getDate()).slice(-2) + ' ' + ("0" + date.getHours()).slice(-2) + ':' + ("0" + date.getMinutes()).slice(-2);
          var webSocketMessage = {
              type: "message",
              contentType: contentType,
              content: textContent,
              sender: currentUser,
              receiver: contactUser,
              receivedDate: currentDate
          };
          if (text != "" || fileInput.files.length > 0) {
              socket.send(JSON.stringify(webSocketMessage));
          }
      }

  }

  function addMessageToAllMessages(sender, receiver, contentType, content , deliveryDate) {

      var newMessage = {
          sender: sender,
          receiver: receiver,
          contentType : contentType,
          content: content,
          receivedDate: deliveryDate
      };

      allMessages.push(newMessage);

  }

  function displayMessage(peerOne, peerTwo, contentType, content, receivedDate) {   

      if(content == undefined) { // Display old messages from DB.
          deleteConversationScreen();
          createConversationScreen(); 
          
          allMessages.forEach(function (item) {
              if ((peerOne == item.sender && peerTwo == item.receiver) || (peerTwo == item.sender && peerOne == item.receiver)) {
                  appendMessage(item.sender, item.receiver, item.contentType, item.content, item.receivedDate);
              }

          });
          
      }    
      else {
          
          if(messages == null ) {
              createConversationScreen(); 
          }
          
          appendMessage(peerOne, peerTwo, contentType, content, receivedDate);
          
      }
      
      
  }
  
  function appendMessage(peerOne, peerTwo, contentType, content, receivedDate) {
      
      messages = document.getElementById("messages");
      

      var messageDate = receivedDate.split(' ')[0];
      var messageTime = receivedDate.split(' ')[1];
      
      var sentByCurrentUser = currentUser === peerOne;

      var message = document.createElement("div");
      message.setAttribute("class", sentByCurrentUser === true ? "message sent" : "message received");

      if (messageDate != lastMessageDate) {
          var day = document.createElement("div");
          day.setAttribute("class","day");

          var dateContent = document.createElement("span");
          dateContent.setAttribute("class", "content");
          dateContent.appendChild(document.createTextNode(messageDate));
          day.appendChild(dateContent);

          messages.appendChild(day);
      }

      
      var messageContent = document.createElement("span");
      messageContent.setAttribute("class", "content");

      if(contentType == "img") {
          var imgContent = document.createElement("img");
          imgContent.setAttribute("class","imgContent");
          messageContent.removeAttribute("class");
          messageContent.setAttribute("id", "content");

          var imgArray = [];
          JSON.parse(JSON.stringify(content), (key, value) => imgArray.push(value));
          var imgUint = new Uint8Array(imgArray);

          var blob = new Blob([imgUint.buffer], { type: "image/*" });
          var urlCreator = window.URL || window.webkitURL;
          var imageUrl = urlCreator.createObjectURL(blob);
          imgContent.src = imageUrl;
          messageContent.appendChild(imgContent);
      }
      else if(contentType == "txt" ) { 
          messageContent.appendChild(document.createTextNode(content));
      }

      message.appendChild(messageContent);
      

      if (messageTime == lastMessageTime && peerOne == lastMessageSender) {
          var time = document.getElementsByClassName("time");
          var i = time.length - 1;
          time[i].parentElement.removeChild(time[i]);
      }

      var time = document.createElement("span");
      time.setAttribute("class", "time");
      time.appendChild(document.createTextNode(messageTime));
      message.appendChild(time);

      messages.appendChild(message);

      lastMessageDate = messageDate;
      lastMessageTime = messageTime;
      lastMessageSender = peerOne;
      

      messages.scrollTop = messages.scrollHeight;
      
  }

  function addConnectedUser(currentUser) {
      var webSocketMessage = {
          type: "connectedUser",
          username: currentUser
      };
      socket.send(JSON.stringify(webSocketMessage));

  }

  function addUserToContact(username) {
      var contacts = document.getElementById("contacts");
      var contact = document.getElementsByClassName("contact");
      var isUserExist = false;

      if (contacts.hasChildNodes() == false) {
          var contactsTitle = document.createElement("div");
          contactsTitle.setAttribute("class", "contacts-title");
          contactsTitle.innerHTML = "Chats";
          contacts.appendChild(contactsTitle);
      }

      for (var i = 0; i < contact.length; i++) {
          if (contact[i].firstChild.innerText == username) {
              isUserExist = true;
          }

      }
      
      if (currentUser != username && isUserExist == false) {
          var contact = document.createElement("div");
          contact.setAttribute("class", "contact");

          var name = document.createElement("span");
          name.setAttribute("class", "name");
          name.appendChild(document.createTextNode(username));
          contact.appendChild(name);
          contact.addEventListener("click", function () {
              contactUser = username;
              removeAlertToContact(contactUser);
              displayMessage(currentUser, contactUser);
          })

          contacts.appendChild(contact);
      }
  }

  function removeUserFromContact(username) {
      var contacts = document.getElementById("contacts");
      var contact = document.getElementsByClassName("contact");

      for (var i = 0; i < contact.length; i++) {
          if (contact[i].firstChild.innerText == username) {
              contacts.removeChild(contact[i]);
          }

      }

      if(contactUser == username) {
          deleteConversationScreen();
          contactUser = "";
      }
  }


  function addBackgroundColorToContact() {

      var contact = document.getElementsByClassName("contact");

      for (var i = 0; i < contact.length; i++) {
          if (contact[i].innerText == contactUser) {
              contact[i].style.backgroundColor = "rgb(168, 218, 235)";
              contact[i].style.borderRadius = "10px";
          }
          else {
              contact[i].style.backgroundColor = "";
          }
      }

  }

  function addAlertToContact(sender) {

      var contact = document.getElementsByClassName("contact");

      for (var i = 0; i < contact.length; i++) {
          if (contact[i].innerText == sender) {
              var unread = document.createElement("div");
              unread.setAttribute("class", "unread");
              contact[i].appendChild(unread);
          }
      }

  }

  function removeAlertToContact(sender) {

      var contact = document.getElementsByClassName("contact");
      
      for (var i = 0; i < contact.length; i++) {
          if (contact[i].innerText == sender && contact[i].getElementsByClassName("unread").length >= 1 ) {
              contact[i].removeChild(contact[i].childNodes[1]);
          }
      }

  }

  function deleteConversationScreen() {
      
      lastMessageDate = "";
      lastMessageTime = "";
      lastMessageSender = "";

      var chat = document.getElementById("chat");

      if (document.body.contains(chat) == true) {
          while (chat.hasChildNodes() == true) {
              chat.removeChild(chat.firstChild);
          }
      }

  }

  function createConversationScreen() {

      addBackgroundColorToContact();

      var chat = document.getElementById("chat");
      var messages = document.getElementById("messages");


      if (document.body.contains(messages) == true) {
          while (chat.hasChildNodes() == true) {
              chat.removeChild(chat.firstChild);
          }
      }
      //chat.setAttribute("style","background-image: url(${pageContext.request.contextPath}/sand.jpg)");

      var messages = document.createElement("div"); 
      messages.setAttribute("id", "messages");

      chat.append(messages);

      var chatControls = document.createElement("form");
      chatControls.setAttribute("id", "chat-controls");
      chatControls.setAttribute("onsubmit", "return false;");

      var file = document.createElement("input");
      file.setAttribute("type","file");
      file.setAttribute("id","file");
      file.setAttribute("class","inputfile");
      //file.setAttribute("accept","image/*");

      var label = document.createElement("label");
      label.setAttribute("for","file");
      label.innerHTML = "...";

      
      var text = document.createElement("input");
      text.setAttribute("type", "text");
      text.setAttribute("id", "message");
      text.setAttribute("placeholder", "Enter a message");
      
      var button = document.createElement("button");
      button.setAttribute("class", "button");
      button.setAttribute("onclick", "sendMessage()");
      button.innerHTML = "Send";
      
      chatControls.appendChild(file);
      chatControls.appendChild(label);
      chatControls.appendChild(text);
      chatControls.appendChild(button);

      chat.appendChild(chatControls);
      
      var inputs = document.querySelectorAll('.inputfile');
      Array.prototype.forEach.call(inputs, function (input) {
          var label = input.nextElementSibling,
              labelVal = label.innerHTML;

          input.addEventListener('change', function (e) {
              var fileName = e.target.value.split('\\' ).pop();

                if (fileName)
                  label.innerHTML = fileName;
              else
                  label.innerHTML = labelVal;
          });
      });

      //document.getElementById("chat").style.display = "block";
      //document.getElementById("message").focus();
      
  }
  
  </script>

</body>
</html>