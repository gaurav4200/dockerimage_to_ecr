FROM node:14

WORKDIR /usr/src/app


COPY script.py /app/script.py
RUN npm install


EXPOSE 3000
CMD ["python", "script.py"]

