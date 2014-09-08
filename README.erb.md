# FileUtilsSimple

A cut down version of FileUtils
(<%= File.size('../mrblib/main.rb')/1024 %>KB vs. 47KB) for mruby.

The primary use of this mrbgem is minirake.

Commands are accessible through `FileUtilsSimple` module. For example:

	include FileUtilsSimple
	mkdir 'foo/bar', verbose: true

Available options: `:verbose`, `:noop`.

It is possible to include `FileUtilsSimple::DryRun`,
`FileUtilsSimple::Verbose` & `FileUtilsSimple::NoWrite`. Then options
for each command are set automatically. (You can still access original
versions via `FileUtilsSimple` module, like `FileUtilsSimple.mkdir`.)

## User Commands

```
<%= `./extract-user-commands` %>
```

## BUGS

* Once `FileUtilsSimple::DryRun` is imported, additional options for
  commands are ignored.

## License

MIT.
