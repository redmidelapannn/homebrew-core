class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.11.tar.gz"
  sha256 "baea9596ed251910b176a2bdcd46d78ab68f6aa4e066f70ca0d6153e32df54fb"
  revision 1

  bottle do
    rebuild 1
    sha256 "f9e719f7f46613696b5367249f1d3a463ab3d4fb57aa47485f04a1b25c6171be" => :high_sierra
    sha256 "bf651efa550b3fa3159530bc465d15a4f85213822bdcd7386fdf4350819cc2cf" => :sierra
    sha256 "40ea827f785feb3e06ed034380ff6ff7064ce9bb020b87067779ca6afcecab72" => :el_capitan
  end

  depends_on "lua"
  depends_on "pcre"
  depends_on "openssl"

  def install
    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", "#{s.get_make_var "CFLAGS"} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats; <<~EOS
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
