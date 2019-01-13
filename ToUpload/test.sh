#!/usr/bin/env bash
export timestamp=$(date +%Y%m%d_%H%M%S) && \
export volume_path=/opt/jmeter && \
export jmeter_path=/mnt/jmeter && \
docker run \
  --net jmeter_default \
  --volume "${volume_path}":${jmeter_path} \
  emregundogdu/jmeter:v6 \
  -n -X -Jclient.rmi.localport=7000 -Jserver.rmi.ssl.disable=true \
  -R slave-1,slave-2,slave-3,slave-4,slave-5,slave-6,slave-7,slave-8,slave-9,slave-10 \
  -t ${jmeter_path}/test.jmx\
  -l ${jmeter_path}/tmp/result_${timestamp}.jtl \
  -j ${jmeter_path}/tmp/jmeter_${timestamp}.log \
  -G sub_user=150 pub_user=150 pub_payload_length=8000 pub_loop=60
