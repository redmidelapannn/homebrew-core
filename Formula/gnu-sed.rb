class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftpmirror.gnu.org/sed/sed-4.2.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.bz2"
  sha256 "f048d1838da284c8bc9753e4506b85a1e0cc1ea8999d36f6995bcb9460cddbd7"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "71b2b326e458a96341e1033e9dcaf6fc4da0e567836bae64414602aa631a8cdf" => :sierra
    sha256 "45123ca73e20eb1c1651813e18c3e3efc4820405f6b770fb1c02bf867e69282a" => :el_capitan
    sha256 "4ec3bfe616e3eb2a0dc9a2a720b8cbccbd6959630ee6858d940946ad47a5b809" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  deprecated_option "default-names" => "with-default-names"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names" option.

      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:
        MANPATH="#{opt_libexec}/gnuman:$MANPATH"
      EOS
    end
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    if build.with? "default-names"
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    else
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match /Hello World!/, File.read("test.txt")
  end
end
