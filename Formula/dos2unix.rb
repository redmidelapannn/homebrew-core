class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.5.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.3.5.tar.gz"
  sha256 "a72caa2fb5cb739403315472fe522eda41aabab2a02ad6f5589639330af262e5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "75478a32066ec44f57b88221e1887607ab1345c4357b2b3b47f5cd5a8bb3114b" => :high_sierra
    sha256 "70e043e87c43d255cb2da7e87062587bb904480e9ce1fa791b3e412363429cec" => :sierra
    sha256 "5321c48872ab5328117fed3dffd4495caf347e4cebc30e126679f04347e35238" => :el_capitan
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "gettext" => :optional

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      install
    ]

    if build.without? "gettext"
      args << "ENABLE_NLS="
    else
      gettext = Formula["gettext"]
      args << "CFLAGS_OS=-I#{gettext.include}"
      args << "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl"
    end

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
