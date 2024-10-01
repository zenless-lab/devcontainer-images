import pathlib

DEFAULT_IMAGE_DIR = "images"
DEFAULT_TEST_DIR = "tests"
DEFAULT_SRC_DIR = "src"

TEST_DOCKER_IMAGE = pathlib.Path(__file__).parent / "test"



def get_image_root(image_name):
    return pathlib.Path(DEFAULT_IMAGE_DIR) / image_name


def get_image_test_path(image_name, test_dir=DEFAULT_TEST_DIR):
    return get_image_root(image_name) / test_dir


def get_image_src_path(image_name, src_dir=DEFAULT_SRC_DIR):
    return get_image_root(image_name) / src_dir


def get_test_image_path():
    return TEST_DOCKER_IMAGE
