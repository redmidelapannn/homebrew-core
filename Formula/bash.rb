class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/bash/bash-5.0.tar.gz"
  mirror "https://gnu.cu.be/bash/bash-5.0.tar.gz"
  mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0.tar.gz"
  version "5.0.0"
  sha256 "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
  head "https://git.savannah.gnu.org/git/bash.git"

  bottle do
    sha256 "146666182c1443133ee6aa3a6f4ed35867dae4cb431f78e2ffb6e9faaf2d7394" => :mojave
    sha256 "de0293a18d1208a80444f5d1b0a33c44b7f328ba8e07214646e3405b5c1bb95f" => :high_sierra
    sha256 "d58a520a0ca3be4eb5c61d0bd9779c8ecf780d52b4b235043f048545717c9e33" => :sierra
    sha256 "291b5db2cc18c491f4a9e210bb2e61afa76632aac65a8dc4eec935e6cb475bd9" => :el_capitan
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
  EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
