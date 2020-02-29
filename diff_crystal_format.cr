require "file_utils"

module DiffCrystalFormat
  def self.escape_fname(fname)
    fname.gsub(/[\/.]/, "_")
  end

  def self.formatted_fnames(dir = "")
    cmd = "crystal tool format --check #{dir} 2>&1"
    `#{cmd}`.scan(/'(.*)'/).map { |m| m[1] }
  end

  def self.diffs(fnames, diff_opts)
    diffs = fnames.map { |fn|
      pn = File.basename(PROGRAM_NAME)
      content = File.read(fn)
      tf_orig =
        File.tempfile(escape_fname([pn, fn, "orig"].join("_"))) { |f|
          File.write(f.path, content)
        }
      tf_to_format =
        File.tempfile(escape_fname([pn, fn].join("_"))) { |f|
          File.write(f.path, content)
        }
      system("crystal tool format #{tf_to_format.path}")
      diff = `diff -u #{diff_opts} #{tf_orig.path} #{tf_to_format.path}`
      [tf_orig, tf_to_format].each { |tf| tf.delete }
      diff
    }
    diffs
  end

  def self.run
    fnames = DiffCrystalFormat.formatted_fnames
    diff_opts = (STDOUT.tty? ? "--color=always" : "")
    diffs = DiffCrystalFormat.diffs(fnames, diff_opts)
    diffs.each { |d| puts d }
  end
end

DiffCrystalFormat.run
