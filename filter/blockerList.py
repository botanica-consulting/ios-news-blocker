import json
import re

# https://webkit.org/blog/4062/targeting-domains-with-content-blockers/


def main():
    entries = []
    for domain in open("domains.txt", "r").readlines():
        entries.append(
            {
                "action": {"type": "block"},
                "trigger": {
                    "url-filter": "^https?://+(www\.)"
                    + re.escape(domain.strip())
                    + ".*",
                    "url-filter-is-case-sensitive": True,
                },
            }
        )
    with open("blockerList.json", "w") as w:
        json.dump(entries, w)


if __name__ == "__main__":
    main()
