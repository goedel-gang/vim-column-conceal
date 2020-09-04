Vim paraphernalia to enable one to smoothly conceal and unconceal extraneous
characters in a tab-separated file.

Development commissioned by micans, and based on the answer to
[this question](https://stackoverflow.com/questions/8094823/how-to-create-a-strictly-columnar-display-in-vim-for-a-tab-separated-file).

It can't fill out a cell that's too short. A long line of text not containing
the separation character is obviously just treated as a big cell.

| Keybinding | Consequence                                          |
|:---------- |:---------------------------------------------------- |
| `yo<Tab>`  | enables tab folding                                  |
| `yox`      | set tab width                                        |
| `y<`       | decrease width                                       |
| `y>`       | increase width                                       |
| `yoc`      | toggles concealcursor: current line is not concealed |
| `yo,`      | toggles separation character between `<Tab>` and `,` |

There is a sample file in this repository. If you navigate to this directory and
type `make`, an instance of Vim will launch that loads `column_conceal.vim`, and
opens sample.txt. `make clean_test` tries to do the same with `vim --clean`,
ignoring your vimrc.

The mappings `y>` and `y<` allow you to type `y>>>>>` or `y<<>>>>>`, for
example. This mode can be escaped with `<Esc>`, or in fact any key other than
`>` or `<`.
