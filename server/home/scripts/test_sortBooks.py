#!/usr/bin/env python3
from unittest import main, TestCase

import sortBooks

class TestsortBooks(TestCase):
    def test_all_allowed(self):
        author = 'George_Orwell'
        title = 'Animal_Farm'
        self.assertEqual(
                f'{author}/{title}.epub', sortBooks.new_fpath(author, title)[1])

    def test_long_fname_shortened(self):
        author = 'George_Orwell'
        title = 'Animal_Farm_but_a_really_long_title_that_will_cause_the_file_name_to_extend_past_the_250_character_limit_that_some_OS_may_have_so_I_need_to_write_a_test_to_test_for_the_file_name_limit_so_that_I_dont_fail_to_move_books_that_have_long_titles_as_file_names'
        fpath = sortBooks.new_fpath(author, title)[1]
        newfname = fpath.split('/')[-1]
        self.assertEqual(255, len(newfname))

        noext = newfname[:-5][:250]
        withext = f'{noext}.epub'
        self.assertEqual(withext, newfname)

if __name__ == '__main__':
    main()
