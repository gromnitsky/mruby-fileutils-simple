# FileUtilsSimple

A stripped down version of FileUtils (4KB vs. 47KB). It delegates all
hard work to system tools.

The primary use of this mrbgem is
[minirake](https://github.com/gromnitsky/minirake).

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
cd(dir, &block)
chmod(mode, list)
chmod_R(mode, list)
chown(user, group, list)
chown_R(user, group, list)
cp(src, dest)
cp_r(src, dest)
install(src, dest, [mode])
ln(src, dest)
ln_f(src, dest)
ln_s(src, dest)
ln_sf(src, dest)
mkdir(list)
mkdir_p(list)
mv(src, dest)
pwd()
rm_r(list)
rm_rf(list)
rmdir(list)
touch(list)

```

## BUGS

* Once `FileUtilsSimple::DryRun` is included, additional options for
  commands are ignored.

## License

MIT.
