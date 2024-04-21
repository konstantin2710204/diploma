// scripts.js

// Функция для подтверждения удаления
function confirmAction() {
    return confirm("Are you sure you want to perform this action?");
}

// Обновление статуса заказа через AJAX
function updateOrderStatus(orderId, newStatus) {
    fetch(`/update-order-status/${orderId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCSRFToken() // Необходимо получить CSRF токен для безопасности
        },
        body: JSON.stringify({status: newStatus})
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert("Order status updated successfully.");
            location.reload(); // Перезагружаем страницу для обновления данных
        } else {
            alert("Failed to update order status.");
        }
    })
    .catch(error => console.error('Error updating order status:', error));
}

// Получение CSRF токена из cookies (для Flask-WTF csrf protection)
function getCSRFToken() {
    const cookies = document.cookie.split(';');
    for (let cookie of cookies) {
        let [name, value] = cookie.split('=');
        if (name.trim() === 'csrf_token') {
            return decodeURIComponent(value);
        }
    }
    return null;
}
