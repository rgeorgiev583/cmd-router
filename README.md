# cmdproxy

*cmdproxy* is a simple program which looks at its executable name and first argument and decides which actual command (with its subcommand determined by the first argument) to invoke based on a simple INI-based configuration file.

## Limitations
* For the moment, it works only on Unix-like (i.e. POSIX-compliant) operating systems (library functions `strdup`, `basename` and `execve` have to be implemented).
* You must always provide a subcommand (i.e. the program won't work with whole commands).
* The configuration file's location is hardcoded to be at `/etc/cmdproxy.conf`.
* No proper error handling.

## Configuration file format

	[cmdproxy]
    ALIAS = COMMAND
    ...

    [ALIAS]
    SUBCOMMAND_ALIAS = SUBCOMMAND
    ...

Here the `cmdproxy` section contains the `ALIAS`es for each `COMMAND`, where each `ALIAS` is the name of the executable with which `cmdproxy` was started, and `COMMAND` is the actual command that should be executed for the given `ALIAS`.

`SUBCOMMAND_ALIAS` is the name of the alias of the `SUBCOMMAND` (i.e. the first argument passed when `ALIAS` is invoked).

## Usage

	$ ALIAS SUBCOMMAND_ALIAS args...

Example `/etc/cmdproxy.conf`:

    [cmdproxy]
    pm = bb-wrapper

    [pm]
    upgrade = -Syu --aur
    update  = -Sy --aur
    install = -S --aur
    remove  = -R --aur
    wipe    = -Rcsn --aur
    info    = -Si --aur
    search  = -Ss --aur

Here

	$ pm install firefox

"translates" to

	$ bb-wrapper -S --aur firefox

and

	$ pm remove firefox

becomes

	$ bb-wrapper -R --aur firefox

## Installation

	$ make
	$ sudo make install
    $ sudo make command NAME=ALIAS

where `ALIAS` is the desired invocation name.

## License

3-clause BSD.

## Contributing

Send me a pull request if you wish to improve the program.
