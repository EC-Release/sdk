 ## to run
```bash
docker run --network host \
-v $(pwd):/build \
-e DIND_PATH="" \
--env-file v1.1beta.list -it wzlib:v1.1beta
```
