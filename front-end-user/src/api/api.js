import axios from 'axios';

const API_URL = 'http://localhost:8000';  // Укажите URL вашего API

export const fetchEmployees = async () => {
    try {
        const response = await axios.get(`${API_URL}/employees/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch employees', error);
        throw error;
    }
};

// Добавьте другие функции для работы с API (создание, обновление, удаление)
