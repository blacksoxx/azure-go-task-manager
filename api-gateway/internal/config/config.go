package config

import (
    "os"
    "apigateway/internal/models"
)

func LoadConfig() *models.GatewayConfig {
    return &models.GatewayConfig{
        Port: getEnv("PORT", "8080"),
        Services: map[string]models.ServiceConfig{
            "user-service": {
                Name: "user-service",
                URL:  getEnv("USER_SERVICE_URL", "http://user-service:8081"), 
            },
            "auth-service": {
                Name: "auth-service", 
                URL:  getEnv("AUTH_SERVICE_URL", "http://auth-service:8084"), 
            },
            "task-service": {
                Name: "task-service",
                URL:  getEnv("TASK_SERVICE_URL", "http://task-service:8082"), 
            },
            "notification-service": {
                Name: "notification-service",
                URL:  getEnv("NOTIFICATION_SERVICE_URL", "http://notification-service:8083"),
            },
        },
    }
}

func getEnv(key, defaultValue string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return defaultValue
}
