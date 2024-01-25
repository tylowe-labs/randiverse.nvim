# randiverse.nvim💥

Tired of raking your brain trying to generate "random" text for sample/test cases (and secretly leaking your life details😆)?? Randiverse—the 'Random Universe'—is a flexible, configurable nvim plugin that can generate random text for a variety of scenarios including ints, floats, names, dates, lorem ipsum, emails, and more! Created by a recent VScode —> NVIM convert and inspired by the simple, albeit handy, VScode extension called "Random Everything". It is both a port and an enhancement of the extension's feature set, tailored for the nvim environment.

Disclaimer: I've had discussions w/ some people in the nvim community and am well aware that some of this could be done via Lua Snips or a similar snippet engine. However, for the more complex commands it was helpful to have my own library + I learned a lot about Lua + nvim by doing this.

**Insert Demo Video Clip Here**

Author: [Tyler Lowe](https://github.com/ty-labs)

License: [MIT License](https://github.com/ty-labs/randiverse.nvim/blob/main/LICENSE)

# Requirements🔒

randiverse.nvim is built w/ zero dependencies outside of the default Neovim installation:

- [Neovim 0.8+](https://github.com/neovim/neovim/releases)

# Installation📦

randiverse.nvim can be installed using your favorite plugin manager, then call `require("randiverse").setup()`:

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

## Basics

The general access pattern for Randiverse functionality looks like the following:

`:Randiverse <Randiverse Command> <Optional Randiverse Command Flags>`

First, the plugin functionality is accessed through the over-arching editor command 'Randiverse'. Second, the editor command requires a 'Randiverse command': this command tells Randiverse which type of random text to generate and is how Randiverse functionality is logically separated (int, float, name, lorem, etc.). Lastly, optional Randiverse command flags are passed which customize the behavior of the random text generator. Command flags can either be short or long hand (`-d`/`--dummy-flag`) but flags that require a value must be inputted as `flag value` NOT `flag=value`. Flag details are listed under each command's help doc. Note that auto-completion for commands is available.

Each Randiverse command also comes with a default registered keymap that is prefixed by `<leader>r...` and executes the default random text generator. Ex: `:Randiverse int` —> `<leader>ri`. These keymaps and their execution values can be configured + disabled.

**Insert Demo Video (opening and auto-completion features...)**

## int

`:Randiverse int <optional int flags>`

Picks a random int from within a range. The default range is \[1-100\].

| Flag | Description | Value |
|:-----|:------------|:------|
| `-s/--start start` | Set the start for the range. <br/>Example: '`-s 50`' would change the range to \[50-100\] where 100 is the default stop. | Integer |
| `-l/--stop stop` | Set the stop for the range. <br/>Example: '`-S 50`' would change the range to \[0-50\] where 0 is the default start. | Integer |

Default Keymap: `<leader>ri`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        int: {
            default_start = <int>, --Configuration here, or leave empty to use default: 1
            default_stop = <int>, --Configuration here, or leave empty to use default: 100
        }
    }
}
```

## float

`:Randiverse float <optional float flags>`

Picks a random float from within a range. The default range is \[1-100\] with the output having two decimal places.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-s/--start start` | Set the start for the range. <br/>Example: '`-s 50`' would change the range to \[50-100\] where 100 is the default stop. | Integer |
| `-l/--stop stop` | Set the stop for the range. <br/>Example: '`-S 50`' would change the range to \[0-50\] where 0 is the default start. | Integer |
| `-d/--decimals decimals` | Set the # of decimal places in the output. <br/>Example: '`-d 4`' would change output to `xx.xxxx`. | Non-negative Integer |

Default Keymap: `<leader>rf`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        int: {
            default_start = <int>, --Configuration here, or leave empty to use default: 1
            default_stop = <int>, --Configuration here, or leave empty to use default: 100
            default_decimals = <int>, -- Configuration here, or leave empty to use default: 2
        }
    }
}
```

## name

`:Randiverse name <optional name flags>`

Generates a random name. The default is a full name (first and last) unless flags are set. The random name is created via random selection from static first + last name corpus files that Randiverse comes bundled with & are configurable.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-f/--first` | Return the first name component. <br/>Example: '`-f` would toggle the output to include a random first name (plus any other toggled components). | None |
| `-l/--last` | Return the last name component. <br/>Example: '`-l`' would toggle the output to include a random last name (plus any other toggled components). | None |

