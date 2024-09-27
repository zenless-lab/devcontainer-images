import pathlib

from invoke import task

from utils import generate_test_dockerfile, convert_str_to_dict


@task
def build(c, image_name, tag='latest'):
    source_path = f"images/{image_name}/src"
    c.run(f'docker buildx build -t {image_name}:{tag} {source_path}')



@task(iterable=['scripts', 'env_var'])
def test(c, image_name, tag='latest', script=None, env_var=None):
    script = script or ['test.sh']
    env_var = env_var or []

    image_root = pathlib.Path(f"images/{image_name}")
    image_test_path = image_root / "tests"

    env_vars_dict = convert_str_to_dict(env_var) if env_var else {}

    c.run(
        'docker buildx build '
        '--no-cache '
        f'--build-arg BASE_IMAGE={image_name}:{tag} '
        '--output type=cacheonly '
        f'--build-context test_root={image_test_path.absolute()} '
        f'- <<EOF\n{generate_test_dockerfile(image_name, tag, env_vars=env_vars_dict, scripts=script)}\nEOF'
        )
