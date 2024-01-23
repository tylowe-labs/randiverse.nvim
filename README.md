# randiverse.nvim💥

Tired of raking your brain trying to generate 'random' text for sample/test cases (and secretly leaking your life details😆)?? Randiverse—the "Random Universe"—is a flexible, configurable nvim plugin that can generate random text for a variety of scenarios including ints, floats, names, dates, lorem ipsum, emails, and more! Created by a recent VScode —> NVIM convert and inspired by the simple, albeit handy, "Random Everything" VScode extension.

**Insert Demo Video Clip Here**

Author: [Tyler Lowe](https://github.com/ty-labs)

License: [MIT License](https://github.com/ty-labs/randiverse.nvim/blob/main/LICENSE)

# Requirements🔒

randiverse.nvim was built w/ minimal dependencies using standard Lua and Neovim:

- [Neovim 0.8+](https://github.com/neovim/neovim/releases)
- [Lua 5.1.5+]()

# Installation📦

Install randiverse.nvim using your favorite plugin manager, then call `require("randiverse").setup()`

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "ty-labs/randiverse.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("randiverse").setup({
            -- Custom configurations here, or leave empty to use defaults
        })
    end
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
    "ty-labs/randiverse.nvim",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("randiverse").setup({
            -- Custom configuration here, or leave empty to use defaults
        })
    end
})
```

# Usage💻

## The Basics

Generally, the plugin functionality is accessed via the registered editor command 'Randiverse'. The editor command 'Randiverse' also requires a command (int, float, name, etc.) with possible command flags which tell Randiverse what random text to generate. Note that both 'Randiverse' and its commands have auto-completion as demonstrated below. The Randiverse access pattern will look like the following:

`:Randiverse <command> <optional command flags>`

**Insert Demo Video (opening and auto-completion features...)**

Command flags can either be short or long hand but are inputted as `flag value` NOT `flag=value` or simply boolean flag. Each Randiverse command also comes with a default keymap that is prefixed by `<leader>r...` and maps to the default random text generation for the command. 

## int

`:Randiverse int <optional int flags>`

Picks a random int from within a range. The default range is \[1-100\].

| Flag | Description | Value |
|:-----|:------------|:------|
| `-s/--start start` | Set the start for the range. <br/>Example: '`-s 50`' would change the range to \[50-100\]. | Integer |
| `-l/--stop stop` | Set the stop for the range. <br/>Example: '`-S 70`' would change the range to \[0-70\]. | Integer |

Default Keymap: `<leader>ri`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        int: {
            default_start = <int>, --Configuration here, or leave empty to use default (1)
            default_stop = <int>, --Configuration here, or leave empty to use default (100)
        }
    }
}
```

## float

`:Randiverse float <optional float flags>`

Picks a random float from within a range. The default range is \[1-100\] w/ the output having two decimal places.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-s/--start start` | Set the start for the range. <br/>Example: '`-s 50`' would change the range to \[50-100\]. | Integer |
| `-l/--stop stop` | Set the stop for the range. <br/>Example: '`-S 70`' would change the range to \[0-70\]. | Integer |
| `-d/--decimals decimals` | Set the # of decimal places in the output. <br/>Example: '`-d 4`' would change output to `xx.xxxx`. | Non-negative Integer |

Default Keymap: `<leader>rf`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        int: {
            default_start = <int>, --Configuration here, or leave empty to use default (1)
            default_stop = <int>, --Configuration here, or leave empty to use default (100)
            default_decimals = <int>, -- Configuration here, or leave empty to use default (2)
        }
    }
}
```

## name

`:Randiverse name <optional name flags>`

Generates a random name. The default is a full name (first and last) unless flags are set. The random name is generated via random selection from a static first + last name corpuses that Randiverse comes bundled with & are configurable.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-f/--first` | Return the first name component. <br/>Example: '`-f` would toggle the output to include a first name (plus any other toggled components). | None |
| `-l/--last` | Return the last name component. <br/>Example: '`-l`' would toggle the output to include a last name (plus any other toggled components). | None |

Default Keymap: `<leader>rn`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        name: {
            FIRST = <file_path>, --Configuration here, or leave empty to use default ('names_first.txt'; path relative from `data.ROOT`)
            LAST = <file_path>, --Configuration here, or leave empty to use default (included 'names_last.txt'; path relative from `data.ROOT`)
        }
    }
}
```

## word

`:Randiverse word <optional word flags>`

