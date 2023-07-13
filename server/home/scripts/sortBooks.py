#!/usr/bin/env python3
"""Sort book files.

Sorts book files into the following structure:

    Books
    |_Author
    | |_Book1.epub
    | |_Book1.flac
    | |_Book2 [audio] [flac]
    | | |_Chapter1.flac
    | | |_Chapter2.flac
    | |_Book2 [audio] [mp3]
    | | |_Chapter1.mp3
    | | |_Chapter2.mp3
    | |_Book2 [text]
    |   |_Book2.epub
    |   |_cover.png
    |   |_metadata.opf
    |_Author2
      |_Book21 [text]
        |_Book21.epub
        |_cover.png
        |_metadata.opf"""

import argparse
from os import getcwd, path, rename, walk
from pathlib import Path
import re
from xml.etree import ElementTree as etree
import zipfile

def new_fpath(author, title):
    author = _sanitize(author)
    title = _sanitize(title)

    if len(title) > 250:
        oldtitle = title
        title = title[:250]
        print(f'Title was too long. Shortened {oldtitle} to {title}')

    return (author, f"{author}/{title}.epub")

def _epub_info(fname):
    def xpath(element, path):
        return element.find(
            path,
            namespaces={
                "n": "urn:oasis:names:tc:opendocument:xmlns:container",
                "pkg": "http://www.idpf.org/2007/opf",
                "dc": "http://purl.org/dc/elements/1.1/",
            },
        )

    # prepare to read from the .epub file
    zip_content = zipfile.ZipFile(fname)

    # find the contents metafile
    cfname = xpath(
            etree.fromstring(zip_content.read("META-INF/container.xml")),
            "n:rootfiles/n:rootfile[@full-path]",
    ).get("full-path")

    # grab the metadata block from the contents metafile
    metadata = xpath(
        etree.fromstring(zip_content.read(cfname)), "pkg:metadata"
    )

    # repackage the data
    return {
        s: xpath(metadata, f"dc:{s}").text
        for s in ("title", "language", "creator", "date", "identifier")
        if xpath(metadata, f"dc:{s}") is not None
    }

def _sanitize(s):
    return re.sub(r'[^\w._-]', "_", s.strip(), flags=re.ASCII)

def _parse_args():
    dir_help = "The directory to scan"
    parser = argparse.ArgumentParser()
    parser.add_argument("dir", default=getcwd(), help=dir_help)
    return parser.parse_args()

if __name__ == "__main__":
    args = _parse_args()

    for root, dirs, files in walk(args.dir):
        for fname in files:
            print(fname)
            if fname[-5:] != ".epub":
                print(f"Not an EPUB file. Skipping {fname}")
                continue

            fpath = path.join(root, fname)
            info = _epub_info(fpath)

            print(info)
            author_key = "creator"
            if author_key not in info:
                print(f"No author for {fname}. Skipping")
                continue

            author = info[author_key].split(",")[0]
            title = info["title"]
            (author, newfpath) = new_fpath(author, title)

            Path(author).mkdir(exist_ok=True)
            if newfpath not in fpath:
                print(f"Moving {fname} to {newfpath}\n")
                rename(fpath, newfpath)
