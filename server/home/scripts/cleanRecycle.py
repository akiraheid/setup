"""Delete files in the #recycle directory that exist in the current directory.

Launch this script at `dir/` to search `dir/#recycle` for files that exist in
`dir/` to free up space."""

from hashlib import sha256
from os import path, remove, walk
from sys import exit

if not path.isdir('#recycle'):
    print('No "#recycle/" found. Exiting.')
    exit(0)

def get_digest(file_name):
    digest = None
    with open(file_name, 'rb') as fp:
        digest = sha256(fp.read()).hexdigest()

    return digest

print('Parsing recycle files in #recycle/ ...')
recycle_files = {}
for root, dirs, files in walk('#recycle'):
    for file_name in files:
        file_path = path.join(root, file_name)
        digest = get_digest(file_path)
        recycle_files[digest] = file_path

print(f'Found {len(recycle_files)} files in #recycle/')

print('Indexing other files...')
root_files = {}
for root, dirs, files in walk('.'):
    if root.startswith('./#recycle'):
        continue

    for file_name in files:
        file_path = path.join(root, file_name)
        digest = get_digest(file_path)
        root_files[digest] = file_path

print(f'Found {len(root_files)} other files')

for digest in recycle_files:
    if digest in root_files:
        print(f'{recycle_files[digest]} is duplicate of {root_files[digest]}. Deleting')
        #remove(recycle_files[digest])
