set -x

PYTHON_VERSION=$(python3 --version)

if [ $? -ne 0 ]
then
    echo "error: python3 is not installed"
    exit 1
fi

echo "Found ${PYTHON_VERSION}"

python3 -m venv .venv

if [ $? -ne 0 ]
then
    echo "error: failed to create virtual env"
    exit 1
fi

source .venv/bin/activate

if [ $? -ne 0 ]
then
    echo "error: failed to activate virtual environment"
    exit 1
fi

pip install -U pip setuptools

if [ $? -ne 0 ]
then
    echo "error: failed to update pip and setuptools"
    exit 1
fi

pip install sqlalchemy mysql-connector-python "fastapi[standard]" boto3 aws-secretsmanager-caching

if [ $? -ne 0 ]
then
    echo "error: failed to install dependencies"
    exit 1
fi

exit 0
