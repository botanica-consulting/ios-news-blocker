import json
import re
import os
import sys

# https://webkit.org/blog/4062/targeting-domains-with-content-blockers/


def rewrite(i, o):
    entries = []
    domains = [re.escape(domain.strip()) for domain in open(i, "r").readlines()]

    regex = "^https?://"
    regex1 = regex + "[wm\.]*"
    regex2 = regex + "news\."

    for d in domains:
        entries.extend(
            [
                {
                    "action": {"type": "block"},
                    "trigger": {
                        "url-filter": regex1 + d,
                        "url-filter-is-case-sensitive": True,
                    },
                },
                {
                    "action": {"type": "block"},
                    "trigger": {
                        "url-filter": regex2 + d,
                        "url-filter-is-case-sensitive": True,
                    },
                },
            ]
        )
    with open(o, "w") as w:
        json.dump(entries, w)


def main():
    try:
        i = os.path.join(sys.argv[1], "filter/domains.txt")
        o = os.path.join(sys.argv[2], "filter/blockerList.json")
        print(f"Attempting {i} -> {o}")
        rewrite(i, o)
        print("Done!")
    except Exception as e:
        import traceback

        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
