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
  def self.escape_fname(fname)
    fname.gsub(/[\/.]/, "_")
  end

  def self.fnames_with_changes(args = [] of String)
    cmd = "crystal tool format --check #{args.join(' ')} 2>&1"
    `#{cmd}`.scan(/'(.*)'/).map { |m| m[1] }
  end

  def self.diffs(fnames, diff_opts)
    fnames.map { |fn|
      pn = File.basename(PROGRAM_NAME)
      content = File.read(fn)
      tfn_orig = File.tempfile(escape_fname([pn, fn, "orig"].join("_"))) { |f|
        File.write(f.path, content)
      }
      tfn_formatted = File.tempfile(escape_fname([pn, fn].join("_"))) { |f|
        File.write(f.path, content)
      }
      system("crystal tool format #{tfn_formatted.path}")
      diff = `diff -u #{diff_opts} #{tfn_orig.path} #{tfn_formatted.path}`
      [tfn_orig, tfn_formatted].each { |fn| fn.delete }
      diff
    }
  end

  def self.main(argv = ARGV)
    fnames = DiffCrystalFormat.fnames_with_changes(argv)
    diff_opts = STDOUT.tty? ? "--color=always" : ""
    DiffCrystalFormat.diffs(fnames, diff_opts).each { |diff| puts diff }
  end

  # kludgey equivalent for Ruby's "$0 == __FILE__" idiom
  def self.called_as_a_script?
    File.basename(PROGRAM_NAME, ".tmp").sub(/^crystal-run-/, "") ==
      File.basename(__FILE__, ".cr")
  end
end

if DiffCrystalFormat.called_as_a_script?
  DiffCrystalFormat.main
end
