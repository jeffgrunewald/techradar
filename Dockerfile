FROM node:7.10.0

ARG cache_date=2017-05-28

ARG doc_title="Tech Radar ${cache_date}"
ARG company_url='companyX'

COPY app /opt/app 
COPY radar_data.csv /opt/

WORKDIR /opt

RUN cat radar_data.csv \
 | awk -F, '{ $2 = ($2 == "ring" ? "0"$2 : $2) } \
            { $2 = ($2 == "adopt" ? "1"$2 : $2) } \
            { $2 = ($2 == "trial" ? "2"$2 : $2) } \
            { $2 = ($2 == "assess" ? "3"$2 : $2) } \
            { $2 = ($2 == "hold" ? "4"$2 : $2) } 1' OFS=, \
 | sort -t, -k2 \
 | sed -e 's/0ring/ring/g' \
       -e 's/1adopt/adopt/g' \
       -e 's/2trial/trial/g' \
       -e 's/3assess/assess/g' \
       -e 's/4hold/hold/g' > radar_parsed.csv

RUN npm install -g csvtojson@1.1.5 \
 && csvtojson radar_parsed.csv > radar_data.json \
 && sed -i -e '/PLACEHOLDER_VALUE/{r radar_data.json' -e 'd;}' app/src/index.html \
 && sed -i -e "s/Tech Radar/${doc_title}/g" app/src/util/factory.js \
 && sed -i -e "s/company-name/${company_url}/" app/src/graphing/radar.js

WORKDIR /opt/app

RUN npm install

COPY Dockerfile /opt/Dockerfile-techradar
COPY README.md /opt/README-techradar.md

CMD ["npm", "run", "dev"]

LABEL cache_date=${cache_date} \
      maintainer=jeff@grunewalddesign.com \
      node_version=7.10.0
