import axios from 'axios';

const API_URL = 'http://localhost:8000';

// Получение списка сотрудников
export const fetchEmployees = async () => {
    try {
        const response = await axios.get(`${API_URL}/employees/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch employees', error);
        throw error;
    }
};

// Получение списка сборок
export const fetchComputerBuilds = async () => {
    try {
        const response = await axios.get(`${API_URL}/computer_builds/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch computer builds', error);
        throw error;
    }
};

// Получение списка заказов
export const fetchOrders = async () => {
    try {
        const response = await axios.get(`${API_URL}/orders/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch orders', error);
        throw error;
    }
};

// Получение архивных сборок
export const fetchArchivedComputerBuilds = async () => {
    try {
        const response = await axios.get(`${API_URL}/archived_computer_builds/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch archived computer builds', error);
        throw error;
    }
};

// Получение архивных заказов
export const fetchArchivedOrders = async () => {
    try {
        const response = await axios.get(`${API_URL}/archived_orders/`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch archived orders', error);
        throw error;
    }
};
