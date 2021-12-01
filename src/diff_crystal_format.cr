#!/usr/bin/env crystal
#
# Crystal format change previewer:
# dryrun "crystal tool format" and show the changes
#
# requirements: Crystal, GNU diff
#
# usage: diff_crystal_format [FILES] [DIRS]

require "file_utils"

module DiffCrystalFormat
  VERSION = "0.1.0"

  # Returns string with characters unsuitable for file paths replaced.
  def self.safe_fname(fname)
    fname.gsub(/\//, ".") # FIXME: make directory names readable.
  end

  # Returns file names which will be changed.
  def self.fnames_with_changes(dirnames_or_fnames = [] of String)
    # Dryrun messages are printed to stderr.
    cmd = "crystal tool format --check #{dirnames_or_fnames.join(" ")} 2>&1"
    `#{cmd}`.scan(/'(.*)'/).map { |m| m[1] }
  end

  # Returns diffs of files which will be changed.
  def self.diffs(fnames, diff_opts = ["-u"])
    fnames.map { |fn|
      pn = File.basename(PROGRAM_NAME)
      content = File.read(fn)
      tf_orig = File.tempfile(safe_fname([pn, fn, "orig"].join("_"))) { |f|
        File.write(f.path, content)
      }
      tf_formatted = File.tempfile(safe_fname([pn, fn].join("_"))) { |f|
        File.write(f.path, content)
      }
      # Discard progress messages on stdout which can be noisy when running specs.
      system("crystal tool format #{tf_formatted.path} 1>/dev/null")
      diff = `diff #{diff_opts.join(" ")} #{tf_orig.path} #{tf_formatted.path}`
      [tf_orig, tf_formatted].each { |fn| fn.delete }
      diff
    }
  end

  # Kludgey equivalent for Ruby's `$PROGRAM_NAME == __FILE__` idiom.
  def self.invoked_as_an_application?
    File.basename(PROGRAM_NAME, ".tmp").sub(/^crystal-run-/, "") ==
      File.basename(__FILE__, ".cr")
  end

  # Runs the application.
  def self.run(argv = ARGV)
    fnames = DiffCrystalFormat.fnames_with_changes(argv)
    diff_opts = ["-u"]
    diff_opts.push "--color=always" if STDOUT.tty?
    DiffCrystalFormat.diffs(fnames, diff_opts).each { |diff| puts diff }
  end
end

if DiffCrystalFormat.invoked_as_an_application?
  DiffCrystalFormat.run
end
