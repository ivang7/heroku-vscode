FROM coresystem/acestream

ENV PORT=6878
ENV CACHETIME=1800
ENV KEY=SZGHqCMt

RUN apt-get install -y socat \
  && echo '#!/bin/bash' >> run.sh \
  && echo 'if ! [[ "$PORT" == "6878" ]]; then' >> run.sh \
  && echo '  socat tcp-l:$PORT,fork,reuseaddr tcp:127.0.0.1:6878 &' >> run.sh \
  && echo 'fi' >> run.sh \
  && echo './start.sh $KEY $CACHETIME' >> run.sh \
  && chmod a+x run.sh

CMD /run.sh
