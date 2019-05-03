class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://deb.debian.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.0.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-5.0.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0.tar.gz"
    sha256 "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
    version "5.0.7"

    %w[
      001 f2fe9e1f0faddf14ab9bfa88d450a75e5d028fedafad23b88716bd657c737289
      002 87e87d3542e598799adb3e7e01c8165bc743e136a400ed0de015845f7ff68707
      003 4eebcdc37b13793a232c5f2f498a5fcbf7da0ecb3da2059391c096db620ec85b
      004 14447ad832add8ecfafdce5384badd933697b559c4688d6b9e3d36ff36c62f08
      005 5bf54dd9bd2c211d2bfb34a49e2c741f2ed5e338767e9ce9f4d41254bf9f8276
      006 d68529a6ff201b6ff5915318ab12fc16b8a0ebb77fda3308303fcc1e13398420
      007 17b41e7ee3673d8887dd25992417a398677533ab8827938aa41fad70df19af9b
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://deb.debian.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://gnu.cu.be/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "086c6f11339281c5b11fd2f969b993b4a268c57da0b65fdac78dcb4d423a2002" => :mojave
    sha256 "648150fc42c03368021a46c7bf5f30d2a1595efc9a8472542089e92b96b23ea6" => :high_sierra
    sha256 "39f0e67eb43617ef444f6ae31a95be9ff06330f14f012a4226ddbb5153f6bede" => :sierra
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