Default Keymap: `<leader>rn`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        name: {
            FIRST = <file_path>, --Configuration here, or leave empty to use default: 'names_first.txt'; path relative from `data.ROOT`
            LAST = <file_path>,  --Configuration here, or leave empty to use default: 'names_last.txt'; path relative from `data.ROOT`
        }
    }
}
```

## word

`:Randiverse word <optional word flags>`

Generates a random word(s). The default number of returned random words is 1. The random word(s) are created via random selection from a corpus. Corpuses are configured in the dynamic `data.word.corpuses` map which maps: corpus name —> corpus relative file path from `data.ROOT`. By default, Randiverse comes bundled with  'short', 'medium', and 'long' corpuses available; 'medium' is the default corpus for random word generation.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-a/--all`| Use all of the configured word corpuses to select a random word. <br/>Example: '`-a`' would toggle output s.t. `<word>` could be from 'short', 'medium', or 'long' corpus. | None |
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
                ... (more corpus —> file_path mappings) ...
            },
            default_corpus = <key>, --Configuration here, or leave empty to use default: 'medium'; key in `data.word.corpuses`
            default_length = <int>, --Configuration here, or leave empty to use default: 1
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

`:Randiverse country <optional country flags>`

Generates a random country. The default output is a standard country name. The random country is generated via random selection from static country corpus files that Randiverse comes bundled with & are configurable.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-c/--code enum` | Set the code format for the returned country. <br/>Example: '`-c alpha-2` would change the output to return a country in `AA` format, such as `US`. | 2, 3, alpha-2, alpha-3 |
| `-n/--numeric` | Return the country in numeric format. <br/>Example: '`-n`' would toggle the output to return a country in `XXX` format, such as `120`. | None |

Default Keymap: `<leader>rn`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        country: {
            COUNTRIES = <file_path>, --Configuration here, or leave empty to use default ('countries.txt'; path relative from `data.ROOT`)
            ALPHA2 = <file_path>, --Configuration here, or leave empty to use default ('countries_alpha2.txt'; path relative from `data.ROOT`)
            ALPHA3 = <file_path>, --Configuration here, or leave empty to use default ('countries_alpha3.txt'; path relative from `data.ROOT`)
            NUMERIC = <file_path>, --Configuration here, or leave empty to use default ('countries_numeric.txt'; path relative from `data.ROOT`)
        }
    }
}
```

## datetime

`:Randiverse country <optional country flags>`

Generates a random datetime (or date or time). The random output is generated via creating a random date and then based on if it is datetime/date/time picking a corresponding format to decide what the output is. The default output is a datetime within the past 10 years. A format is selected from the dynamic map `data.datetime.formats.datetime/date/time` which holds the format string to select the required components from the random datetime in the desired style. By default, Randiverse comes bundled w/ iso, rfc, sortable, human, short, long, and epoch formats; however, this is configurable. The default format to use for the datetime/date/time is known from a dynamic map `data.datetime.default_formats` with a key for each. 

| Flag | Description | Value |
|:-----|:------------|:------|
| `-d/--date` | Return the date component. <br/>Example: '`-d`' would toggle the output to use the `data.datetime.formats.date` formats if only toggled component | None |
| `-t/--time` | Return the time component. <br/>Example: '`-t`' would toggle the output to use the `data.datetime.formats.time` formats if only toggled component | None |
| `-f/--format format` | Set the output format for the datetime/date/time. <br/>Example: '`-f sortable`' would change the output for datetime from default to 'sortable' ("%Y%m%d%H%M%S"). | String; Key in the corresponding '`data.datetime.formats.datetime/date/time`' map |

