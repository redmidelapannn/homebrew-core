class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftpmirror.gnu.org/bash/bash-4.4.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
  mirror "https://gnu.cu.be/bash/bash-4.4.tar.gz"
  mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4.tar.gz"
  sha256 "d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
  revision 1

  head "http://git.savannah.gnu.org/r/bash.git"

  bottle do
    rebuild 1
    sha256 "98c45980228a4e6e7bcf2db73668b1d7102b6b808a9de54f97b97a8e15325c48" => :sierra
    sha256 "29ba502da695c6dbc777b0a4416d1b5a9c39e22bfe62471876725cde0d2ce9a4" => :el_capitan
    sha256 "37161c6490625a80ef5b99710fece8fcb3bb29c5f0d30785fc30014e2a4cf69f" => :yosemite
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells:
      sudo -s
      echo #{HOMEBREW_PREFIX}/bin/bash >> /etc/shell
      exit

    To switch shells run:
      chsh -s #{HOMEBREW_PREFIX}/bin/bash
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end
