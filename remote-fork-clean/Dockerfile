FROM ubuntu

ENV PORT=8027

RUN apt-get update -y && apt-get install -y --no-install-recommends curl net-tools libssl1.0.0 libicu60 unzip \
  && curl --insecure "https://dev.azure.com/ivang7/d353c128-4762-4b49-b2a6-f6f799e19487/_apis/build/builds/97/artifacts?artifactName=RemoteForkCP&api-version=4.1&%24format=zip" -o app.zip \
  && unzip app.zip && rm app.zip \
  && chmod a+x /RemoteForkCP/RemoteForkCP \
  && sh -c "/RemoteForkCP/RemoteForkCP &" && sleep 3 \
  && kill `ps ax | grep "/RemoteForkCP/RemoteForkCP" | grep -v "grep" | awk '{print $1}'` \
  && cp /RemoteForkCP/Settings.json /RemoteForkCP/Settings.old.json \
  && cat /RemoteForkCP/Settings.old.json | sed 's/"Port": 8027,/"Port": '$PORT',/' > /RemoteForkCP/Settings.json

CMD /RemoteForkCP/RemoteForkCP