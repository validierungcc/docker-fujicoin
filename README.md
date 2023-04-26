**Fujicoin**

https://github.com/fujicoin/fujicoin.git

https://fujicoin.org/


Example docker-compose.yml

     ---
    version: '3.9'
    services:
        emark:
            container_name: fujicoin
            image: vfvalidierung/fujicoin
            restart: unless-stopped
            user: 1000:1000
            ports:
                - '38348:38348'
                - '127.0.0.1:8048:8048'
            volumes:
                - 'fujicoin:/fuji/.fujicoin'
    volumes:
       fujicoin:

**RPC Access**

    curl --user '<user>:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:8048
