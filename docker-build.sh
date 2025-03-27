#!/bin/bash
set -e

function check_requirements() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi
    if ! command -v docker compose &> /dev/null; then
        echo "Error: Docker Compose is not installed"
        exit 1
    fi
}

function show_usage() {
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  build    - Build the Docker image"
    echo "  start    - Start the container"
    echo "  stop     - Stop the container"
    echo "  restart  - Restart the container"
    echo "  logs     - Show container logs"
    echo "  cleanup  - Remove unused images and volumes"
}

check_requirements

case "$1" in
    "build")
        DOCKER_BUILDKIT=1 docker compose build --progress=plain
        ;;
    "start")
        docker compose up -d
        echo "Tabby is now running on http://localhost:8080"
        ;;
    "stop")
        docker compose down
        ;;
    "restart")
        docker compose restart
        ;;
    "logs")
        docker compose logs -f
        ;;
    "cleanup")
        docker compose down --remove-orphans
        docker image prune -f
        docker volume prune -f
        ;;
    *)
        show_usage
        ;;
esac
