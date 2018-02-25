class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
  sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"

  bottle do
    rebuild 2
    sha256 "88d3041f553a3e0b6086f44f1ad67190939b36bd5679f9e6c2d9959368a0142a" => :high_sierra
    sha256 "ad7a22712e3eec10623835aa2b0d55da8112884f1accd591fe4ad24e2abae124" => :sierra
    sha256 "67ec7c03f855d0dc7d5d894b02e5b99d6d9e19d4d28cf323aa69b18fe3e5a3b3" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "libidn"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-idn
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
      # Binaries not shadowing macOS utils symlinked without 'g' prefix
      noshadow = %w[dnsdomainname rcp rexec rlogin rsh]
      noshadow += %w[ftp telnet] if MacOS.version >= :high_sierra
      noshadow.each do |cmd|
        bin.install_symlink "g#{cmd}" => cmd
        man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
      end

      # Symlink commands without 'g' prefix into libexec/gnubin and
      # man pages into libexec/gnuman
      bin.find.each do |path|
        next unless File.executable?(path) && !File.directory?(path)
        cmd = path.basename.to_s.sub(/^g/, "")
        (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
        (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
      end
    end
  end

  def caveats
    noshadow = %w[dnsdomainname rcp rexec rlogin rsh]
    noshadow += %w[ftp telnet] if MacOS.version >= :high_sierra
    if build.without? "default-names" then <<~EOS
      The following commands have been installed with the prefix 'g'.

          #{noshadow.join("\n    ")}

      If you really need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:

          MANPATH="#{opt_libexec}/gnuman:$MANPATH"
      EOS
    end
  end

  test do
    output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end
