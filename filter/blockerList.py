import json
import re
import os

# https://webkit.org/blog/4062/targeting-domains-with-content-blockers/


def main():
    entries = []
    for domain in open(
        os.path.join(os.environ["SRCROOT"], "filter/domains.txt"), "r"
    ).readlines():
        entries.append(
            {
                "action": {"type": "block"},
                "trigger": {
                    "url-filter": "^https?://+(www\.|news\.|m\.)"
                    + re.escape(domain.strip())
                    + ".*",
                    "url-filter-is-case-sensitive": True,
                },
            }
        )
    with open(
        os.path.join(os.environ["DERIVED_FILE_DIR"], "filter/blockerList.json"), "w"
    ) as w:
        json.dump(entries, w)


if __name__ == "__main__":
    main()