Generates a random word(s). The default number of returned random words is 1. The random words are generated via random selection from a corpus. Corpuses are configured in the `data.word.corpuses` map which maps: corpus name —> corpus relative path from the `data.ROOT`. By default, Randiverse comes bundled and configured with a 'short', 'medium', and 'long' corpuses available; 'medium' is the default corpus for random word generation.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-a/--all`| Use all of the configured corpuses to select a random word. <br/>Example: '`-a`' would toggle output s.t. `<word>` could be from 'short', 'medium', or 'long' corpus. | None |
| `-c/--corpus corpus` | Set the corpus from configured corpuses to select random word from. <br/>Example: '`-c long`' would change output `<word>` to be from 'long' corpus. | String; Key in '`data.word.corpuses`' map |
| `-l/--length length` | Set the # of words to return (separated by spaces). <br/>Example: '`-l 3`' would change output to `<word> <word> <word>` where words are from the 'medium' (default) corpus. | Positive Integer |

Default Keymap: `<leader>rn`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        word: {
            corpuses = {
                <corpus_name>: <file_path>, -- Configuration here, or leave empty to use default
                ...
            },
            default_corpus = <key_in_corpuses>, --Configuration here, or leave empty to use default (included 'medium')
            default_length = <int>, --Configuration here, or leave empty to use default (1)
        }
    }
}
```

## lorem

`:Randiverse lorem <optional lorem flags>`

Generates a block of random lorem ipsum text. The default block has a length of 100 words, 'mixed-short' sentence length ranging from \[5, 30\] words/sentence, and a comma probability of 10%. The lorem ipsum block is generated by randomly selecting words from a corpus. Corpuses are configured in the `data.lorem.corpuses` map which maps: corpus name —> corpus relative path from the `data.ROOT`. By default, Randiverse comes bundled and configured with 'lorem' available; 'lorem' is the default corpus for random word generation. Words up to the specified/default length are included and sentences are created based on the selected 'sentence-length'. Sentence lengths are configured in the `data.lorem.sentence_lengths` map which maps: sentence length name —> { sentences lower bound, sentences upper bound}. 

| Flag | Description | Value |
|:-----|:------------|:------|
| `-a/--all` | Use all of the configured corpuses to select a random word. <br/>Example: '`-a`' would toggle output s.t. `<word>` could be from 'lorem' corpus. | None |
| `-c/--corpus corpus` | Set the corpus from configured corpuses to select random word from. <br/>Example: '`-c alt-lorem`' would change output `<word>` to be from the 'alt-lorem' corpus. | String; Key in '`data.word.corpuses`' map |
| `-l/--length length` | Set the # of words to return (separated by spaces). <br/>Example: '`-l 200`' would change the output lorem block to have a length ~200 words. | Positive Integer |
| `-C/--comma-property` | Set the comma property for the generated lorem ipsum block. This is the likelihood that a comma will occur for each word after 3 words past last comma/period. <br/>Example: '`-C 0.5`' would change the | Decimal \[0-1\] |
| `-s/--sentence-length` | Set the sentence lengths for the lorem ipsum block from configured sentence lengths. <br/>Example: '`-s long`' would change the output lorem ipsum block to have sentences of length ranging \[40-60\] words. | String; Key in '`data.lorem.sentence_lengths`' map |

Default Keymap: `<leader>rl`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        lorem: {
            corpuses = {
                <corpus_name>: <file_path>, -- Configuration here, or leave empty to use default
                ...
            },
            sentence_lengths = {
                ...
            },
            default_corpus = <key_in_corpuses>, --Configuration here, or leave empty to use default ('medium')
            default_sentence_length = <key_in_sentence_lengths>, --Configuration here, or leave empty to use default ('mixed-short')
            default_comma_property = <decimal>, --Configuration here, or leave empty to use default (0.1)
            default_length = <int>, --Configuration here, or leave empty to use default (1)
        }
    }
}
```

## country

Dummy Text

## datetime

Dummy Text

## email

Dummy Text

## url

Dummy Text

## uuid

Dummy Text

## ip

Dummy Text

## hexcolor

Dummy Text

# Configuration🏗️

Dummy Text

# Contributing✍️

I'm always looking for new random text commands to add as well as more flags and enhancements. Feel free to mark an issue or try handling it yourself!

# Shoutouts📢

- [Random Everything](https://github.com/helixquar/randomeverything)         —> Original inspiration as a revamped version of the VScode extension.
- [Random Text](https://github.com/kimpettersen/random-sublime-text-plugin)  —> Sublime random text generator which Random Everything was based on.
- [Lorem Ipsum Generator](https://github.com/derektata/lorem.nvim)           —> Inspiration for building the Lorem Ipsum generator feature.
- [nvim-surround](https://github.com/kylechui/nvim-surround/tree/main)       —> General structure for writing nvim plugins.
- If you like this project consider a [star⭐](https://github.com/ty-labs/randiverse.nvim/tree/main) to show your support!
