const API_URL = '/api/auth';
const WS_URL = `ws://${window.location.host}/ws/chat`;

// State
let currentUser = null;
let token = localStorage.getItem('token');
let socket = null;

// DOM Elements
const screens = {
    login: document.getElementById('login-screen'),
    signup: document.getElementById('signup-screen'),
    chat: document.getElementById('chat-screen')
};

// Navigation
function showScreen(screenName) {
    Object.values(screens).forEach(s => s.classList.remove('active'));
    screens[screenName].classList.add('active');
}

// Auth Logic
async function login(username, password) {
    try {
        const response = await fetch(`${API_URL}/signin`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, password })
        });

        if (response.ok) {
            const data = await response.json();
            token = data.accessToken;
            localStorage.setItem('token', token);
            currentUser = { username }; // In a real app, decode JWT to get more info
            initChat();
            showScreen('chat');
        } else {
            alert('Login failed');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Login error');
    }
}

async function signup(data) {
    try {
        const response = await fetch(`${API_URL}/signup`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            alert('Signup successful! Please login.');
            showScreen('login');
        } else {
            const text = await response.text();
            alert('Signup failed: ' + text);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Signup error');
    }
}

function logout() {
    token = null;
    currentUser = null;
    localStorage.removeItem('token');
    if (socket) socket.close();
    showScreen('login');
}

// WebSocket & Chat Logic
// WebSocket & Chat Logic
let currentReceiver = 'Global';

function initChat() {
    if (!token) return;

    // Update UI
    document.getElementById('current-user-name').textContent = currentUser.username;
    document.getElementById('current-user-avatar').textContent = currentUser.username.charAt(0).toUpperCase();

    // Connect WebSocket
    socket = new WebSocket(WS_URL);

    socket.onopen = () => {
        console.log('Connected to WebSocket');
        // Send JOIN message
        const joinMsg = {
            type: 'JOIN',
            sender: currentUser.username,
            content: 'Joined',
            contentType: 'txt'
        };
        socket.send(JSON.stringify(joinMsg));
    };

    socket.onmessage = (event) => {
        const message = JSON.parse(event.data);
        if (message.type === 'USER_LIST') {
            updateUserList(JSON.parse(message.content));
        } else if (message.type === 'CHAT') {
            displayMessage(message);
        }
    };

    socket.onclose = () => {
        console.log('Disconnected from WebSocket');
    };
}

function updateUserList(users) {
    const list = document.getElementById('online-users-list');
    list.innerHTML = '';

    // Add Global Chat option
    const globalLi = document.createElement('li');
    globalLi.innerHTML = `
        <div class="user-avatar">G</div>
        <div class="user-info">
            <div class="user-name">Global Chat</div>
            <div class="user-status">online</div>
        </div>
    `;
    globalLi.onclick = () => setReceiver('Global');
    if (currentReceiver === 'Global') globalLi.classList.add('active');
    list.appendChild(globalLi);

    // Add other users
    users.forEach(user => {
        if (user !== currentUser.username) {
            const li = document.createElement('li');
            li.innerHTML = `
                <div class="user-avatar">${user.charAt(0).toUpperCase()}</div>
                <div class="user-info">
                    <div class="user-name">${user}</div>
                    <div class="user-status">online</div>
                </div>
            `;
            li.onclick = () => setReceiver(user);
            if (currentReceiver === user) li.classList.add('active');
            list.appendChild(li);
        }
    });
}

function setReceiver(receiver) {
    currentReceiver = receiver;
    document.getElementById('chat-header-name').textContent = receiver === 'Global' ? 'Global Chat' : receiver;

    // Update active state in list
    const listItems = document.querySelectorAll('#online-users-list li');
    listItems.forEach(li => {
        const name = li.querySelector('.user-name').textContent;
        if ((receiver === 'Global' && name === 'Global Chat') || name === receiver) {
            li.classList.add('active');
        } else {
            li.classList.remove('active');
        }
    });

    // Clear messages or filter them? For now, we just keep all messages but maybe we should filter visually
    // For MVP, we show all messages but in a real app we'd filter by conversation
    filterMessages();
}

function filterMessages() {
    const messages = document.querySelectorAll('.message');
    messages.forEach(msg => {
        const sender = msg.dataset.sender;
        const receiver = msg.dataset.receiver;

        if (currentReceiver === 'Global') {
            // Show global messages
            if (receiver === 'Global') {
                msg.style.display = 'flex';
            } else {
                msg.style.display = 'none';
            }
        } else {
            // Show private messages between me and currentReceiver
            if ((sender === currentUser.username && receiver === currentReceiver) ||
                (sender === currentReceiver && receiver === currentUser.username)) {
                msg.style.display = 'flex';
            } else {
                msg.style.display = 'none';
            }
        }
    });
}

function sendMessage(content) {
    if (!socket || socket.readyState !== WebSocket.OPEN) return;

    const message = {
        type: 'CHAT',
        content: content,
        sender: currentUser.username,
        receiver: currentReceiver,
        contentType: 'txt'
    };

    socket.send(JSON.stringify(message));
}

function displayMessage(msg) {
    const container = document.getElementById('messages-container');
    const div = document.createElement('div');
    const isOwn = msg.sender === currentUser.username;

    div.className = `message ${isOwn ? 'sent' : 'received'}`;
    // Store metadata for filtering
    div.dataset.sender = msg.sender;
    div.dataset.receiver = msg.receiver || 'Global'; // Default to Global if null

    div.innerHTML = `
        <div class="message-sender">${isOwn ? 'You' : msg.sender}</div>
        <div class="message-content">${msg.content}</div>
        <div class="message-time">${new Date(msg.receivedDate).toLocaleTimeString()}</div>
    `;

    container.appendChild(div);
    container.scrollTop = container.scrollHeight;

    // Re-filter to ensure visibility is correct based on current view
    filterMessages();
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    // Check if already logged in (simple check)
    if (token) {
        // Ideally validate token with backend here
        // For now, just assume valid and ask for username if missing (or decode JWT)
        // To keep it simple, force login if no user info
        showScreen('login');
    } else {
        showScreen('login');
    }

    // Forms
    document.getElementById('login-form').addEventListener('submit', (e) => {
        e.preventDefault();
        login(document.getElementById('username').value, document.getElementById('password').value);
    });

    document.getElementById('signup-form').addEventListener('submit', (e) => {
        e.preventDefault();
        signup({
            name: document.getElementById('signup-name').value,
            lastname: document.getElementById('signup-lastname').value,
            username: document.getElementById('signup-username').value,
            email: document.getElementById('signup-email').value,
            password: document.getElementById('signup-password').value
        });
    });

    // Navigation
    document.getElementById('show-signup').addEventListener('click', (e) => {
        e.preventDefault();
        showScreen('signup');
    });

    document.getElementById('show-login').addEventListener('click', (e) => {
        e.preventDefault();
        showScreen('login');
    });

    document.getElementById('logout-btn').addEventListener('click', logout);

    // Chat
    document.getElementById('send-btn').addEventListener('click', () => {
        const input = document.getElementById('message-input');
        if (input.value.trim()) {
            sendMessage(input.value);
            input.value = '';
        }
    });

    document.getElementById('message-input').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            document.getElementById('send-btn').click();
        }
    });
});
