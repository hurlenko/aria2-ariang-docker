import requests as r
import os

MY_REPO = (
    f"https://api.github.com/repos/{os.environ['GITHUB_REPOSITORY']}/releases/latest"
)
TARGET_REPO = f"https://api.github.com/repos/mayswind/AriaNg/releases/latest"


def compare(source_url, target_url):
    source_version = r.get(source_url).json().get("tag_name", "0.0.0")
    target_version = r.get(target_url).json().get("tag_name", "0.0.0")
    if source_version == "0.0.0":
        print('1.1.2')
    elif source_version != target_version:
        print(target_version)


compare(MY_REPO, TARGET_REPO)
