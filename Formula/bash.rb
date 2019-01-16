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
    rebuild 1
    sha256 "ee05f0384ca7a3db0bb87f437a3b1deb43e40d1a1bc0780395de0813bd902dd8" => :mojave
    sha256 "075451feff5cf483ece7d40ab6fd1ce062d0ed14fc830e8bd5e4b692700fd04c" => :high_sierra
    sha256 "23834773db2f37ed098ce4bad167eff1a50a5cd133dd1d82e1886ebafa457d18" => :sierra
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

    (libexec/"bin").install_symlink (bin/"bash").realpath => "sh"
    (libexec/"bin").install_symlink (bin/"bash").realpath => "rbash"
  end

  def caveats; <<~EOS
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.

    Alternate invocation names `sh` and `rbash` both symlinked to
    `bash`, have been installed into
      #{opt_libexec}/bin
  EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
