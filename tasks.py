from invoke import task

from utils import get_image_src_path, get_image_test_path, get_test_image_path

NAME_SPACE = "ryanminato"


@task
def build(c, image_name, force_name=None, tag="latest", namespace=NAME_SPACE):
    source_path = get_image_src_path(image_name)
    image_tag = force_name or f"{namespace}/{image_name}:{tag}"

    c.run(f"docker buildx build -t {image_tag} {source_path}")


@task
def test(c, image_name,  force_name=None, tag="latest", namespace=NAME_SPACE, verbose=False):
    image_test_path = get_image_test_path(image_name)
    test_image_path = get_test_image_path()

    image_tag = force_name or f"{namespace}/{image_name}:{tag}"

    c.run(
        "docker buildx build "
        "--output type=cacheonly "
        f"--build-arg IMAGE={image_tag} "
        f"--build-arg VERBOSE={1 if verbose else 0} "
        f"--build-context test_root={image_test_path.absolute()} "
        f"{test_image_path}"
        )
