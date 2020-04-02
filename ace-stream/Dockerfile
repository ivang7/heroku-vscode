FROM coresystem/acestream

ENV PORT=6878
ENV CACHETIME=1800
ENV KEY=SZGHqCMt

RUN apt-get install -y socat \
  && cat /start.sh | sed 's/start-engine/start-engine --http-port 80/' > start2.sh \
  && cat /start2.sh > /start.sh && rm /start2.sh \
  && echo '#!/bin/bash' >> run.sh \
  && echo 'if ! [[ "$PORT" == "80" ]]; then' >> run.sh \
  && echo '  socat tcp-l:$PORT,fork,reuseaddr tcp:127.0.0.1:80 &' >> run.sh \
  && echo 'fi' >> run.sh \
  && echo './start.sh $KEY $CACHETIME' >> run.sh \
  && chmod a+x run.sh

CMD /run.sh