Default Keymap: `<leader>rd`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        datetime: {
            formats: {
                datetime = {
                    <format_name>: <format_string>, -- Configuration here, or leave empty to use default
                    ... (more mappings) ...
                },
                date = {
                    <format_name>: <format_string>, -- Configuration here, or leave empty to use default
                    ... (more mappings) ...
                },
                time = {
                    <format_name>: <format_string>, -- Configuration here, or leave empty to use default
                    ... (more mappings) ...
                },
            },
            default_formats = {
                datetime = <key>, --Configuration here, or leave empty to use default: 'iso'; key in `data.datetime.formats.datetime`
                date = <key>, --Configuration here, or leave empty to use default: 'iso'; key in `data.datetime.formats.time`
                time = <key>, --Configuration here, or leave empty to use default: 'iso'; key in `data.datetime.formats.time`
            },
        }
    }
}
```

## email

`:Randiverse email <optional email flags>`

Generates a random (fictitious) email address. Generated emails have the general pattern: `<first|last><separator><first|last><digits><specials>@<random_domain><random_tld>` The names used for email addresses are generated via random selection from the first + last name corpus files used for 'name' command. By default, the email address is lowercase, has NO special/digital characters nor a separator character, and is not 'muddled' (scrambled username characters). The list of domains, tlds, digits, and special characters is configurable.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-c/--capitalize` | Return the first/last name in the email captialized. <br/>Example: '`-c` would toggle the output from `kimbrabulman@mail.com` —> `KimbraBulman@mail.com`  | None |
| `-d/--digits digits` | Set the number of digits to append to the username (default is 0). <br/>Example: '`-d 2` would change output from `kimbrabulman@mail.com` to something like `kimbrabulman21@mail.com`  | Non-negative Integer |
| `-s/--specials specials` | Set the number of specials to append to the username (default is 0). <br/>Example: `-s 1` would change output from `kimbrabulman@mail.com` to something like `kimbrabulman!@mail.com` | Non-negative Integer |
| `-S/--separate` | Return the email with first/last name having a separator inserted between. <br/>Example: `-S` would change output from `kimbrabulman@mail.com` to something like `kimbra.bulman@mail.com` | None |
| `-m/--muddle-property` | Set the 'muddleness'—how scrambled the username characters are—for the email username. The property is passed as a decimal in \[0,1\] and is the likelihood that a character in the final username will be moved to a different location. <br/>Example: `-m .2` would slightly scramble the output from `kimbrabulman@mail.com` to something like `mikbrabmluan@mail.com` | Decimal in \[0,1\] |

Default Keymap: `<leader>re`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        email: {
            domains = <list> --Configuration here, or leave empty to use default: { "example", "company", "mail", "test", "random" }
            tlds = <list> --Configuration here, or leave empty to use default: { "com", "net", "org", "dev", "edu" }
            digits = <list> --Configuration here, or leave empty to use default: { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
            specials = <list> --Configuration here, or leave empty to use default: { "!", "#", "$", "%", "^", "&", "*" }
            separators = <list> --Configuration here, or leave empty to use default: { "_", "-", "." }
            default_digits = <int> --Configuration here, or leave empty to use default: 0
            default_specials = <int> --Configuration here, or leave empty to use default: 0
            default_muddle_property = <int> --Configuration here, or leave empty to use default: 0.0
        }
    }
}
```

## url

`:Randiverse url <optional url flags>`

Generates a random (fictitious) url. Generated urls have the general pattern: `<random_protocol>://<subdomains>.<random_domain>.<random_tld>/<paths>?<query_params>#<fragment>`. By default, the url has no subdomains, no paths, no query parameters, nor a fragment. Additionally, the word corpuses from the 'word' command are used to generate the url.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-s/--subdomains subdomains` | Return the first/last name in the email captialized. <br/>Example: '`-c` would toggle the output from `kimbrabulman@mail.com` —> `KimbraBulman@mail.com`.  | None |
| `-p/--paths paths` | Set the number of digits to append to the username (default is 0). <br/>Example: '`-d 2` would change output from `kimbrabulman@mail.com` to something like `kimbrabulman21@mail.com`.  | Non-negative Integer |
| `-q/--query-params queryparams` | Set the number of specials to append to the username (default is 0). <br/>Example: `-s 1` would change output from `kimbrabulman@mail.com` to something like `kimbrabulman!@mail.com` | Non-negative Integer |
| `-f/--fragement` | Return the email with first/last name having a separator inserted between. <br/>Example: `-S` would change output from `kimbrabulman@mail.com` to something like `kimbra.bulman@mail.com` | None |

Default Keymap: `<leader>ru`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        url = {
            protocols = <list> --Configuration here, or leave empty to use default: { "http", "https" }
            tlds = <list> --Configuration here, or leave empty to use default: { "com", "org", "net", "edu", "gov" }
            default_domain_corpus = <string> --Configuration here, or leave empty to use default: "medium"; key in `data.word.corpuses`
            default_subdomain_corpus = <string> --Configuration here, or leave empty to use default: "short"; key in `data.word.corpuses`
            default_path_corpus = <string> --Configuration here, or leave empty to use default: "medium"; key in `data.word.corpuses`
            default_fragment_corpus = <string> --Configuration here, or leave empty to use default: "long"; key in `data.word.corpuses`
            default_param_corpus = <string> --Configuration here, or leave empty to use default: "medium"; key in `data.word.corpuses`
            default_value_corpus = <string> --Configuration here, or leave empty to use default: "medium"; key in `data.word.corpuses`
            default_subdomains = <int> --Configuration here, or leave empty to use default: 0
            default_paths = <int> --Configuration here, or leave empty to use default: 0
            default_query_params = <int> --Configuration here, or leave empty to use default: 0
        }
    }
}
```

## uuid

`:Randiverse uuid <optional uuid flags>`

Generates a random uuid. The default output has uppercase hexadecimals and is UUIDv4.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-l/--lowercase` | Return the output with hexadecimals lowercase where applicable. <br/>Example: '`-l`' would change output '`18E75D7B-5BD8-4688-87B1-3D51EF560E19`' —> '`18e75d7b-5bd8-4688-87b1-3d51ef560e19`'. | None |

