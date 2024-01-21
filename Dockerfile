# start by pulling the python image
FROM python:3.10.1-slim

RUN apt-get update && apt-get install build-essential -y

# copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install --no-cache-dir -r requirements.txt

# copy every content from the local file to the image
COPY . /app

RUN FLASK_APP=core/server.py flask db upgrade -d core/migrations/

RUN chmod +x run.sh

# run tests
RUN python -m pytest

# configure the container to run in an executed manner
ENTRYPOINT ["./run.sh"]


CMD ["bash"]