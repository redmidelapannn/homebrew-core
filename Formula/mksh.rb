class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R51.tgz"
  mirror "https://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R51.tgz"
  sha256 "9feeaa5ff33d8199c0123675dec29785943ffc67152d58d431802bc20765dadf"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a9a91033514d5b476a1b827634fc794c8ea583c1dbb609189dfb68fddb332057" => :el_capitan
    sha256 "e249eec962c21f01d0fbdd864eb486dd982708fc1559a725c2b3a9e60b89951b" => :yosemite
    sha256 "c60a7568bcc9a66c4a263f0060261f98367cb109fde51c07c350ee19cb5ad6c5" => :mavericks
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang ? "lto" : "combine")
    bin.install "mksh"
    man1.install "mksh.1"
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run `chsh` to change their shell.
    EOS
  end

  test do
    assert_equal "honk",
      shell_output("mksh -c 'echo honk'").chomp
  end
end
