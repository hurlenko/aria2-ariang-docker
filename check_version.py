from pkg_resources import parse_version
import requests as r
import os

MY_REPO = (
    f"https://api.github.com/repos/{os.environ['GITHUB_REPOSITORY']}/releases/latest"
)
TARGET_REPO = f"https://api.github.com/repos/mayswind/AriaNg/releases/latest"


def compare(source_url, target_url):
    source_version = r.get(source_url).json().get("tag_name", "0.0.0")
    target_version = r.get(target_url).json().get("tag_name", "0.0.0")
    if parse_version(source_url) < parse_version(target_url):
        print(target_version)


compare(MY_REPO, TARGET_REPO)
