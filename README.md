DiffCrystalFormat
========

DiffCrystalFormat is a [Crystal](https://crystal-lang.org) formatting
previewer.

Crystal's built-in formatter (`crystal tool format`) is very useful and
helpful. Its dry-run mode (`crystal tool format --check`), however, tells us
only the file names which will produce changes and not the changes
themselves (as of Crystal 1.2.1). DiffCrystalFormat shows the changes the
formatter will make, in `diff` format.

## Requirements

  * Build time
    - Crystal
    - Shards (usually bundled with Crystal)
  * Run time
    - GNU diff

## Installation

  1. Install requirements (if needed).

     ```
     $ sudo apt install crystal diffutils
     ```

  2. Obtain the source.

     ```
     $ git clone https://github.com/hisashim/diffcrystalformat
     $ cd diffcrystalformat
     ```

  3. Build an executable, and copy it to somewhere in your `$PATH`.

     ```
     $ make
     $ cp bin/diff_crystal_format ~/bin/
     ```

## Usage

```
diff_crystal_format [FILES] [DIRS]
```

### Examples

```
$ echo "[0,1,2].map{|n| n+1}" > test.cr

$ cat test.cr
[0,1,2].map{|n| n+1}

$ diff_crystal_format
--- /tmp/...diff_crystal_format_..test_cr_orig ...
+++ /tmp/...diff_crystal_format_..test_cr      ...
@@ -1 +1 @@
-[0,1,2].map{|n| n+1}
+[0, 1, 2].map { |n| n + 1 }
$
```

## Known Issues

  * File names displayed are not human-friendly, as slashes (`/`) are just
    replaced with dots (`.`), due to my laziness.

## License

This software is distributed under the MIT License. See the
[LICENSE](LICENSE) file.

## Contributing

  1. Fork it (<https://github.com/hisashim/diffcrystalformat/fork>)
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request

## Contributors

  * [Hisashi Morita](https://github.com/hisashim) -- creator and maintainer
