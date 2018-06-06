class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/minicom/minicom_2.7.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/minicom/minicom_2.7.1.orig.tar.gz"
  sha256 "532f836b7a677eb0cb1dca8d70302b73729c3d30df26d58368d712e5cca041f1"

  bottle do
    rebuild 1
    sha256 "434bd42c219df87f795c74490ffee2ee324504b12a31c04be2127878a5425be0" => :high_sierra
    sha256 "bf154a9c60311f83569eda851d2084e793c420127570200946c686644a2d718f" => :sierra
    sha256 "1baedd7991d9922445491111ce2395b64ed5ceece0482fca128da7af1a262d2a" => :el_capitan
  end

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats; <<~EOS
    Terminal Compatibility
    ======================
    If minicom doesn't see the LANG variable, it will try to fallback to
    make the layout more compatible, but uglier. Certain unsupported
    encodings will completely render the UI useless, so if the UI looks
    strange, try setting the following environment variable:

      LANG="en_US.UTF-8"

    Text Input Not Working
    ======================
    Most development boards require Serial port setup -> Hardware Flow
    Control to be set to "No" to input text.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v", 1)
  end
end
