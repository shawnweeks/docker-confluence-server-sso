### Build Command
```shell
docker build \
    -t $REGISTRY/atlassian-suite/confluence-server-sso:7.7.3.$(date +"%Y%m%d%H%M%S") \
    --build-arg BASE_REGISTRY=$REGISTRY \
    --build-arg CONFLUENCE_VERSION=7.7.3 \
    .
```

### Push to Registry
```shell
docker push $REGISTRY/atlassian-suite/confluence-server-sso
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name confluence  \
    -v confluence-data:/var/atlassian/application-data/confluence \
    -p 8090:8090 \
    $REGISTRY/atlassian-suite/confluence-server-sso:7.7.3.20201103170932
```

### SSO Run Command
```shell
# Run first and setup Crowd Directory
docker run --init -it --rm \
    --name confluence  \
    -v confluence-data:/var/atlassian/application-data/confluence \
    -p 8090:8090 \
    -e ATL_TOMCAT_CONTEXTPATH='/confluence' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    $REGISTRY/atlassian-suite/confluence-server-sso:7.7.3

# Run second after you've setup the crowd connection
docker run --init -it --rm \
    --name confluence  \
    -v confluence-data:/var/atlassian/application-data/confluence \
    -p 8090:8090 \
    -e ATL_TOMCAT_CONTEXTPATH='/confluence' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    -e CROWD_SSO_ENABLED='true' \
    -e CUSTOM_SSO_LOGIN_URL='https://cloudbrocktec.com/spring-crowd-sso/saml/login' \
    -e CROWD_APP_NAME='confluence' \
    -e CROWD_APP_PASS='confluence' \
    -e CROWD_BASE_URL='https://cloudbrocktec.com/crowd' \
    $REGISTRY/atlassian-suite/confluence-server-sso:7.7.3
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| ATL_TOMCAT_PORT | The port confluence listens on, this may need to be changed depending on your environment. | 8090 |
| ATL_TOMCAT_SCHEME | The protocol via which confluence is accessed | http |
| ATL_TOMCAT_SECURE | Set to true if `ATL_TOMCAT_SCHEME` is 'https' | false |
| ATL_TOMCAT_CONTEXTPATH | The context path the application is served over | None |
| ATL_PROXY_NAME | The reverse proxys full URL for confluence | None |
| ATL_PROXY_PORT | The reverse proxy's port number | None |
| CUSTOM_SSO_LOGIN_URL | Login URL for Custom SSO Support | None |
| CROWD_SSO_ENABLED | Enable Crowd SSO Support | false |
| CROWD_APP_NAME | Crowd Application Name, Required if for Crowd SSO. | None |
| CROWD_APP_PASS | Crowd Application Password, Required if for Crowd SSO. | None |
| CROWD_BASE_URL | Crowd's Base URL | None |
| JVM_MINIMUM_MEMORY | Set's Java XMS | None |
| JVM_MAXIMUM_MEMORY | Set's Java XMX | None |