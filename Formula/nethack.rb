# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://downloads.sourceforge.net/project/nethack/nethack/3.6.0/nethack-360-src.tgz"
  version "3.6.0"
  sha256 "1ade698d8458b8d87a4721444cb73f178c74ed1b6fde537c12000f8edf2cb18a"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.0"

  bottle do
    rebuild 1
    sha256 "17bb09293c1ac5758691bac2ab289c6269dc43976b561f0b4b245d623d2ab741" => :high_sierra
    sha256 "0755260c8c3baf64ee9b29d4128e6289f3a998c1d826b65d060bd962b05951df" => :sierra
    sha256 "8b24172b181c5c349812cc7d6a5aa4bb118cf0050d9aba28e25fe22f4f2250c7" => :el_capitan
  end

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order
    ENV.deparallelize

    # Generate makefiles for OS X
    cd "sys/unix" do
      if MacOS.version >= :yosemite
        hintfile = "macosx10.10"
      elsif MacOS.version >= :lion
        hintfile = "macosx10.7"
      else
        hintfile = "macosx10.5"
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

  test do
    assert_match "NetHack, Copyright 1985-2015", shell_output("#{bin}/nethack")
  end
end
