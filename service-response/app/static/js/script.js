// Функция для подтверждения действий пользователя
function confirmAction() {
    return confirm("Are you sure you want to proceed with this action?");
}

// Пример асинхронного обновления статуса заказа
async function updateOrderStatus(orderId, newStatus) {
    try {
        const response = await fetch(`/orders/${orderId}/update-status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ status: newStatus })
        });

        if (response.ok) {
            alert('Order status updated successfully.');
            window.location.reload(); // Перезагрузить страницу для обновления данных
        } else {
            throw new Error('Failed to update order status.');
        }
    } catch (error) {
        alert(error.message);
    }
}

// Пример валидации формы на клиентской стороне
function validateForm() {
    const username = document.getElementById('username').value;
    if (username.length < 4) {
        alert('Username must be at least 4 characters long.');
        return false;
    }
    return true;
}

// Добавление обработчиков событий при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    const updateButtons = document.querySelectorAll('.update-status-button');
    updateButtons.forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.dataset.orderId;
            const newStatus = this.dataset.newStatus;
            if (confirmAction()) {
                updateOrderStatus(orderId, newStatus);
            }
        });
    });

    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', function(event) {
            if (!validateForm()) {
                event.preventDefault(); // Остановить отправку формы
            }
        });
    }
});
