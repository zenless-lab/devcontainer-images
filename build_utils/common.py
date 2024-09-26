def convert_str_to_dict(raw_strings: list[str]) -> dict[str, str]:
    return dict([string.split('=') for string in raw_strings])
