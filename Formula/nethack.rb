# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.2/nethack-362-src.tgz"
  version "3.6.2"
  sha256 "fbd00ada6a4ee347ecd4a350a5b2995b4b4ab5dcc63881b3bc4485b0479ddb1d"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.2"

  bottle do
    rebuild 1
    sha256 "56db56ab09d1480daf29cbd0aca4b66971dfbca607cd5db315c74aa6f12e31e2" => :mojave
    sha256 "4fef58b3639a3fd4778377c9755cf03bf15d41e4f106a77ecda69f26535beb3c" => :high_sierra
    sha256 "c046e0a764623c9d945dd63b5d47e626de78fba9de3e9ddff2e5f7657e2f59a3" => :sierra
  end

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order
    ENV.deparallelize

    # Generate makefiles for OS X
    cd "sys/unix" do
      if MacOS.version >= :mojave
        hintfile = "macosx10.14"
      elsif MacOS.version >= :yosemite
        hintfile = "macosx10.10"
      else
        hintfile = "macosx10.7"
      end

      inreplace "hints/#{hintfile}",
                /^HACKDIR=.*/,
                "HACKDIR=#{libexec}"

      if MacOS.version >= :mojave
        # Also build the new curses interface
        inreplace "hints/#{hintfile}",
                  /^#WANT_WIN_CURSES=1$/,
                  "WANT_WIN_CURSES=1"
      end

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

  if MacOS.version >= :mojave
    def caveats
      <<~EOS
        You can activate the new curses interface using
        NETHACKOPTIONS=windowtype:curses on the CLI or by editing your
        options file at `~/Library/Preferences/NetHack Defaults.txt`
      EOS
    end
  end

  test do
    system "#{bin}/nethack", "--version"
  end
end
