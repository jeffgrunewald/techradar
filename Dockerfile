FROM node:7.10.0

ARG cache_date=2017-05-28

ARG doc_title="Tech Radar ${cache_date}"
ARG company_url='companyX'

COPY app /opt/app 
COPY radar_data.csv /opt/

WORKDIR /opt

RUN npm install -g csvtojson@1.1.5 \
 && csvtojson radar_data.csv > radar_data.json \
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
      node_version=7.3.0
