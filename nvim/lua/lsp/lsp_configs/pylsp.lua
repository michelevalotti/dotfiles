local settings = {
    pylsp = {
        plugins = {
            autopep8 = {
                enabled = false,
            },
            flake8 = {
                enabled = false,
            },
            jedi_completion = {
                enabled = true,
            },
            mccabe = {
                enabled = false,
            },
            pycodestyle = {
                enabled = false,
            },
            pyflakes = {
                enabled = false,
            },
            pylint = {
                enabled = false,
            },
            rope_autoimport = {
                enabled = true,
            },
            yapf = {
                enabled = false,
            },
        },
    },
}

return settings
