# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "http://www.nethack.org/"
  url "https://downloads.sourceforge.net/project/nethack/nethack/3.6.0/nethack-360-src.tgz"
  version "3.6.0"
  sha256 "1ade698d8458b8d87a4721444cb73f178c74ed1b6fde537c12000f8edf2cb18a"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.0"

  bottle do
    rebuild 1
    sha256 "2ad13f744ebe5be50a1a79fc510a6af2c391ee5644c3615631a1f63ac989e185" => :sierra
    sha256 "61183b1da0201ebb2cb4525afdb08ad1295bc0e2a4558cf4b2055e87be5f0bec" => :el_capitan
    sha256 "7f4a67110d90c64f9ecdcff2b28b39753fb4e22496a229f3346cc458f1b1746e" => :yosemite
  end

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    # Generate makefiles for OS X
    cd "sys/unix" do
      if MacOS.version >= :yosemite
        hintfile = "macosx10.10"
      elsif MacOS.version >= :lion
        hintfile = "macosx10.7"
      elsif MacOS.version >= :leopard
        hintfile = "macosx10.5"
      else
        hintfile = "macosx"
      end

      inreplace "hints/#{hintfile}",
                /^HACKDIR=.*/,
                "HACKDIR=#{libexec}"

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    # Enable wizard mode for all users
    inreplace "sys/unix/sysconf",
      /^WIZARDS=.*/,
      "WIZARDS=*"

    # Make the game
    system "make", "install"
    bin.install "src/nethack"
    (libexec+"save").mkpath

    # Enable `man nethack`
    man6.install "doc/nethack.6"

    # These need to be group-writable in multi-user situations
    chmod "g+w", libexec
    chmod "g+w", libexec+"save"
  end
end
