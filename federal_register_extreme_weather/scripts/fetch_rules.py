#!/usr/bin/env python3
"""Fetch up to N rules and proposed rules published in a given year by a given
agency from the Federal Register API, save the raw response unchanged, and
write a request-metadata file next to it.

Usage:
    python3 scripts/fetch_rules.py --agency environmental-protection-agency [--year 2025] [--limit 100]

Agency slugs come from the Federal Register's agency list:
    https://www.federalregister.gov/api/v1/agencies
(use the "slug" field, e.g. "environmental-protection-agency").
"""
import argparse
import csv
import json
import urllib.parse
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

API_BASE = "https://www.federalregister.gov/api/v1/documents.json"
SORT_ORDER = "newest"  # publication_date, descending

FIELDS = ["document_number", "publication_date", "agency_names", "title", "abstract", "html_url"]


def build_params(agency: str, year: int, limit: int) -> list[tuple[str, str]]:
    return [
        ("conditions[type][]", "RULE"),
        ("conditions[type][]", "PRORULE"),
        ("conditions[publication_date][gte]", f"{year}-01-01"),
        ("conditions[publication_date][lte]", f"{year}-12-31"),
        ("conditions[agencies][]", agency),
        ("per_page", str(limit)),
        ("order", SORT_ORDER),
    ]


def fetch(url: str) -> bytes:
    with urllib.request.urlopen(url) as resp:
        return resp.read()


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--agency", required=True, help="Federal Register agency slug, e.g. environmental-protection-agency")
    parser.add_argument("--year", type=int, default=2025, help="Publication year (default: 2025)")
    parser.add_argument("--limit", type=int, default=100, help="Max documents to fetch, max 100 (default: 100)")
    args = parser.parse_args()

    if not 1 <= args.limit <= 100:
        parser.error("--limit must be between 1 and 100")

    params = build_params(args.agency, args.year, args.limit)
    url = f"{API_BASE}?{urllib.parse.urlencode(params)}"

    fetched_at = datetime.now(timezone.utc)
    raw_bytes = fetch(url)
    payload = json.loads(raw_bytes)

    data_dir = Path(__file__).resolve().parent.parent / "data"
    data_dir.mkdir(exist_ok=True)
    stamp = fetched_at.strftime("%Y%m%dT%H%M%SZ")
    basename = f"fr_{args.agency}_{args.year}_{stamp}"

    raw_path = data_dir / f"{basename}.json"
    raw_path.write_bytes(raw_bytes)

    meta_path = data_dir / f"{basename}.request.txt"
    meta_path.write_text(
        "Full request URL:\n"
        f"{url}\n\n"
        "Parameters:\n"
        + "\n".join(f"  {k} = {v}" for k, v in params)
        + "\n\n"
        f"Fetched at (UTC): {fetched_at.isoformat()}\n"
    )

    results = payload.get("results", [])
    csv_path = data_dir / f"{basename}.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        for doc in results:
            agency_names = "; ".join(a["name"] for a in doc.get("agencies", []))
            writer.writerow({
                "document_number": doc.get("document_number", ""),
                "publication_date": doc.get("publication_date", ""),
                "agency_names": agency_names,
                "title": doc.get("title", ""),
                "abstract": doc.get("abstract") or "",
                "html_url": doc.get("html_url", ""),
            })

    total_matched = payload.get("count", len(results))
    no_abstract = sum(1 for doc in results if not doc.get("abstract"))

    print(f"Documents returned: {len(results)} (of {total_matched} total matching the query)")
    print(f"Sort order: {SORT_ORDER} (publication_date, most recent first)")
    print(f"Documents with no abstract: {no_abstract}")
    print(f"Raw response saved to:   {raw_path}")
    print(f"Request metadata saved to: {meta_path}")
    print(f"Extracted fields saved to: {csv_path}")


if __name__ == "__main__":
    main()
