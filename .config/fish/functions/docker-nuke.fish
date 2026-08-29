function docker-nuke
    docker system prune -a --volumes -f
    and docker builder prune -a -f
    and docker volume prune -a -f
end
