TEST_IMAGE_TEMPLATE = """
FROM {BASE_IMAGE}

WORKDIR /app_test
COPY --from=test_root --chmod=755 . /app_test

"""

def generate_test_dockerfile(image_name, tag='latest', env_vars=None, scripts=('test.sh',)):
    env_vars = env_vars or {}

    dockerfile_str = TEST_IMAGE_TEMPLATE.format(BASE_IMAGE=f"{image_name}:{tag}")

    dockerfile_str += "\n".join(f"ENV {key}={value}" for key, value in (env_vars or {}).items())
    dockerfile_str += "\n"

    dockerfile_str += "\n".join(f"RUN /app_test/{script}" for script in scripts)
    dockerfile_str += "\n"

    return dockerfile_str
