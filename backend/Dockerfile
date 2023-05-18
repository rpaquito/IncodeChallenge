
FROM python:3.8 AS builder

# install dependencies
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# second unnamed stage
FROM python:3.8-slim
WORKDIR /code

# copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local /root/.local
COPY ./src .

# update PATH environment variable
ENV PATH=/root/.local:$PATH

EXPOSE 80

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]