Default Keymap: `<leader>rU`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        uuid: {} --None
    }
}
```

## ip

`:Randiverse ip <optional ip flags>`

Generates a random ip. The default output is IPv4 standard and has uppercase hexadecimals.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-v/--version enum` | Set the ip version for the output. <br/>Example: '`-v ipv6`' would change output to '`XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX`' format, such as '`3D08:3A01:7856:bA7A:6F40:2073:D398:A5E8`'. | 4, 6, ipv4, ipv6 |
| `-l/--lowercase` | Return the output with hexadecimals lowercase where applicable. <br/>Example: '`-l`' would change IPv6 output '`3D08:3A01:7856:bA7A:6F40:2073:D398:A5E8`' —> '`3d08:3a01:7856:ba7a:6f40:2073:d398:a5e8`'. | None |

Default Keymap: `<leader>rI`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        ip: {} --None
    }
}
```

## hexcolor

`:Randiverse hexcolor <optional hexcolor flags>`

Generates a random hexcolor. The default output has uppercase hexadecimals and the format `#HHHHHH`.

| Flag | Description | Value |
|:-----|:------------|:------|
| `-l/--lowercase` | Return the output with hexadecimals lowercase where applicable. <br/>Example: '`-l`' would change output '`#A4B16C`' —> '`#a4b16c`'. | None |

Default Keymap: `<leader>rh`

**Insert Demo Video**

Configurations:

```lua
{
    data: {
        hexcolor: {} --None
    }
}
```

# Configuration🏗️

Configurations can be used to change the base functionality of the command generators as well as customize which corpuses (bodies of text) are used for random text creation. Additionally, configurations enable/disable keymaps and can change what each commands keymap, command, and description is to whatever is desired.

Additionally, each of the keymaps have changeable behavior and keymaps to whatever you desire (default is there).

Below are the randiverse.nvim configurations and their default values w/ explanations:

```lua
{
    enabled = true,
    keymaps_enabled = true,
    keymaps = {
        country = {
            keymap = "<leader>rc",
            command = "country",
            desc = "Generates a random country",
            enabled = true,
        },
        datetime = {
            keymap = "<leader>rd",
            command = "datetime",
            desc = "Generates a random datetime",
            enabled = true,
        },
        email = {
            keymap = "<leader>re",
            command = "email",
            desc = "Generates a random email address",
            enabled = true,
        },
        float = {
            keymap = "<leader>rf",
            command = "float",
            desc = "Generates a random float",
            enabled = true,
        },
        hexcolor = {
            keymap = "<leader>rh",
            command = "hexcolor",
            desc = "Generates a random hexcolor",
            enabled = true,
        },
        int = {
            keymap = "<leader>ri",
            command = "int",
            desc = "Generates a random integer",
            enabled = true,
        },
        ip = {
            keymap = "<leader>rI",
            command = "ip",
            desc = "Generates a random ip",
            enabled = true,
        },
        lorem = {
            keymap = "<leader>rl",
            command = "lorem",
            desc = "Generates random lorem ipsum text",
            enabled = true,
        },
        name = {
            keymap = "<leader>rn",
            command = "name",
            desc = "Generates a random name",
            enabled = true,
        },
        url = {
            keymap = "<leader>ru",
            command = "url",
            desc = "Generates a random url",
            enabled = true,
        },
        uuid = {
            keymap = "<leader>rU",
            command = "uuid",
            desc = "Generates a random uuid",
            enabled = true,
        },
        word = {
            keymap = "<leader>rw",
            command = "word",
            desc = "Generates a random word",
            enabled = true,
        },
    },
    data = {
        ROOT = (function()
            local path = debug.getinfo(1, "S").source:sub(2)
            path = path:match("(.*/)")
            return path .. "data/"
        end)(),
        country = {
            COUNTRIES = "countries.txt",
            ALPHA2 = "countries_alpha2.txt",
            ALPHA3 = "countries_alpha3.txt",
            NUMERIC = "countries_numeric.txt",
        },
        datetime = {
            formats = {
                datetime = {
                    iso = "%Y-%m-%dT%H:%M:%SZ",
                    rfc = "%a, %d %b %Y %H:%M:%S",
                    sortable = "%Y%m%d%H%M%S",
                    human = "%B %d, %Y %I:%M:%S %p",
                    short = "%m/%d/%y %H:%M:%S",
                    long = "%A, %B %d, %Y %I:%M:%S %p",
                    epoch = "%s",
                },
                date = {
                    iso = "%Y-%m-%d",
                    rfc = "%a, %d %b %Y",
                    sortable = "%Y%m%d",
                    human = "%B %d, %Y",
                    short = "%m/%d/%y",
                    long = "%A, %B %d, %Y",
                    epoch = "%s",
                },
                time = {
                    iso = "%H:%M:%S",
                    rfc = "%H:%M:%S",
                    sortable = "%H%M%S",
                    human = "%I:%M:%S %p",
                    short = "%H:%M:%S",
                    long = "%%I:%M:%S %p",
                },
            },
            default_formats = {
                datetime = "iso",
                date = "iso",
                time = "iso",
            },
        },
        email = {
            domains = { "example", "company", "mail", "test", "random" },
            tlds = { "com", "net", "org", "dev", "edu" },
            digits = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" },
            specials = { "!", "#", "$", "%", "^", "&", "*" },
            separators = { "_", "-", "." },
            default_digits = 0,
            default_specials = 0,
            default_muddle_property = 0.0,
        },
        float = {
            default_start = 1,
            default_stop = 100,
            default_decimals = 2,
        },
        int = {
            default_start = 1,
            default_stop = 100,
        },
        lorem = {
            corpuses = {
                ["lorem"] = "words_lorem.txt",
            },
            sentence_lengths = {
                ["short"] = { 5, 20 },
                ["medium"] = { 20, 40 },
                ["long"] = { 40, 60 },
                ["mixed-short"] = { 5, 30 },
                ["mixed"] = { 5, 100 },
                ["mixed-long"] = { 30, 100 },
            },
            default_corpus = "lorem",
            default_sentence_length = "mixed-short",
            default_comma_property = 0.1,
            default_length = 100,
        },
        name = {
            FIRST = "names_first.txt",
            LAST = "names_last.txt",
        },
        url = {
            protocols = { "http", "https" },
            tlds = { "com", "org", "net", "edu", "gov" },
            default_domain_corpus = "medium",
            default_subdomain_corpus = "short",
            default_path_corpus = "medium",
            default_fragment_corpus = "long",
            default_param_corpus = "medium",
            default_value_corpus = "medium",
            default_subdomains = 0,
            default_paths = 0,
            default_query_params = 0,
        },
        word = {
            corpuses = {
                ["short"] = "words_short.txt",
                ["medium"] = "words_medium.txt",
                ["long"] = "words_long.txt",
            },
            default_corpus = "medium",
            default_length = 1,
        },
    },
}
```

To configure randiverse.nvim, simply pass in a map to the setup function containing ONLY the default configuration values that you wish to override. For example, lets install the plugin (w/ Lazy) and override the keymap for name command to return a first name on keymap press and also override the xyz: Plus say we want default emails to include specials, if we use the keymaps we could do this! Or, we could update the command properties to change the default so it is used for default call: 

```lua
  {
    "ty-labs/randiverse.nvim",
    version = "*",
    config = function()
      require("randiverse").setup({
        keymaps = {
          country = {
            command = "name -f",
          },
        },
      })
    end,
  },
```

# Contributing✍️

I've included what I hope is a decent starter + reasonable defaults (ported over pretty much everything from 'Random Everything' and then some); however, I'm always looking for new random text commands + new flags/enhancements that people think are useful. Feel free to mark and issue on the project or try handling it yourself! Thanks!

# Shoutouts📢

- [Random Everything](https://github.com/helixquar/randomeverything)         —> Original inspiration as a revamped version of the VScode extension
- [Random Text](https://github.com/kimpettersen/random-sublime-text-plugin)  —> Sublime random text generator which Random Everything was based on
- [Lorem Ipsum Generator](https://github.com/derektata/lorem.nvim)           —> Inspiration for building the Lorem Ipsum generator feature
- [nvim-surround](https://github.com/kylechui/nvim-surround/tree/main)       —> General structure for writing nvim plugins
- If you like this project consider a [star⭐](https://github.com/ty-labs/randiverse.nvim/tree/main) to show your support!
